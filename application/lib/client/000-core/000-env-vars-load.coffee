InjectData.getData "env", (env) ->
  window.env = env

  APP.emit "env-vars-ready", env

  return
