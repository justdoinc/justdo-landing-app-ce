Meteor.publish null, ->
  if not @userId?
    @ready()
    return

  APP.accounts.basicUserInfoPublicationHandler(@, {
    users_ids: [@userId]
    include_profile_fields: false
    public_basic_user_info_cursor_options: {
      additional_fields: {
        "promoters.is_promoter": 1
        "promoters.referring_campaign_id": 1
        "profile.lang": 1
        "profile.date_format": 1
      }
    }
  })

  return