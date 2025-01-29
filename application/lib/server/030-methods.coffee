#custom way to generate password recovery token
passwordRecoveryToken = (userId, email) ->
  token_record =
    token: Random.secret()
    email: email
    when: new Date

  Meteor.users.update userId,
    $set:
      "services.password.reset": token_record

  return Accounts.urls.resetPassword(token_record.token)

Meteor.methods "sendPasswordRecoveryEmail": (email) ->
  user = Meteor.users.findOne {"emails.address": email}

  if user?
    token = passwordRecoveryToken user, email

    JustdoEmails.buildAndSend email, JustdoEmails.options.subject.password_recovery, "password-recovery", {recovery_link: token}
