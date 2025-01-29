Meteor.startup -> # need to defer since 020-both dir happens after client dir
  Tracker.autorun (c) ->
    login_state = APP.login_state.getLoginState()

    [login_state_sym, token, user, done] = login_state

    if login_state_sym == "email-verification"
      Accounts.verifyEmail token, (err) ->
        if err?
          APP.logger.error(err)

          alert("Couldn't complete registration, please try again")

          # We don't return here, we want login procedures
          # to continue anyway (otherwise, user is stuck on
          # error state)

        # Set timeout, to show verification message for a bit
        setTimeout ->
          done()
        , 3000