# Add "ui-hide" class
$('''
  <style media="screen">
    .ui-hide { display: none !important }
  </style>
  ''').appendTo $('head')

Neck.Tools =
  dashToCamel: (str)-> str.replace /\W+(.)/g, (x, chr)-> chr.toUpperCase()
  camelToDash: (str)-> str.replace(/\W+/g, '-').replace(/([a-z\d])([A-Z])/g, '$1-$2')

# Dependency injectors container
Neck.DI = {}

# DI searching on global scope given variables
Neck.DI.globals =
  load: (route, options)-> 
    try
      if destiny = eval(route)
        return destiny
      else
        if options.type isnt 'template'
          return throw "No defined '#{route}' object in global scope"
    catch
      if options.type isnt 'template'
        return throw "No defined '#{route}' object in global scope"

    route

# DI working with commonjs require module wrapper
Neck.DI.commonjs =
  controllerPrefix: 'controllers'
  helperPrefix: 'helpers'
  templatePrefix: 'templates'

  _routePath: /^([a-zA-Z$_\.]+\/?)+$/i

  load: (route, options)-> 
    if route.match @_routePath
      try
        return require (if options.type then @[options.type + 'Prefix'] + "/" else '') + route
      catch
        if options.type isnt 'template'
          return throw "No defined '#{route}' object for CommonJS dependency injection"

    route