module Spree
  class BraintreeSource < ActiveRecord::Base
    has_one :payment, :as => :source

    validates :nonce, presence: true

    attr_accessible :nonce

    def actions
      %w{capture void credit}
    end

    def can_capture?(payment)
      payment.state == 'pending'
    end

    def can_void?(payment)
      payment.state != 'void'
    end

    def can_credit?(payment)
      return false unless payment.state == 'completed'
      return false unless payment.order.payment_state == 'credit_owed'
      payment.credit_allowed > 0
    end
  end
end