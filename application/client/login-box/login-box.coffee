# Note, relevant code is also on: main-page-conditional-init.coffee

# ------------ Initilization ------------ #

APP.login_box = {}

JustdoHelpers.setupHandlersRegistry APP.login_box

block_logged_in_user_promoter_page_logout_flow = false
APP.login_box.register "BeforeUserLoginAttempt", ->
  block_logged_in_user_promoter_page_logout_flow = true

  return

APP.login_box.register "AfterUserLoginAttempt", (err) ->
  block_logged_in_user_promoter_page_logout_flow = false

  if not err?
    if JustdoHelpers.currentPageName() == "promoters"
      registerPromoter()
    else
      imprintCampaign()

  return

redirect_blocking_routes = [
  "promo",
  "terms-and-conditions",
  "privacy-policy",
  "copyright-notice",
  "on-premises-terms-and-conditions",
  "privacy-shield-notice"
]

is_loading_reactive_var = new ReactiveVar null
state_reactive_var = new ReactiveVar null
notice_reactive_var = new ReactiveVar {}, APP.helpers.jsonComp
validation_errors_reactive_var = new ReactiveVar {}, APP.helpers.jsonComp
email_entered_reactive_var = new ReactiveVar null
first_name_reactive_var = new ReactiveVar null
last_name_reactive_var = new ReactiveVar null
profile_pic_reactive_var = new ReactiveVar null
initial_submission_reactive_var = new ReactiveVar null
show_recaptcha_reactive_var = new ReactiveVar false
waiting_legal_docs_sign_approval_var = new ReactiveVar false
promoter_registration_in_progress_var = new ReactiveVar false
campaign_imprinting_in_progress_var = new ReactiveVar false
promoter_page_loggedout_user_var = new ReactiveVar false

initializeState = ->
  is_loading_reactive_var.set false
  state_reactive_var.set "initial"
  notice_reactive_var.set {}
  validation_errors_reactive_var.set {}
  email_entered_reactive_var.set null
  first_name_reactive_var.set null
  last_name_reactive_var.set null
  profile_pic_reactive_var.set null
  initial_submission_reactive_var.set false
  show_recaptcha_reactive_var.set false
  waiting_legal_docs_sign_approval_var.set false
  promoter_registration_in_progress_var.set false
  campaign_imprinting_in_progress_var.set false
  promoter_page_loggedout_user_var.set false

  return

initializeState()

current_is_loading = -> is_loading_reactive_var.get()
current_state = -> state_reactive_var.get()
current_validation_error = -> validation_errors_reactive_var.get()
current_email_entered = -> email_entered_reactive_var.get()
current_first_name = -> first_name_reactive_var.get()
current_last_name = -> last_name_reactive_var.get()
current_profile_pic = -> profile_pic_reactive_var.get()
technical_error = "Server error. Please try again"

clearNoticeReactiveVar = ->
  notice_reactive_var.set {}

# ------------ End Initilization ------------ #



# ------------ Custom Functions ------------ #

getFirstErrorFromValidationErrors = ->
  # Gets arbitrary length of arguments representing errors labels and returns the value of the first error label found or null if non of the labels exists
  validation_errors = current_validation_error()

  for arg_error_label in arguments
    for error_label, error_message of validation_errors
      if arg_error_label == error_label
        if _.isFunction error_message
          return error_message()
        return error_message

  return null

getNotice = ->
  notice_obj = notice_reactive_var.get()

  args = _.toArray(arguments)

  for notice_type in args
    if notice_type of notice_obj
      return notice_obj[notice_type]

  return null

focusFirstInputWithError = ->
  # Make sure blaze up-to-date with validation errors
  Tracker.flush()

  $(".is-invalid").first().focus()

