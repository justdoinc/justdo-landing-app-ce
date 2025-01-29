Template.header.helpers
  emailVerificationNeeded: ->
    return not Meteor.user()?.emails[0].verified

  signInPage: ->
    path = APP.justdo_i18n_routes.getCurrentPathWithoutLangPrefix()

    return path == "/sign-in"

  loginOnlyLayout: ->
    return env.LANDING_PAGE_TYPE == "login-only"

  dualFrame: ->
    return @frame == "dual"

  isActivePage: (path_name) ->
    active_path = APP.justdo_i18n_routes.getCurrentPathWithoutLangPrefix()

    if active_path?.includes path_name
      return "active"

    return

  isJustdoAiEnabled: ->
    return env.JUSTDO_AI_ENABLED is "true"

Template.header.events
  "click .justdo-nav-features": (e) -> # Scroll to features section
    e.preventDefault()

    Router.go("/")

    Meteor.defer ->
      APP.justdo_analytics.JA({cat: "landing-page", act: "shortcut-button-click", val: "header-jump-to-features"})

      APP.helpers.scrollTo($(".justdo-features"))

  "click #justdo-navbar a": (e) ->
    if $("#justdo-navbar").hasClass("in")
      $('.navbar-toggle').click()
    return

  "click .menu-icon": (e) ->
    $("body").addClass "menu-is-open"

    return

Template.justdo_header_login_button.events
  "click .justdo-login": -> # Scroll to login form (for mobile screens)
    Router.go("/")

    Meteor.defer ->
      APP.justdo_analytics.JA({cat: "landing-page", act: "shortcut-button-click", val: "header-jump-to-login-box"})

      APP.helpers.setMainBoxCaptionsMode("sign-in")

      APP.helpers.scrollToMainBox()

      return

    return
