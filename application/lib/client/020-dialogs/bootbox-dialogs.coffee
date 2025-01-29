default_bootbox_options =
  animate: false
  onEscape: true
  backdrop: true
  allow_rtl: false

_.extend APP.helpers,

  dialogs:
    termsAndConditions: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_legal_terms_conditions", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "terms-conditions-modal legal-bootbox"
        onEscape: -> true
        )
      )

    privacyPolicy: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_legal_privacy_policy", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "privacy-policy-modal legal-bootbox"
        onEscape: -> true 
        )
      )

    cookiePolicy: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_cookie_policy", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "legal-bootbox"
        onEscape: -> true 
        )
      )


    onPremiseTerms: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_legal_on_premise_setup_terms", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "on-premises-terms-modal legal-bootbox"
        onEscape: -> true 
        )
      )

    copyrightNotice: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_legal_copyright", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "copyright-notice-modal legal-bootbox"
        onEscape: -> true 
        )
      )

    privacyShieldNotice: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_legal_privacy_shield", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "privacy-shield-notice-modal legal-bootbox"
        onEscape: -> true 
        )
      )
    
    promotersTermsAndConditions: ->
      # If a bootbox already open, prevent opening
      if $(".bootbox").length != 0
        return

      message_template = APP.helpers.renderTemplateInNewNode("justdo_promoters_terms_conditions", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "terms-conditions-modal legal-bootbox"
        onEscape: -> true 
        )
      )


    testDrive: ->
      message_template = APP.helpers.renderTemplateInNewNode("test_drive", {})

      return bootbox.dialog(_.extend({}, default_bootbox_options,
        message: message_template.node
        className: "test-drive-modal"
        )
      )

# Add Justdo Analytics tracking
for dialog_id, dialog_func of APP.helpers.dialogs
  do (dialog_id, dialog_func) ->
    APP.helpers.dialogs[dialog_id] = ->
      APP.justdo_analytics.JA({cat: "landing-page", act: "view-doc", val: dialog_id})

      $bootbox_dialog = $(dialog_func())

      Tracker.autorun (c) ->
        crv = JustdoHelpers.newAutoStoppedComputedReactiveVar null, ->
          return not $bootbox_dialog.is(":visible")
        ,
          recomp_interval: 100 # Check every 100ms whether user opened the dropdown

        if crv.get() == true
          APP.justdo_analytics.JA({cat: "landing-page", act: "close-doc", val: dialog_id})

          c.stop()

        return


      return