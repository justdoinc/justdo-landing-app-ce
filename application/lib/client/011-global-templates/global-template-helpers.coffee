template_helpers =
  displayName: JustdoHelpers.displayName

  currentProtocol: window.location.protocol
  
  getCDNUrl: (path) -> JustdoHelpers.getCDNUrl(path)


for helper_name, helper of template_helpers
  Template.registerHelper helper_name, helper