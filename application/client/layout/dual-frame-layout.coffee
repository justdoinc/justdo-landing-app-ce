Template.dual_frame_layout.onRendered ->
  setTimeout ( ->
    $(".dual-frame-wrapper").css "opacity", 1
  ), 500

  return

Template.dual_frame_layout.helpers
  isJustdoI18nEnabled: -> APP.justdo_i18n?

  postFrameWrapperItems: -> JD.getPlaceholderItems "post-frame-wrapper"