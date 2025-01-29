Template.footer.helpers
  zendeskEnabled: -> JustdoZendesk.enabled_rv.get()

  zendeskHost: ->
    host = JustdoZendesk.host # called only if zendeskEnabled returns true, so safe to assume existence

    return "https://#{host}/"

  currentYear: -> moment().year()

  showLangDropdown: -> 
    if not APP.justdo_i18n?
      return

    # Don't show lang dropdown if there's only one language
    if _.size(APP.justdo_i18n.getSupportedLanguages()) <= 1
      return false

    return true

  loginOnlyLayout: ->
    return env.LANDING_PAGE_TYPE == "login-only"

Template.footer.events
  "click .terms-conditions": ->
    APP.helpers.dialogs.termsAndConditions()

  "click .privacy-policy": ->
    APP.helpers.dialogs.privacyPolicy()

  "click .on-premise-terms": ->
    APP.helpers.dialogs.onPremiseTerms()

  "click .cookie-policy": ->
    APP.helpers.dialogs.cookiePolicy()

  "click .copyright-notice": ->
    APP.helpers.dialogs.copyrightNotice()

  "click .privacy-shield-notice": ->
    APP.helpers.dialogs.privacyShieldNotice()

  "click .knowledge-base": ->
    APP.justdo_analytics.JA({cat: "landing-page", act: "open-knowledge-base"})

  "click .scroll-top": ->
    $(window).scrollTop(0)

  "click .footer-github-btn": (e) ->    
    APP.justdo_google_analytics?.sendEvent "footer-github-btn-clicked"

    return