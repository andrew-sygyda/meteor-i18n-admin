Template.registerHelper('AdminTables', AdminTables);

Template.registerHelper 'labelCreateBtn', ->
  __ 'btns.create'

Template.registerHelper 'labelUpdateBtn', ->
  __ 'btns.update'

UI.registerHelper 'AdminConfig', ->
  AdminConfig if AdminConfig?

UI.registerHelper 'admin_collections', ->
  collections = {}
  if AdminConfig? and typeof AdminConfig.collections is 'object'
    collections = AdminConfig.collections
  collections.Users = {} if not collections?.Users or typeof collections.Users isnt 'object'
  _.defaults collections.Users,
    collectionObject: Meteor.users
    label: __ 'user.users'
    icon: 'user'
  _.map collections, (obj, key) ->
    obj = _.extend obj, {name:key}
    obj = _.defaults obj, {label: key,icon:'plus',color:'blue'}

UI.registerHelper 'admin_collection_name', ->
  Session.get 'admin_collection_name'

UI.registerHelper 'admin_current_id', ->
  Session.get 'admin_id'

UI.registerHelper 'admin_current_doc', ->
  Session.get 'admin_doc'

UI.registerHelper 'admin_is_users_collection', ->
  Session.get('admin_collection_name') == 'Users'

UI.registerHelper 'admin_sidebar_items', ->
  AdminDashboard.sidebarItems.get()

UI.registerHelper 'admin_collection_items', ->
  items = []
  _.each AdminDashboard.collectionItems, (fn) =>
    item = fn @name, '/admin/' + @name
    if item?.title and item?.url
      items.push item
  items

UI.registerHelper 'admin_omit_fields', ->
  if typeof AdminConfig.autoForm != 'undefined' and typeof AdminConfig?.autoForm?.omitFields == 'object'
    global = AdminConfig.autoForm.omitFields
  if not Session.equals('admin_collection_name','Users') and AdminConfig?.collections?[Session.get 'admin_collection_name']?.omitFields == 'object'
    collection = AdminConfig.collections?[Session.get 'admin_collection_name']?.omitFields?
  if typeof global == 'object' and typeof collection == 'object'
    _.union global, collection
  else if typeof global == 'object'
    global
  else if typeof collection == 'object'
    collection

UI.registerHelper 'AdminSchemas', ->
  AdminDashboard.schemas

UI.registerHelper 'adminGetSkin', ->
  if typeof AdminConfig.dashboard != 'undefined' and typeof AdminConfig.dashboard.skin == 'string'
    AdminConfig.dashboard.skin
  else
    'blue'

UI.registerHelper 'adminIsUserInRole', (_id,role)->
  Roles.userIsInRole _id, role

UI.registerHelper 'adminGetUsers', ->
  Meteor.users

UI.registerHelper 'adminUserSchemaExists', ->
  typeof Meteor.users._c2 == 'object'

UI.registerHelper 'adminCollectionLabel', (collection)->
  AdminDashboard.collectionLabel(collection) if collection?

UI.registerHelper 'adminCollectionCount', (collection)->
  if collection == 'Users'
    Meteor.users.find().fetch().length
  else
    AdminCollectionsCount.findOne({collection: collection})?.count

UI.registerHelper 'adminTemplate', (collection,mode)->
  if collection.toLowerCase() != 'users' && AdminConfig.collections?[collection]?.templates?
    AdminConfig.collections[collection].templates[mode]

UI.registerHelper 'adminGetCollection', (collection)->
  AdminConfig.collections[collection]

UI.registerHelper 'adminWidgets', ->
  if typeof AdminConfig.dashboard != 'undefined' and typeof AdminConfig.dashboard.widgets != 'undefined'
    AdminConfig.dashboard.widgets

UI.registerHelper 'adminUserEmail', (user) ->
  if user && user.emails && user.emails[0] && user.emails[0].address
    user.emails[0].address
  else if user && user.services && user.services.facebook && user.services.facebook.email
    user.services.facebook.email
  else if user && user.services && user.services.google && user.services.google.email
    user.services.google.email
