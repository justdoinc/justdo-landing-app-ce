share.contact_lib =
  contact_tpl:
    helpers:
      isSmtpConfigured: -> APP.helpers.isSmtpConfigured()
      queryParams: -> Router.current().params?.query
    events:
      "click .send-request": ->
        APP.justdo_analytics.JA({cat: "contact-request", act: "submit-attempt"})

        seialized_request_data = $(".request-contact-form").serializeArray()

        request_data = {}
        _.each seialized_request_data, (field) ->
          request_data[field.name] = field.value.trim()

        tz = moment.tz.guess()
        if _.isString tz
          request_data.tz = tz

        error_i18n = TAPi18n.__ "error"
        if _.isEmpty request_data.name
          error_message = "#{error_i18n}: #{TAPi18n.__ "err_first_name_empty"}"
          alert(error_message)
          APP.justdo_analytics.JA({cat: "contact-request", act: "invalid-form", val: error_message})

          return false
        else if not JustdoHelpers.common_regexps.email.test request_data.email
          error_message = "#{error_i18n}: #{TAPi18n.__ "err_email_invalid"}"
          alert(error_message)
          APP.justdo_analytics.JA({cat: "contact-request", act: "invalid-form", val: error_message})

          return false
        # Legal docs checking for case we'll bring the checkbox back
        #
        # else if not request_data["agree_terms"]
        #   error_message = "Error: You need to read and agree to the our terms and condition and privacy policy in order to continue."
        #   alert(error_message)
        #   APP.justdo_analytics.JA({cat: "contact-request", act: "invalid-form", val: error_message})

        #   return false
        else
          original_text = $(".send-request").html()
          block = ->
            $(".send-request").html(TAPi18n.__ "processing")
            $(".send-request").attr("disabled", "disabled")
            $(".send-request").addClass("disabled")
          release = ->
            $(".send-request").html(original_text)
            $(".send-request").removeAttr("disabled")
            $(".send-request").removeClass("disabled")
          succeeded = ->
            release()
            $(".request-contact-form").trigger("reset")
          failed = (err) ->
            release()

            APP.justdo_analytics.JA({cat: "contact-request", act: "submit-failed"})

            alert(err.reason)

          block()

          request_data.legal_docs_signed_names = ["terms_conditions", "privacy_policy"]

          Meteor.call "contactRequest", request_data, (err) ->
            if err?
              failed(err)

              return

            APP.justdo_analytics.JA({cat: "contact-request", act: "successful-submit"})

            succeeded()

            bootbox.dialog
              message: """
                <svg class="jd-icon"><use xlink:href="/layout/icons-feather-sprite.svg#check"></use></svg>
                <span><strong>#{TAPi18n.__ "thank_you"}.</strong><br>#{TAPi18n.__ "we_will_get_back_to_you_soon"}</span>
              """
              className: "bootbox-new-design bootbox-contact-successful"
              closeButton: false
              onEscape: ->
                return true
              buttons:
                close: 
                  label: TAPi18n.__ "close"
                  callback: ->
                    return true

          return
  
  