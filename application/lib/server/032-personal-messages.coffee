PersonalMessages = new Mongo.Collection "personal_messages"

APP.collections.PersonalMessages = PersonalMessages

Meteor.methods
  "getPersonalMessage": (message_id) ->
    check message_id, String

    return APP.collections.PersonalMessages.findOne(message_id)