# form validations for all steps in main page
performMainPageValidations = (step, template) ->
# Receives the current step as a string and the calling template.
#
# Updates template's data validation_errors_reactive_var
#
# Returns true if all validations passed, false otherwise
  email_entered = $(".email-login").val()
  first_name_entered = $(".first-name").val()
  last_name_entered = $(".last-name").val()
  set_password = $(".set-password").val()
  confirm_password = $(".confirm-password").val()
  password_entered = $(".password-login").val()
  reset_password = $(".reset-password").val()
  confirm_reset_password = $(".confirm-reset-password").val()
  agree_terms_flag = $(".agree-terms-checkbox").is(":checked")

  validation_errors = {}

  if step == "main"
    if email_entered == ""
      validation_errors.invalid_email_input = TAPi18n.__ "err_email_empty"
    if not JustdoHelpers.common_regexps.email.test email_entered
      validation_errors.invalid_email_format = TAPi18n.__ "err_email_invalid"

  if step == "register"
    if first_name_entered == ""
      validation_errors.first_name_empty = TAPi18n.__ "err_first_name_empty"
    if first_name_entered.length > 30
      validation_errors.first_name_too_long = TAPi18n.__ "err_last_name_too_long"

    if last_name_entered == ""
      validation_errors.last_name_empty = TAPi18n.__ "err_last_name_empty"
    if last_name_entered.length > 30
      validation_errors.last_name_too_long = TAPi18n.__ "err_last_name_too_long"

    if (password_strength_issue = APP.accounts.passwordStrengthValidator(set_password, [email_entered, first_name_entered, last_name_entered]))?
      if password_strength_issue.code == "too-similar"
        validation_errors.password_issue = TAPi18n.__ "err_password_too_similar"
      else
        validation_errors.password_issue = ""

    if confirm_password == ""
      validation_errors.confirm_password_empty = TAPi18n.__ "err_retype_password_empty"
    if set_password != confirm_password
      validation_errors.retype_password_error = TAPi18n.__ "err_retype_password_not_match"

    if not agree_terms_flag
      validation_errors.agree_terms_and_privacy_missing = TAPi18n.__ "err_agree_ts_and_pp_missing"

  if step == "login"
    if password_entered == ""
      validation_errors.password_empty = TAPi18n.__ "err_password_empty"

  if step == "password_recovery"
    email_entered = email_entered_reactive_var.get()
    first_name_entered = first_name_reactive_var.get()
    last_name_entered = last_name_reactive_var.get()

    if (password_strength_issue = APP.accounts.passwordStrengthValidator(reset_password, [email_entered, first_name_entered, last_name_entered]))?
      if password_strength_issue.code == "too-similar"
        validation_errors.reset_password_issue = TAPi18n.__ "err_password_too_similar"
      else
        validation_errors.reset_password_issue = password_strength_issue.reason

    if confirm_reset_password == ""
      validation_errors.confirm_reset_password_empty = TAPi18n.__ "err_retype_password_empty"
    if reset_password != confirm_reset_password
      validation_errors.retype_password_error = TAPi18n.__ "err_retype_password_not_match"

  validation_errors_reactive_var.set validation_errors

  initial_submission_reactive_var.set true

  if _.isEmpty validation_errors
    return true

  return false

getValidationsErrorsJSON = ->
  return Tracker.nonreactive ->
    return JSON.stringify({validation_error: validation_errors_reactive_var.get()})

getTechnicalErrorsJSON = (error_obj) ->
  return Tracker.nonreactive ->
    return JSON.stringify({technical_error: error_obj})

performRedirect = (target_path = "/") ->
  if not Meteor.user()?
    APP.logger.info "Redirect cancelled, user logged-out"

    return

  if not (login_target = APP.login_target.getTargetUrl())?
    if (web_app_url = window.env?.WEB_APP_ROOT_URL)? and web_app_url != ""
      # If no login target defined, use the web app's url
      login_target = web_app_url + target_path
    else
      APP.logger.info "Can't redirect to the web app, WEB_APP_ROOT_URL env var not defined"
      return

  if not (token = localStorage["Meteor.loginToken"])?
    APP.logger.error "Can't redirect to the web app, can't find loginToken"

    return

  getRedirectForm = (cb) ->
    post_request_form_head = """
      <form action="#{login_target}" method="post">
        <input type="hidden" name="token" value="#{token}" />
    """

    post_request_form_footer = """
      </form>
    """

    if env.JUSTDO_ANALYTICS_ENABLED == "true"
      APP.justdo_analytics.getClientStateValues (state) ->
        cb """
        #{post_request_form_head}
        <input type="hidden" name="justdo-analytics" value="#{state.DID}|#{state.SID}" />
        #{post_request_form_footer}
        """
    else
      cb(post_request_form_head + post_request_form_footer)

  #
  # Redirect
  #
  getRedirectForm (form) ->
    post_request_form = $(form)
    $('body').append(post_request_form)

    APP.justdo_analytics.JA({cat: "core", act: "redirect-jd-env"})

    post_request_form.submit()

    return

signPromoterDocs = ->
  # sign promoter terms and conditions
  promoters_legal_docs = ["promoters_terms_conditions"]

  waiting_legal_docs_sign_approval_var.set true
  APP.accounts.signLegalDocs promoters_legal_docs, ->
    waiting_legal_docs_sign_approval_var.set false

    return

  return

signPromoterDocsIfUnderPromotersPage = ->
  if JustdoHelpers.currentPageName() == "promoters"
    signPromoterDocs()

  return

registerPromoter = ->
  if not (campaign_id = amplify.store JustdoPromotersCampaigns?.campaign_local_storage_key)?
    campaign_id = null

  # set promoter field
  promoter_registration_in_progress_var.set true
  APP.justdo_promoters_campaigns?.registerAsPromoter {campaign_id: campaign_id}, (err) ->
    promoter_registration_in_progress_var.set false

    if err?
      alert("Promoter registration failed")

      console.error(err)

    return

  return

imprintCampaign = ->
  if not APP.justdo_promoters_campaigns?
    return

  if not (campaign_id = amplify.store JustdoPromotersCampaigns?.campaign_local_storage_key)?
    # No campaign_id nothing to do
    return

  campaign_imprinting_in_progress_var.set true
  APP.justdo_promoters_campaigns.linkCampaignIdToUser {campaign_id: campaign_id}, (err) ->
    campaign_imprinting_in_progress_var.set false

    if err?
      alert("Campaign setup failed")

      console.error(err)

    return

  return

