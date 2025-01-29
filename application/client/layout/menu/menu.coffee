Template.main_menu.helpers
  loginOnlyLayout: ->
    return env.LANDING_PAGE_TYPE == "login-only"

Template.main_menu.events
  "click .main-menu-backdrop, click .main-menu": (e) ->
    $("body").removeClass "menu-is-open"

    return
