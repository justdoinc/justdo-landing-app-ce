# The following takes care of initializations that should take care
# only when the page is initialized in a specific state.
#
# For example: logged in user on mobile should see the main-box in his
# view port and not the top of the page which is marketing oriented text
# and irrelevant for him.

mobile_breakpoint = 580
Tracker.autorun (c) ->
  user_login_state = APP.login_state.getLoginState()[0]
  current_page_name = JustdoHelpers.currentPageName()

  # Once user state and current page name are both initialized its time to
  # run the state specific initializations
  if user_login_state != "loading" and current_page_name?
    # Don't run again after this (stop reactivity)
    c.stop()

    window_width = $(window).width()

    #
    # Jump to the main-box, if mobile screen size and user is not logged-out.
    #
    if current_page_name == "main_page" and
       window_width < mobile_breakpoint and
       user_login_state != "logged-out"
        Tracker.nonreactive ->
          Tracker.autorun (c2) ->
            # We had an issue with Safari, where the scrollToMainBox happened
            # too early in the page rendering and resulted in inaccurate positioning
            # of the view port, since the main-box position kept changing after calling
            # scrollToMainBox.
            #
            # We therefore begin by waiting for the .main-box position to stabalise,
            # and only then, we call scrollToMainBox()

            main_box_position_crv = JustdoHelpers.newAutoStoppedComputedReactiveVar null, ->
              return $(".main-box").offset()?.top
            ,
              recomp_interval: 50

            # get the offset to create a dependency
            # (we use it both for the following condition, and for reactivity)
            current_main_box_top_offset = main_box_position_crv.get()

            if current_main_box_top_offset?
              timeout_id = setTimeout ->
                # Position the viewport on the main-box
                if current_main_box_top_offset == main_box_position_crv.getSync()
                  APP.helpers.scrollToMainBox()
                else
                  Tracker.flush() # The offset from top changed, call Tracker.flush to immediately trigger invalidation of this computation
              , 300 # If we main-box offset from top didn't change during this time, we consider it as stable

              c2.onInvalidate ->
                # Will have no effect if timeout triggered already
                unsetTimeout(timeout_id)

            return

    # Focus on the .email-login input if not mobile and use is logged out
    # (on Android, will cause the page to jump to the focused element,
    # which isn't desired for logged out users which we want to be exposed
    # to the marketing materials in the beginning of the page)
    if current_page_name == "main_page" and
       window_width > mobile_breakpoint and
       user_login_state == "logged-out"
        Tracker.nonreactive ->
          Tracker.autorun (c2) ->
            # Isolated autorun
            main_box_exists_crv = JustdoHelpers.newAutoStoppedComputedReactiveVar null, ->
              return $(".main-box").length > 0
            ,
              recomp_interval: 100

            if main_box_exists_crv.get() is true
              $(".email-login").focus()

              c2.stop()

            return

  return