# ------------ End Custom Functions ------------ #



# ------------ Main Page ------------ #

Template.sign_in_up_toggler.events
  "click .toggle-main-box-captions-mode": (e) ->
    APP.helpers.toggleMainBoxCaptionMode()

# onRendered
Template.login_box.onRendered ->
  tpl = @
  @autorun ->
    if APP.login_state.initial_user_state_ready_rv.get() == true
      user = Meteor.user()

      if not user?
        Tracker.nonreactive ->
          # We don't want loginStateIs to trigger reactivity
          # only user login/out should
          if not APP.login_state.loginStateIs("enrollment", "reset-password")
            initializeState()

        if tpl.data.page == "promoters"
          # If user arrived to the login page not logged-in, we don't want a later
          # login to result in him being loggedout, so we just set the var to true
          promoter_page_loggedout_user_var.set true
      else
        if tpl.data.page == "promoters"
          if promoter_page_loggedout_user_var.get() == false
            Meteor.logout()
            return

          promoter_page_loggedout_user_var.set true

        legal_docs_situation = APP.collections.JustdoSystem.findOne("legal_docs")

        if waiting_legal_docs_sign_approval_var.get() == true
          APP.justdo_analytics.JA({cat: "landing-page", act: "redirect-prevented-due-to-waiting-legal-docs-sign-approval"})

          message = """
            <h4 class="main-page-loading">
              <img src="/layout/loading-spinner.gif">
              Processing...
            </h4>
          """

          notice_reactive_var.set
            legal_docs_signature_required: message

        # In the following 3 cases, we need to display the legal-docs-signature-dialog
        # 1. legal_docs_situation.status is false
        # 2. user is a promoter and the promoters_terms_conditions is not "SIGNED"
        # 3. the user is registering as a promoter - the user is in "promoters" page and promoters_terms_conditions is not "SIGNED"
        else if not legal_docs_situation.status or ((APP.justdo_promoters_campaigns?.isCurrentUserPromoter() or tpl.data.page == "promoters") and legal_docs_situation.docs["promoters_terms_conditions"] != "SIGNED")
          APP.justdo_analytics.JA({cat: "landing-page", act: "redirect-prevented-due-to-missing-legal-docs-signatures"})

          # For the events handling, please search below: LEGAL DOCS SIGNATURE DIALOG HELPERS

          message = """
            <div class="legal-docs-signature-dialog">
              <p class="dialog-title text-center">#{TAPi18n.__ "login_please_approve_the_following_to_continue"}</p>
          """

          for doc_id, doc_state of legal_docs_situation.docs
            if not ((APP.justdo_promoters_campaigns?.isCurrentUserPromoter() or tpl.data.page == "promoters") and legal_docs_situation.docs["promoters_terms_conditions"] != "SIGNED")
              # Only specific users need to sign the promoters terms and conditions
              if doc_id == "promoters_terms_conditions"
                continue

            if doc_state == "SIGNED"
              continue

            if doc_state == "OPTIONAL-NOT-SIGNED"
              continue

            if doc_state == "NOT-SIGNED"
              doc_landing_page_address = JustdoLegalDocsVersions[doc_id].landing_page_address
              doc_readable_name = TAPi18n.__ JustdoLegalDocsVersions[doc_id].readable_name.replaceAll(" ", "-").toLowerCase()

              i18n_message = TAPi18n.__ "login_i_agree_to_custom_tc_html", {doc_readable_name, doc_landing_page_address}
              message += """
              <div class="form-check">
                <div class="legal-doc-check doc-#{doc_id}-check"><input type="checkbox" class="signature-checkbox form-check-input" id="doc-#{doc_id}-checkbox" doc-id="#{doc_id}"> <label class="form-check-label text-dark" for="doc-#{doc_id}-checkbox">#{i18n_message}</a></label></div>
              </div>
              """

              continue

            if doc_state == "OUT-DATED"
              message += """
              <div class="form-check">
                <div class="legal-doc-check doc-#{doc_id}-check"><input type="checkbox" class="signature-checkbox form-check-input" id="doc-#{doc_id}-checkbox" doc-id="#{doc_id}"> <label class="form-check-label text-dark" for="doc-#{doc_id}-checkbox">I read and agree to <a href="#{JustdoLegalDocsVersions[doc_id].landing_page_address}">JustDo's #{JustdoLegalDocsVersions[doc_id].readable_name}</a>. We updated our #{JustdoLegalDocsVersions[doc_id].readable_name} on #{JustdoLegalDocsVersions[doc_id].date}.</label></div>
              </div>
              """

              continue

          message += """
            <button class="btn btn-lg btn-primary btn-block my-3 proceed-disabled submit-legal-docs-signatures">#{TAPi18n.__ "continue"}</button>
          """

          message += """
            </div>
          """

          notice_reactive_var.set
            legal_docs_signature_required: message

           Meteor.setTimeout (->
            APP.helpers.scrollToMainBox()
          ), APP.options.login_redirect_delay

        else
          # Only if we got a logged in user, we want to be reactive to
          # route changes, so we get the router_name again, within the
          # computation
          route_name = Router.current().route.getName()

          state_reactive_var.set "loggedin"
          profile_pic_reactive_var.set user.profile.profile_pic

          # if not user.emails[0].verified
          #   APP.justdo_analytics.JA({cat: "landing-page", act: "redirect-prevented-due-to-non-verified-email"})

          #   notice_reactive_var.set
          #     check_email_account_activation: """
          #       <center style='margin-top: 3px; margin-bottom: 10px; font-size: 17px;'><b>
          #         Awaiting email verification <br> Check your email
          #       </b></center>
          #       To complete the registration process, please follow the steps in the email we just sent to you.<br>
          #       <div style='padding-top: 5px; font-family: verdana; font-weight: 600;'>Did not receive email?</div>
          #       <ul style='margin-top: 5px;'>
          #         <li>Please check your mail spam folder</li>
          #         <li>Is your email above correct? if it isn't, click the Sign Out button below to restart registration</li>
          #         <li><a href='' class='resend-verification'>Click here to resend the email</a></li>
          #       </ul>
          #     """
          # else
          notice_reactive_var.set
            redirect_to_main_app: """
              <div class="d-flex text-center m-3 justify-content-center">
                <div class="jd-loader">
                  <div class="bg-primary"></div>
                  <div class="bg-primary"></div>
                </div>
              </div>
              <a class="manual-redirect text-primary text-center d-block mb-3 jd-c-pointer"><u>#{TAPi18n.__ "login_click_to_redirect"}</u></a>
            """

          if route_name in redirect_blocking_routes
            APP.logger.debug("#{route_name} is open, don't redirect")

            return

          if promoter_registration_in_progress_var.get() == true
            # Wait for the promoter registration to complete before redirecting the user
            return

          if campaign_imprinting_in_progress_var.get() == true
            # Wait for the campaign imprinting process to complete before redirecting the user
            return

          Meteor.setTimeout (->
            if tpl.data.page == "promoters"
              if APP.justdo_promoters_campaigns?.isCurrentUserPromoter()
                performRedirect("/promoters")
                APP.helpers.scrollToMainBox()
              else
                if not block_logged_in_user_promoter_page_logout_flow
                  if promoter_page_loggedout_user_var.get() == false
                    # This code is still here, though, in reality, it will never get to be called
                    # since, if the user arrived to the page logged-in, no matter whether a promoter
                    # or not a promoter, he'll be logged out (search the code on that page for other
                    # places where promoter_page_loggedout_user_var.get() is used to learn more).
                    #
                    # I (Daniel) keep it here, for potential future use
                    #
                    # XXX If the user is already logged-in but isn't a promoter, we need to show him
                    # the login/register box. For now we acheive that by logging him out. In the future
                    # we might want to allow him to become a promoter without logging him out.
                    #
                    # We don't want this to happen more than once, hence the
                    # promoter_page_loggedout_user_var.get() test
                    Meteor.logout()

                promoter_page_loggedout_user_var.set true
            else
              performRedirect()
          ), APP.options.login_redirect_delay

