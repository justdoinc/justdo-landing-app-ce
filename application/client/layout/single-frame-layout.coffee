Template.single_frame_layout.helpers
  currentRouteName: ->
    return APP.justdo_i18n_routes.getCurrentRouteName()

  isJustdoI18nEnabled: -> APP.justdo_i18n?

  postFrameWrapperItems: -> JD.getPlaceholderItems "post-frame-wrapper"