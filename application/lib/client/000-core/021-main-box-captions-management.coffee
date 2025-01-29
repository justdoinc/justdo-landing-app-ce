mainBoxCaptionsMode = new ReactiveVar "sign-in" # The default mode
allowed_main_box_modes = ["sign-in", "sign-up"]

_.extend APP.helpers,
  setMainBoxCaptionsMode: (mode) ->
    if not mode in allowed_main_box_modes
      console.error "Unknown main box captions mode: #{mode}"
      
      return

    mainBoxCaptionsMode.set(mode)

    return

  getMainBoxCaptionsMode: ->
    return mainBoxCaptionsMode.get()

  toggleMainBoxCaptionMode: ->
    current = Tracker.nonreactive =>
      @getMainBoxCaptionsMode()

    if current == "sign-in"
      @setMainBoxCaptionsMode("sign-up")

      APP.justdo_analytics.JA({cat: "user-box", act: "user-switch-box-state", val: "sign-up"})
    else
      @setMainBoxCaptionsMode("sign-in")

      APP.justdo_analytics.JA({cat: "user-box", act: "user-switch-box-state", val: "sign-in"})

    return

Template.registerHelper "mainBoxCaptionMode", APP.helpers.getMainBoxCaptionsMode