# helpers
Template.login_box.helpers
  display_notice: ->
    getNotice.apply(@, arguments)
  main_box_class: ->
    if not APP.login_state.initial_user_state_ready_rv.get()
      return "loading"

    if APP.login_state.loginStateIs("logged-in", "logged-out", "loading")
      return current_state()

    return APP.login_state.getLoginState()

  stateEq: (step_id) -> current_state() == step_id
  stateNeq: ->
    states = _.toArray(arguments)

    if current_state() in states
      return false

    return true

  isPostLoginEnrollment: -> Meteor.user()? and APP.login_state.loginStateIs("enrollment")

  email_entered: -> current_email_entered()
  user_email: -> Meteor.user()?.emails?[0]?.address

  profile_pic: ->
    return current_profile_pic()
  first_name: ->
    return current_first_name()
  last_name: ->
    return current_last_name()
  loggedin_user: -> Meteor.user()

  isAccountsPasswordEnabled: -> env.ALLOW_ACCOUNTS_PASSWORD_BASED_LOGIN is "true"

# events
Template.login_box.onRendered ->
  bold_main_box_login_states =
    ["logged-in", "email-verification", "email-verification-expired",
      "reset-password", "reset-password-expired", "enrollment", "enrollment-expired"]

  non_bold_main_box_login_states = ["logged-out"]

  @autorun =>
    if APP.login_state.loginStateIs.apply(APP.login_state, bold_main_box_login_states)
      $(".single-frame-wrapper").addClass "bold-main-box"
      $("footer").addClass "bg-light"

    if APP.login_state.loginStateIs.apply(APP.login_state, non_bold_main_box_login_states)
      $(".single-frame-wrapper").removeClass "bold-main-box"
      $("footer").removeClass "bg-light"

  return

Template.login_box.onDestroyed ->
  $(".single-frame-wrapper").removeClass "bold-main-box"
  $("footer").removeClass "bg-light"

  return

