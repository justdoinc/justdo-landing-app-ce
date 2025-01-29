#
# Global helpers
#

_.extend APP.helpers, JustdoHelpers,
  scrollTo: ($target, options) ->
    # possible options (all optionals):
    #
    # offset (number): the offset from the $targe top position we'll scroll to.
    # onComplete (function): if set we call this function when the animation is finished.

    default_options =
      offset: 0

    options = _.extend {}, default_options, options

    {offset, onComplete} = options

    animation_options =
      duration: "slow"

    if _.isFunction onComplete
      animation_options.complete = onComplete

    $("html, body").animate {scrollTop: $target.offset().top + offset}, animation_options

    return

  scrollToMainBox: ->
    APP.helpers.scrollTo $(".main-box"),
      offset: -15
      onComplete: ->
        $email_login = $(".email-login")

        if $email_login.length > 0
          $email_login.focus()

    return
  
  isSmtpConfigured: -> not _.isEmpty env.MAIL_SENDER_EMAIL