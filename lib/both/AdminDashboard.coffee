AdminDashboard =
  schemas: {}
  sidebarItems: new ReactiveVar []
  collectionItems: []
  alertSuccess: (message)->
    Session.set 'adminSuccess', message
  alertFailure: (message)->
    Session.set 'adminError', message

  checkAdmin: ->
    if not Roles.userIsInRole Meteor.userId(), ['admin']
      Meteor.call 'adminCheckAdmin'
      if (typeof AdminConfig?.nonAdminRedirectRoute == "string")
        Router.go AdminConfig.nonAdminRedirectRoute
    if typeof @.next == 'function'
      @next()
  adminRoutes: ['adminDashboard','adminDashboardUsersNew','adminDashboardUsersEdit','adminDashboardView','adminDashboardNew','adminDashboardEdit']
  collectionLabel: (collection)->
    if collection == 'Users'
      __ 'user.users'
    else if collection? and typeof AdminConfig.collections[collection].label == 'string'
      AdminConfig.collections[collection].label
    else Session.get 'admin_collection_name'

  addSidebarItem: (title, url, options) ->
    item = title: title
    if _.isObject(url) and typeof options == 'undefined'
      item.options = url
    else
      item.url = url
      item.options = options

    arr = do @sidebarItems.get
    arr.push item
    @sidebarItems.set arr

  extendSidebarItem: (title, urls) ->
    if _.isObject(urls) then urls = [urls]

    existing = _.find @sidebarItems.get(), (item) -> item.title == title
    if existing
      existing.options.urls = _.union existing.options.urls, urls

  addCollectionItem: (fn) ->
    @collectionItems.push fn

  path: (s) ->
    path = '/admin'
    if typeof s == 'string' and s.length > 0
      path += (if s[0] == '/' then '' else '/') + s
    path
  makeUserSchemas: ->
    AdminDashboard.schemas.newUser = new SimpleSchema
      email:
        type: String
        label: __ 'user.emailAddress'
      chooseOwnPassword:
        type: Boolean
        label: __ 'user.pwdByEmail'
        defaultValue: true
      password:
        type: String
        label: __ 'user.pwd'
        optional: true
      sendPassword:
        type: Boolean
        label: __ 'user.sendPwd'
        optional: true

    AdminDashboard.schemas.sendResetPasswordEmail = new SimpleSchema
      _id:
        type: String

    AdminDashboard.schemas.changePassword = new SimpleSchema
      _id:
        type: String
      password:
        type: String
        label: __ 'user.pwd'