Template.login_box.events
  "click .back-arrow-wrapper": (e, template) ->
    initializeState()

    APP.justdo_analytics.JA({cat: "user-box", act: "init-box-state"})

    return

  "click .google-store": (e) ->
    APP.justdo_analytics.JA({cat: "landing-page", act: "get-mobile-app", val: "android"})

  "click .apple-store": (e) ->
    APP.justdo_analytics.JA({cat: "landing-page", act: "get-mobile-app", val: "apple"})

  "click .exit-bold-main-box": (e) ->
    $(".single-frame-wrapper").removeClass "bold-main-box"
    $("footer").removeClass "bg-light"

  # LEGAL DOCS SIGNATURE DIALOG HELPERS
  "click .doc-privacy_policy-check a": (e) ->
    APP.helpers.dialogs.privacyPolicy()

    return false

  "click .doc-terms_conditions-check a": ->
    APP.helpers.dialogs.termsAndConditions()

    return false

  "change input[type='checkbox']": ->
    signatures_states = $(".legal-docs-signature-dialog input[type='checkbox']").map ->
      $(this).is(":checked")

    if false in signatures_states
      $(".submit-legal-docs-signatures").addClass("proceed-disabled")
    else
      $(".submit-legal-docs-signatures").removeClass("proceed-disabled")

    return

  "click .submit-legal-docs-signatures": (e, tpl) ->
    if not $(e.target).hasClass("proceed-disabled")
      signed_legal_docs_ids = $(".legal-docs-signature-dialog input[type='checkbox']:checked").map ->
        $(this).attr("doc-id")

      signed_legal_docs_ids = signed_legal_docs_ids.toArray()

      waiting_legal_docs_sign_approval_var.set true
      APP.accounts.signLegalDocs signed_legal_docs_ids, ->
        waiting_legal_docs_sign_approval_var.set false

        return

    return

# ------------ END Main Page ------------ #

# ------------ special_login_processes_user_details ------------ #

#
# IMPORTANT, the loading of this template, actually takes care
# of putting the special login process user details into
# the reactive vars see onCreated
#

Template.special_login_processes_user_details.onCreated ->
  @getLoginStateUserObj = ->
    return Tracker.nonreactive ->
      [login_state_sym, token, user, done] = APP.login_state.getLoginState()

      if login_state_sym in ["enrollment", "reset-password"]
        return user

      return null

  user = @getLoginStateUserObj()

  if user?
    if (email = user.emails?[0]?.address)?
      email_entered_reactive_var.set email

    if (profile = user.profile)?
      if (profile_pic = profile.profile_pic)?
        profile_pic_reactive_var.set profile_pic

      if (first_name = profile.first_name)?
        first_name_reactive_var.set first_name

      if (last_name = profile.last_name)?
        last_name_reactive_var.set last_name

# helpers
Template.special_login_processes_user_details.helpers
  email: -> email_entered_reactive_var.get()
  profile_pic: -> profile_pic_reactive_var.get()
  first_name: -> first_name_reactive_var.get()
  last_name: -> last_name_reactive_var.get()

# ------------ END special_login_processes_user_details ------------ #


# ------------ initial_state ------------ #

Template.sign_in_sign_up_title.helpers
  sign_in_message: -> APP.env_rv.get().LANDING_PAGE_CUSTOM_SIGN_IN_MESSAGE or TAPi18n.__ "sign_in_message"
  sign_up_message: -> APP.env_rv.get().LANDING_PAGE_CUSTOM_SIGN_UP_MESSAGE or TAPi18n.__ "sign_up_message"

# helpers
Template.initial_state.helpers
  email_entered: -> email_entered_reactive_var.get()
  display_notice: ->
    getNotice.apply(@, arguments)
  display_validation_error: ->
    getFirstErrorFromValidationErrors.apply(@, arguments)
  invalid_email: ->
    return current_validation_error().invalid_email_input? or current_validation_error().invalid_email_format?
  is_loading: -> current_is_loading()

gravatarCheckExistence = (gravatar_url) ->
  HTTP.call "get", gravatar_url, (err, res) ->
    if err?
      profile_pic_reactive_var.set null
    else
      if res.statusCode == 200
        profile_pic_reactive_var.set gravatar_url

