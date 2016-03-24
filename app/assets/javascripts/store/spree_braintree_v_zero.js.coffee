//= require store/spree_core
//= require braintree-2.21.0.min.js

$ ->
  if $('#braintree-frame').is('*')
    braintreeFrame = $('#braintree-frame')
    paymentMethodsSelector = '#payment_selector input[type="radio"]'
    clientToken = braintreeFrame.data('client-token')
    paymentMethodId = braintreeFrame.data('payment-method-id')
    braintreeIntegration = null
    errMsgBlock = null

    setupBraintreeIntegration = ->
      if $('#order_payments_attributes__payment_method_id_' + paymentMethodId)[0].checked
        if !braintreeIntegration
          braintree.setup clientToken, "dropin", 
            container: "braintree-frame",
            onReady: (integration) ->
              braintreeIntegration = integration
            onPaymentMethodReceived: (payload) ->
              $('#braintree_nonce').val(payload.nonce)
              form = $('#braintree_nonce').parents('form')[0]
              HTMLFormElement.prototype.submit.call(form)
            onError: (payload) ->
              if !errMsgBlock
                errMsgBlock = $('#braintree-error-message')
              errMsgBlock.html payload.message
              errMsgBlock.show()
              setTimeout( 
                ->
                  $('#braintree-error-message').hide(1000)
                , 2000)

              $('input[type=submit]').removeClass 'disabled'
              $('input[type=submit]').prop 'disabled', false
      else
        if braintreeIntegration
          braintreeIntegration.teardown ->
            braintreeIntegration = null

    setupBraintreeIntegration()

    $(paymentMethodsSelector).click ->
      setupBraintreeIntegration()