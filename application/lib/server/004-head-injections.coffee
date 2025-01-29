# We don't use head.html since it doesn't support blaze helpers which we need to set the CDN
# prefix
WebApp.connectHandlers.use (req, res, next) =>
  req.dynamicHead = req.dynamicHead or ""

  # As per https://validator.w3.org/, the charset meta tag should be the in the first 1024 bytes.
  # We add it here to ensure it's the first tag in the head.
  req.dynamicHead = """
    <meta charset="utf-8">
    #{req.dynamicHead}
  """

  req.dynamicHead += """
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="#{JustdoHelpers.getCDNUrl "/prism/prism.css"}" rel="stylesheet" />
    <link rel="shortcut icon" sizes="16x16 24x24 32x32 48x48 64x64" href="#{JustdoHelpers.getCDNUrl "/layout/logos/justdo_favicon.ico"}">
    <script src="#{JustdoHelpers.getCDNUrl "/prism/prism.js"}"></script>

  """

  if not APP.justdo_seo?
    lang = APP.justdo_i18n.getUserLangFromMeteorLoginTokenCookie(req) or JustdoI18n.default_lang
    default_page_title = TAPi18n.__ "default_tab_title", {}, lang

    req.dynamicHead += """
      <title>#{default_page_title}</title>
    """

  next()