# events
Template.initial_state.events
  "submit #pseudo-form-sender": (e, template) ->
    e.preventDefault()
    if current_is_loading()
      return

    email_entered = $(".email-login").val().toLowerCase()

    APP.justdo_analytics.JA({cat: "user-box", act: "process-email", val: email_entered})

    if not performMainPageValidations("main", template)
      focusFirstInputWithError()

      APP.justdo_analytics.JA({cat: "user-box", act: "process-email-failed", val: getValidationsErrorsJSON()})
    else
      is_loading_reactive_var.set true
      APP.accounts.getUserPublicInfo {email: email_entered, ignore_invited: true}, (err, public_info) ->
        is_loading_reactive_var.set false
        if err?
          validation_errors_reactive_var.set
            technical_error: technical_error

          APP.justdo_analytics.JA({cat: "user-box", act: "process-email-failed", val: getTechnicalErrorsJSON(err)})

          return

        email_entered_reactive_var.set email_entered

        if not public_info?
          # Not registered yet
          state_reactive_var.set "register"
          Meteor.defer -> $(".first-name").focus()

          APP.justdo_analytics.JA({cat: "user-box", act: "process-email-successful", val: "sign-up"})
        else
          APP.accounts.isPasswordFlowPermittedForUser email_entered, (err, allowed) ->
            if err?
              validation_errors_reactive_var.set
                technical_error: technical_error

              return

            if not allowed
              # validation_errors_reactive_var.set
              #   password_flow_forbidden_for_user: "Logging in with Google"

              APP.justdo_google_oauth_login.login undefined, (err) ->
                # undefined arg is the justdo_google_oauth_login.login options, which we don't set here.

                # DRY Warning: If you change this cb, possible that you'd want to update google-oauth-login.coffee
                # as well.

                if err?
                  APP.justdo_analytics.JA({cat: "user-box", act: "google-oauth-login-failed", val: JSON.stringify(err)})
                else
                  APP.justdo_analytics.JA({cat: "user-box", act: "google-oauth-login-succeeded"})

              APP.justdo_analytics.JA({cat: "user-box", act: "process-email-successful", val: "google-login"})

              return
            else
              profile_pic = public_info.profile?.profile_pic

              if profile_pic?
                profile_pic_reactive_var.set profile_pic

              state_reactive_var.set "login"
              Meteor.defer -> $(".password-login").focus()

              APP.justdo_analytics.JA({cat: "user-box", act: "process-email-successful", val: "sign-in"})

              return

  "click .test-drive": ->
    APP.helpers.dialogs.testDrive()

  "keyup .email-login, change .email-login": ->
    email = $(".email-login").val()
    # add/remove error upon email field change. Only when it's already submitted and had error in first place
    if initial_submission_reactive_var.get()
      if performMainPageValidations("main")
        $(".email-login").removeClass("is-invalid")
      else
        $(".email-login").addClass("is-invalid")


# ------------ END initial_state ------------ #



# ------------ login_state ------------ #
# helpers
Template.login_state.helpers
  display_notice: ->
    getNotice.apply(@, arguments)
  display_validation_error: ->
    getFirstErrorFromValidationErrors.apply(@, arguments)
  invalid_password_entered: ->
    return current_validation_error().incorrect_password?
  is_loading: -> current_is_loading()
  displayRecaptcha: -> show_recaptcha_reactive_var.get()

#events
Template.login_state.events
  "submit #pseudo-form-sender": (e, template) ->
    e.preventDefault()
    if current_is_loading()
      return

    password_entered = $(".password-login").val()
    stay_logged_in_flag = $(".stay-logged-in").is(":checked")
    email = email_entered_reactive_var.get()
    clearNoticeReactiveVar()

    APP.justdo_analytics.JA({cat: "user-box", act: "login-attempt", val: email})

    if not performMainPageValidations("login", template)
      APP.justdo_analytics.JA({cat: "user-box", act: "login-failed", val: getValidationsErrorsJSON})

      focusFirstInputWithError()
    else
      is_loading_reactive_var.set true

      loginWithPasswordArgs = [email, password_entered]

      if APP.justdo_recaptcha?.isSupported() and (recaptcha_token = APP.justdo_recaptcha?.getResponse()) != ""
        loginWithPasswordArgs.push(recaptcha_token)

      loginWithPasswordArgs.push (err) ->
        is_loading_reactive_var.set false

        APP.login_box.processHandlers("AfterUserLoginAttempt", err)

        if err?
          log_val = JSON.stringify({server_error: JSON.stringify(err)})
          APP.justdo_analytics.JA({cat: "user-box", act: "login-failed", val: log_val})

          show_recaptcha_reactive_var.set false
          if err.reason == "recaptcha-required"
            show_recaptcha_reactive_var.set true
          else
            if err.reason is "Incorrect password"
              err.reason = TAPi18n.__ "err_incorrect_password"
            if err.reason is "User has no password set"
              err.reason = TAPi18n.__ "err_no_password_set"
            validation_errors_reactive_var.set
              incorrect_password: "#{TAPi18n.__ "err_cant_login"}: #{err.reason}" # Note, it'll capture not only incorrect password but also deactivation deactivated users block

          return

        APP.justdo_analytics.JA({cat: "user-box", act: "login-succeeded"})

        return

      APP.login_box.processHandlers("BeforeUserLoginAttempt")
      return Meteor.loginWithPassword.apply(Meteor, loginWithPasswordArgs)

  "click .forgot-password-link": (e, template) ->
    if not APP.helpers.isSmtpConfigured()
      bootbox.alert TAPi18n.__ "password_recovery_unavailable_smtp"
      return

    APP.justdo_analytics.JA({cat: "user-box", act: "forgot-password-dialog-open"})

    email = email_entered_reactive_var.get()
    bootbox.confirm
      title: TAPi18n.__ "password_recovery"
      message: "#{TAPi18n.__ "password_recovery_email_will_be_sent_to"} <i>#{email}</i>"
      onEscape: true
      backdrop: true
      animate: false
      buttons:
        "cancel":
          label: TAPi18n.__ "cancel"
          className: "btn btn-secondary"
        "confirm":
          label: TAPi18n.__ "continue"
          className: "btn btn-primary"

      callback: (result) ->
        if not result
          APP.justdo_analytics.JA({cat: "user-box", act: "forgot-password-dialog-cancel"})
        else
          APP.accounts.sendPasswordResetEmail email, (err, result) ->
            if err?
              validation_errors_reactive_var.set
                technical_error: technical_error

              APP.justdo_analytics.JA({cat: "user-box", act: "forgot-password-dialog-submit-failed", val: getTechnicalErrorsJSON(err)})
            else
              APP.justdo_analytics.JA({cat: "user-box", act: "forgot-password-dialog-submit"})

              notice_reactive_var.set
                password_recovery_email_sent: TAPi18n.__ "password_recovery_email_sent"

