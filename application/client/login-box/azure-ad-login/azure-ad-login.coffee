Template.login_with_azure_ad.onCreated ->
  @err_obj_rv = new ReactiveVar()
  return

Template.login_with_azure_ad.helpers
  azure_ad_oauth_login_supported: ->
    env_vars = APP.env_rv.get()

    if env_vars?.AZURE_AD_OAUTH_LOGIN_ENABLED == "true"
      return true

    return false
  
  err: -> Template.instance().err_obj_rv.get()

Template.login_with_azure_ad.events
  "click .azure-ad-oauth-login": (e, tpl) ->
    APP.justdo_analytics.JA({cat: "user-box", act: "azure-ad-oauth-login-attempt"})

    tpl.err_obj_rv.set null
    APP.login_box.processHandlers("BeforeUserLoginAttempt")
    Accounts._enableAutoLogin() # Right before we call the oauth login, release any potential block for the login process from enrollment/forgot-password/email-verification (especially important when env.ALLOW_ACCOUNTS_PASSWORD_BASED_LOGIN set to true, but user arrived from enrollment email into enrollment state that he isn't aware of).
    APP.justdo_azure_ad_oauth_login.login undefined, (err) ->
      # undefined arg is the justdo_azure_ad_oauth_login.login options, which we don't set here.
      APP.login_box.processHandlers("AfterUserLoginAttempt", err)

      if err?
        tpl.err_obj_rv.set err
        APP.justdo_analytics.JA({cat: "user-box", act: "azure-ad-oauth-login-failed", val: JSON.stringify(err)})
      else
        APP.justdo_analytics.JA({cat: "user-box", act: "azure-ad-oauth-login-succeeded"})

    return