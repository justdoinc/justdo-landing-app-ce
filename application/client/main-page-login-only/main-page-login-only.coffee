Template.main_page_login_only.helpers _.extend {}, share.icons_helpers,
  isMarketingEnv: ->
    return env.LANDING_PAGE_TYPE is "marketing"