# ------------ END login_state ------------ #



# ------------ register_enroll_state ------------ #

# helpers
Template.register_enroll_state.helpers
  display_validation_error: ->
    getFirstErrorFromValidationErrors.apply(@, arguments)
  invalid_first_name: ->
    return current_validation_error().first_name_empty? or current_validation_error().first_name_too_long?
  invalid_last_name: ->
    return current_validation_error().last_name_empty? or current_validation_error().last_name_too_long?
  invalid_set_password: ->
    return current_validation_error().password_issue?
  invalid_confirm_password: ->
    return current_validation_error().confirm_password_empty? or current_validation_error().retype_password_error?
  is_loading: -> current_is_loading()
  initial_first_name: -> Tracker.nonreactive -> first_name_reactive_var.get()
  initial_last_name: -> Tracker.nonreactive -> last_name_reactive_var.get()

  showPasswordRequirements: ->
    return Template.instance().show_password_requirements_rv.get()

  passwordRequirements: ->
    return Template.instance().password_requirements
  
  i18nReason: ->
    if _.isFunction @reason
      return @reason()
    return @reason

  fullfilled: (pw_req_code) ->
    return not (pw_req_code in Template.instance().password_issues_rv.get())

#events
Template.register_enroll_state.onCreated ->
  @show_password_requirements_rv = new ReactiveVar false
  @password_requirements = _.filter APP.accounts.getPasswordRequirements(), (req) -> true
  @password_issues_rv = new ReactiveVar APP.accounts.getUnconformedPasswordRequirements("")

  @getInitialUserObj = ->
    return Tracker.nonreactive ->
      [login_state_sym, token, user, done] = APP.login_state.getLoginState()

      if login_state_sym == "enrollment"
        return user
      else
        return {profile: {}, emails: [{address: email_entered_reactive_var.get()}]}

  @getUserEmail = ->
    user = @getInitialUserObj()
    return user.emails[0].address

  if not @getInitialUserObj().profile?.profile_pic?
    # If no profile pic is set for the user, try find from gravatar
    gravatarCheckExistence Gravatar.imageUrl(@getUserEmail(), {default: "404", secure: true})

Template.register_enroll_state.events
  "keyup .first-name, change .first-name": (e, template) ->
    first_name_reactive_var.set e.target.value
  "keyup .last-name, change .last-name": (e, template) ->
    last_name_reactive_var.set e.target.value
  "submit #pseudo-form-sender": (e, template) ->
    e.preventDefault()
    if current_is_loading()
      return

    signed_legal_docs = ["terms_conditions", "privacy_policy"]
    email = template.getUserEmail()
    first_name_entered = $(".first-name").val()
    last_name_entered = $(".last-name").val()
    set_password = $(".set-password").val()
    profile_pic = $(".justdo-avatar").attr "src"

    profile =
      first_name: first_name_entered
      last_name: last_name_entered
      profile_pic: profile_pic

    [login_state_sym, token, user, done] = APP.login_state.getLoginState()

    if login_state_sym == "enrollment"
      ja_act_prefix = "enrollment"
    else
      ja_act_prefix = "sign-up"

    APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-attempt", val: email})

    if not performMainPageValidations("register", template)
      APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-failed", val: getValidationsErrorsJSON()})

      focusFirstInputWithError()
    else
      if login_state_sym == "enrollment"
        is_loading_reactive_var.set true
        Accounts.resetPassword token, set_password, (err) ->
          is_loading_reactive_var.set false

          if err?
            validation_errors_reactive_var.set
              technical_error: technical_error

            APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-failed", val: getTechnicalErrorsJSON(err)})
          else
            # XXX At the moment we don't check whether the following
            # fails or not, a refactor for landing page require to block
            # properly the login that happens automatically following the
            # Accounts.resetPassword call

            # XXX needs improvement, api should take care of profile update, and directs updates should be blocked
            Meteor.users.update user._id,
              $set:
                "profile.first_name": profile.first_name
                "profile.last_name": profile.last_name
                "profile.profile_pic": profile.profile_pic

            waiting_legal_docs_sign_approval_var.set true
            APP.accounts.signLegalDocs signed_legal_docs, ->
              waiting_legal_docs_sign_approval_var.set false

              return

            APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-succeeded"})

            done()

      if login_state_sym == "logged-out"
        create_user_options =
          email: email
          profile: profile
          password: set_password
          signed_legal_docs: signed_legal_docs
          send_verification_email: true

        is_loading_reactive_var.set true
        APP.accounts.createUser create_user_options, (err, user_id) ->
          if err?
            validation_errors_reactive_var.set
              technical_error: "Can't create user: #{err.reason}"

            APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-failed", val: getTechnicalErrorsJSON(err)})

            return

          APP.login_box.processHandlers("BeforeUserLoginAttempt")
          Meteor.loginWithPassword email, set_password, (err) ->
            is_loading_reactive_var.set false

            APP.login_box.processHandlers("AfterUserLoginAttempt", err)

            if err?
              # XXX We never tested this edge case, we should
              validation_errors_reactive_var.set
                technical_error: err.reason or technical_error
                
              APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-failed", val: getTechnicalErrorsJSON(err)})

              return

            signPromoterDocsIfUnderPromotersPage()

            APP.justdo_analytics.JA({cat: "user-box", act: "#{ja_act_prefix}-succeeded"})

            return


  "click .terms-conditions-modal": (e,tpl) ->
    e.preventDefault()
    APP.helpers.dialogs.termsAndConditions()
    return

  "click .privacy-policy-modal": (e,tpl) ->
    e.preventDefault()
    APP.helpers.dialogs.privacyPolicy()
    return

  "focus .set-password": (e, tpl) ->
    tpl.show_password_requirements_rv.set true

    return

  "blur .set-password": (e, tpl) ->
    tpl.show_password_requirements_rv.set false

    return

  "keyup .set-password": (e, tpl) ->
    password_val = $(e.currentTarget).val()
    tpl.password_issues_rv.set APP.accounts.getUnconformedPasswordRequirements(password_val, [first_name_reactive_var.get() or "", last_name_reactive_var.get() or "", email_entered_reactive_var.get() or ""])

    return

