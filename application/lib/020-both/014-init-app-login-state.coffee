APP.login_state = new JustdoLoginState()

APP.login_state.on "after-set-user-state", (state) ->
  [hook_sym, token, user_obj] = state

  APP.getEnv (env) ->
    if env.LANDING_PAGE_TYPE isnt "marketing"
      return

    # In the marketing page, for the enrollment, forgot-password and email-verification flows
    # we change the page to the sign-in page
    if hook_sym in ["email-verification", "email-verification-expired", "reset-password", "reset-password-expired", "enrollment", "enrollment-expired"]
      Router.go("/sign-in")

  return