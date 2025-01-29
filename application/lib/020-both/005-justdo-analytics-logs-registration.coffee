JustdoAnalytics.registerLogs "landing-page", [
  {
    action_id: "view-doc"
    description: "View one of the docs we open in a bootbox (e.g. copy write) either by clicking the buttons at the footer, or in any other way (incl. during registration process, direct link etc.), val the doc id"
  }
  {
    action_id: "close-doc"
    description: "View one of the docs we open in a bootbox (e.g. copy write) either by clicking the buttons at the footer, or in any other way (incl. during registration process, direct link etc.), val the doc id"
  }
  {
    action_id: "open-knowledge-base"
    description: "User click to open the JustDo Knowledge Base (not to be confused with opening of the Zendesk widget)"
  }
  {
    action_id: "shortcut-button-click"
    description: "User clicked on one of the landing page buttons that jumps to different part of the page. Val is an identification of the button clicked."
  }
  {
    action_id: "selling-prop-expand"
    description: "One of the expandable selling proposition we present in the landing page been expanded by the user, val is the selling proposition id"
  }
  {
    action_id: "selling-prop-collapse"
    description: "One of the expandable selling proposition we present in the landing page been collapsed by the user, val is the selling proposition id"
  }
  {
    action_id: "get-mobile-app"
    description: "One of the mobile app links clicked. Val is the mobile type."
  }
  {
    action_id: "redirect-prevented-due-to-non-verified-email"
    description: "Logged-in user didn't redirect to web-app due to non verified email"
  }
  {
    action_id: "redirect-prevented-due-to-missing-legal-docs-signatures"
    description: "Logged-in user is signatures on legal docs doesn't exist or out-dated"
  }
  {
    action_id: "redirect-prevented-due-to-waiting-legal-docs-sign-approval"
    description: "Logged-in user waiting for the server to approve signatures"
  }
]

JustdoAnalytics.registerLogs "request-demo", [
  {
    action_id: "open-form"
    description: "Request demo form opened"
  }
  {
    action_id: "submit-attempt"
    description: "Submit attempt, before we check the form for error, or whether sent successfully to the server"
  }
  {
    action_id: "invalid-form"
    description: "Form failed to submit due to input error. Val is the error presented to the user."
  }
  {
    action_id: "submit-failed"
    description: "Form failed to submit due to transmission failure (no internet, server failure, etc.)."
  }
  {
    action_id: "successful-submit"
    description: "Request demo form submitted."
  }
  {
    action_id: "cancel"
    description: "Request demo form closed without submitting"
  }
]

JustdoAnalytics.registerLogs "personal-message-dialog", [
  {
    action_id: "esc-pressed-to-continue"
    description: "Esc button pressed to close the dialog"
  }
  {
    action_id: "skip-to-site"
    description: "Skip button clicked"
  }
  {
    action_id: "request-a-demo"
    description: "Request a demo button clicked"
  }
]

JustdoAnalytics.registerLogs "contact-request", [
  {
    action_id: "submit-attempt"
    description: "Submit attempt, before we check the form for error, or whether sent successfully to the server"
  }
  {
    action_id: "invalid-form"
    description: "Form failed to submit due to input error. Val is the error presented to the user."
  }
  {
    action_id: "submit-failed"
    description: "Form failed to submit due to transmission failure (no internet, server failure, etc.)."
  }
  {
    action_id: "successful-submit"
    description: "Request submitted."
  }
  {
    action_id: "cancel"
    description: "Request closed without submitting"
  }
]


JustdoAnalytics.registerLogs "user-box", [
  {
    action_id: "user-switch-box-state"
    description: "User clicked on the button that toggle the box terminology between login and register. Val is the state switched to."
  }
  {
    action_id: "init-box-state"
    description: "User clicked on the back button that bring him back to the main view of the user-box."
  }
  {
    action_id: "google-oauth-login-attempt"
    description: "User attempt to login using google oauth"
  }
  {
    action_id: "google-oauth-login-succeeded"
    description: "Login using google oauth completed successfully. Note this event can come following `google-oauth-login-attempt` act, but also following `process-email-successful` with val: `google-login`"
  }
  {
    action_id: "google-oauth-login-failed"
    description: "Login using google oauth failed. Val is the JSON stringified error object"
  }
  {
    action_id: "azure-ad-oauth-login-attempt"
    description: "User attempt to login using Azure AD oauth"
  }
  {
    action_id: "azure-ad-oauth-login-succeeded"
    description: "Login using Azure AD oauth completed successfully. Note this event can come following `azure-ad-oauth-login-attempt` act, but also following `process-email-successful` with val: `azure-ad-login`"
  }
  {
    action_id: "azure-ad-oauth-login-failed"
    description: "Login using Azure AD oauth failed. Val is the JSON stringified error object"
  }
  {
    action_id: "process-email"
    description: "User entered his email and pressed the next button to process it. Val is the email entered"
  }
  {
    action_id: "process-email-failed"
    description: "Email entered by user failed validation, or server failed to process it, val is the error JSON."
  }
  {
    action_id: "process-email-successful"
    description: "Email entered by user processed successfully by the server. Val is the form type presented to the user: sign-in/sign-up/google-login"
  }
  {
    action_id: "login-attempt"
    description: "User attempt to submit the login form. Val is the email user try to login with."
  }
  {
    action_id: "login-succeeded"
    description: "Login form login completed successfully."
  }
  {
    action_id: "login-failed"
    description: "Login form login failed. Val is the JSON stringified error object"
  }
  {
    action_id: "forgot-password-dialog-open"
    description: "User opened the forgot password dialog"
  }
  {
    action_id: "forgot-password-dialog-submit"
    description: "User submitted the forgot password dialog (log is written after the server send us submission confirmation)."
  }
  {
    action_id: "forgot-password-dialog-submit-failed"
    description: "Forgot password email failed to submit due to technical issue. Val is the server error."
  }
  {
    action_id: "forgot-password-dialog-cancel"
    description: "User cancelled the forgot password dialog"
  }
  {
    action_id: "sign-up-attempt"
    description: "User attempt to submit the sign-up form. Val is the user email"
  }
  {
    action_id: "sign-up-succeeded"
    description: "Sign-up completed successfully."
  }
  {
    action_id: "sign-up-failed"
    description: "Sign-in failed. Val is the JSON stringified error object"
  }
  {
    action_id: "enrollment-attempt"
    description: "User attempt to complete enrollment (enrollment form)"
  }
  {
    action_id: "enrollment-succeeded"
    description: "User enrollment succeeded"
  }
  {
    action_id: "enrollment-failed"
    description: "User enrollment failed. Val is the JSON stringified error object"
  }
  {
    action_id: "reset-password-attempt"
    description: "Reset password attempt. Val is the user email."
  }
  {
    action_id: "reset-password-failed"
    description: "Reset password failed"
  }
  {
    action_id: "reset-password-succeeded"
    description: "Reset password succeeded"
  }
]