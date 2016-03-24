require "braintree"

module Spree
  class PaymentMethod::BraintreeVZero < PaymentMethod
    preference :environment, :string
    preference :merchant_id, :string
    preference :public_key, :string
    preference :private_key, :string
    preference :send_billing_address, :boolean, default: false

    attr_accessible :preferred_environment, :preferred_merchant_id, :preferred_public_key, :preferred_private_key, :preferred_send_billing_address

    def gateway_options
      {
        environment: preferred_environment.to_sym,
        merchant_id: preferred_merchant_id,
        public_key: preferred_public_key,
        private_key: preferred_private_key
      }
    end

    def braintree_gateway
      @braintree_gateway ||= ::Braintree::Gateway.new(gateway_options)
    end

    def payment_source_class
      BraintreeSource
    end

    def generate_client_token(options = {})
      braintree_gateway.client_token.generate(options)
    end

    def authorize(cents, source, options = {})
      result = braintree_gateway.transaction.sale payment_options(cents, source, options)
      handle_result(result)
    end

    def capture(money, authorization_code, options = {})
      result = braintree_gateway.transaction.submit_for_settlement(authorization_code, amount(money))
      handle_result(result)
    end

    def purchase(cents, source, options = {})
      result = braintree_gateway.transaction.sale payment_options(cents, source, options, true)
      handle_result(result)
    end

    def void(authorization_code, source = {}, options = {})
      result = braintree_gateway.transaction.void(authorization_code)
      handle_result(result)
    end

    def credit(cents, source, authorization_code, options = {})
      result = braintree_gateway.transaction.refund(authorization_code, amount(cents))
      handle_result(result)
    end

    private

    def payment_options(cents, source, options = {}, submit_for_settlement = false)
      params = [ :billing_address_id, :channel, :custom_fields, :descriptor, :device_data, :device_session_id,
                 :options, :order_id, :purchase_order_number, :recurring, :service_fee_amount, 
                 :shipping_address_id, :tax_amount, :tax_exempt ]
      opts = options.select {|k| params.include? k}
      opts[:amount] = amount(cents)
      opts[:payment_method_nonce] = source.nonce
      opts[:options] ||= {}
      opts[:options][:submit_for_settlement] = submit_for_settlement
      opts[:shipping] = map_address(options[:shipping_address]) if options[:shipping_address].present?
      opts[:billing] = map_address(options[:billing_address]) if preferred_send_billing_address && options[:billing_address].present?
      opts
    end

    def amount(cents)
      sprintf("%.2f", cents.to_f / 100)
    end

    def map_address(addr)
      full_name = addr.fetch(:name, "")
      *first_name_parts, last_name = full_name.split(" ")
      first_name = first_name_parts.join(" ")
      last_name ||= ""

      {
        first_name: first_name,
        last_name: last_name,
        street_address: addr[:address1],
        extended_address: addr[:address2],
        locality: addr[:city],
        region: addr[:state],
        country_code_alpha2: addr[:country],
        postal_code: addr[:zip],
      }
    end

    def order_description(order)
      "#{Spree::Config[:site_name]} #{I18n.t(:order).downcase} ##{order.number}"
    end

    def message_from_result(result)
      if result.success?
        "OK"
      elsif result.errors.count == 0 && result.credit_card_verification
        "Processor declined: #{result.credit_card_verification.processor_response_text} (#{result.credit_card_verification.processor_response_code})"
      elsif result.errors.count == 0 && result.transaction
        result.transaction.status
      else
        result.errors.map { |e| "#{e.message} (#{e.code})" }.join(" ")
      end
    end

    def handle_result(result)
      ActiveMerchant::Billing::Response.new(
        result.success?,
        message_from_result(result),
        {},
        { authorization: (result.transaction.id if result.success?) }
      )
    end

  end
end