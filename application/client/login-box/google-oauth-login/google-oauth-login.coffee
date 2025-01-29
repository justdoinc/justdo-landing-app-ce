Template.login_with_google_oauth.helpers
  google_oauth_login_supported: ->
    env_vars = APP.env_rv.get()

    if env_vars?.GOOGLE_OAUTH_LOGIN_ENABLED == "true"
      return true

    return false

Template.login_with_google_oauth.events
  "click .google-oauth-login": ->
    APP.justdo_analytics.JA({cat: "user-box", act: "google-oauth-login-attempt"})

    APP.login_box.processHandlers("BeforeUserLoginAttempt")
    Accounts._enableAutoLogin() # Right before we call the oauth login, release any potential block for the login process from enrollment/forgot-password/email-verification (especially important when env.ALLOW_ACCOUNTS_PASSWORD_BASED_LOGIN set to true, but user arrived from enrollment email into enrollment state that he isn't aware of).
    APP.justdo_google_oauth_login.login undefined, (err) ->
      # undefined arg is the justdo_google_oauth_login.login options, which we don't set here.

      # DRY Warning: If you change this cb, possible that you'd want to update main-page.coffee
      # as well (search for: APP.justdo_google_oauth_login.login).

      APP.login_box.processHandlers("AfterUserLoginAttempt", err)

      if err?
        APP.justdo_analytics.JA({cat: "user-box", act: "google-oauth-login-failed", val: JSON.stringify(err)})
      else
        APP.justdo_analytics.JA({cat: "user-box", act: "google-oauth-login-succeeded"})

    return