# ------------ END register_enroll_state ------------ #



# ------------ loggedin_state ------------ #

# helpers
Template.loggedin_state.helpers
  display_notice: ->
    getNotice.apply(@, arguments)
  display_validation_error: ->
    getFirstErrorFromValidationErrors.apply(@, arguments)

# events
Template.loggedin_state.events
  "click .resend-verification": (e, template) ->
    email = Meteor.user().emails[0].address
    bootbox.confirm
      title: "Resend Registration Email"
      message: "Registration email will be sent to <i>#{email}</i> .<br><br>Please make sure to check for it also in your spam folder."
      onEscape: true
      backdrop: true
      animate: false
      buttons:
        "cancel":
          className: "btn btn-secondary"
        "confirm":
          label: "Continue"
          className: "btn btn-primary"
      callback: (result) ->
        if result
          APP.accounts.sendVerificationEmail (err, result) ->
            if err?
              validation_errors_reactive_var.set
                technical_error: technical_error

              return

            new_notice_obj = _.extend {}, notice_reactive_var.get(),
              verification_email_sent:
                "Registration email resent. Please check your email."

            notice_reactive_var.set new_notice_obj

  "click .manual-redirect": (e, template) ->
    if (template.data.page == "promoters")
      performRedirect("/promoters")
    else
      performRedirect()

    return

  "click .logout-button": (e, template) ->
    Meteor.logout ->
      initializeState()

# ------------ END loggedin_state ------------ #



# ------------ reset_password ------------ #

# onRendered
Template.reset_password.onRendered ->
  $(".reset-password").focus()

# helpers
Template.reset_password.helpers
  display_validation_error: ->
    getFirstErrorFromValidationErrors.apply(@, arguments)
  invalid_set_password: ->
    return current_validation_error().reset_password_issue?
  invalid_confirm_password: ->
    return current_validation_error().confirm_reset_password_empty? or current_validation_error().retype_password_error?
  is_loading: -> current_is_loading()

# events
Template.reset_password.events
  "submit #pseudo-form-sender": (e, template) ->
    e.preventDefault()
    if current_is_loading()
      return

    [login_state_sym, token, user, done] = APP.login_state.getLoginState()

    APP.justdo_analytics.JA({cat: "user-box", act: "reset-password-attempt", val: user._id})

    password = $(".reset-password").val()

    if not performMainPageValidations("password_recovery", template)
      focusFirstInputWithError()

      APP.justdo_analytics.JA({cat: "user-box", act: "reset-password-failed", val: getValidationsErrorsJSON()})
    else
      is_loading_reactive_var.set true
      Accounts.resetPassword token, password, (err) ->
        is_loading_reactive_var.set false
        if err?
          APP.justdo_analytics.JA({cat: "user-box", act: "reset-password-failed", val: getTechnicalErrorsJSON(err)})

          validation_errors_reactive_var.set
            technical_error: technical_error
        else
          notice_reactive_var.set
            password_reset: "New password recorded."

          APP.justdo_analytics.JA({cat: "user-box", act: "reset-password-succeeded"})

          done()

# ------------ END reset_password ------------ #

# Note, relevant code is also on: main-page-conditional-init.coffee
