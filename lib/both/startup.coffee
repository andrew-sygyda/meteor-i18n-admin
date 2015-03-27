@AdminTables = {}

adminTablesDom = '<"box"<"box-header"<"box-toolbar"<"pull-left"<lf>><"pull-right"p>>><"box-body"t>>'

getI18nLabel = (label) ->
  if Meteor.isClient then __ label else label

adminEditDelButtons = ->
  [
    data: '_id'
    title: getI18nLabel 'btns.update'
    createdCell: (node, cellData, rowData) ->
      $(node).html(Blaze.toHTMLWithData Template.adminEditBtn, {_id: cellData}, node)
    width: '40px'
    orderable: false
  ,
    data: '_id'
    title: getI18nLabel 'btns.delete'
    createdCell: (node, cellData, rowData) ->
      $(node).html(Blaze.toHTMLWithData Template.adminDeleteBtn, {_id: cellData}, node)
    width: '40px'
    orderable: false
  ]

adminCreateUserTable = ->
  AdminTables.Users = new Tabular.Table
    name: 'Users'
    collection: Meteor.users
    columns: _.union [
        data: '_id'
        title: getI18nLabel 'adminUser'
        # TODO: use `tmpl`
        createdCell: (node, cellData, rowData) ->
          $(node).html(Blaze.toHTMLWithData Template.adminUsersIsAdmin, {_id: cellData}, node)
        width: '40px'
        orderable: false
      ,
        data: 'emails'
        title: getI18nLabel 'user.email'
        render: (value) ->
          value[0].address
      ,
        data: 'emails'
        title: getI18nLabel 'user.mail'
        # TODO: use `tmpl`
        createdCell: (node, cellData, rowData) ->
          $(node).html(Blaze.toHTMLWithData Template.adminUsersMailBtn, {emails: cellData}, node)
        width: '40px'
      ,
        data: 'createdAt'
        title: getI18nLabel 'user.joined'
    ], do adminEditDelButtons
    dom: adminTablesDom

adminTablePubName = (collection) ->
  "admin_tabular_#{collection}"

adminCreateTables = (collections) ->
  do adminCreateUserTable
  editDelBtns = do adminEditDelButtons
  _.each AdminConfig?.collections, (collection, name) ->
    return false if name is 'Users'
    columns = _.map collection.tableColumns, (column) ->
      if column.template
        createdCell = (node, cellData, rowData) ->
          $(node).html(Blaze.toHTMLWithData Template[column.template], {value: cellData, doc: rowData}, node)

      data: column.name
      title: column.label
      createdCell: createdCell

    if columns.length == 0
      columns = []

    AdminTables[name] = new Tabular.Table
      name: name
      collection: adminCollectionObject(name)
      pub: collection.children and adminTablePubName(name)
      sub: collection.sub
      columns: _.union columns, editDelBtns
      extraFields: collection.extraFields
      dom: adminTablesDom

adminPublishTables = (collections) ->
  _.each collections, (collection, name) ->
    unless collection.children then return undefined
    Meteor.publishComposite adminTablePubName(name), (tableName, ids, fields) ->
      check tableName, String
      check ids, Array
      check fields, Match.Optional Object

      @unblock()

      find: ->
        @unblock()
        adminCollectionObject(name).find {_id: {$in: ids}}, {fields: fields}
      children: collection.children

tableSettings = ->
  do AdminDashboard.makeUserSchemas
  adminCreateTables AdminConfig?.collections

Meteor.startup =>
  if Meteor.isClient and AdminConfig?.lang and window.location.pathname.indexOf('/admin') >= 0
    TAPi18n.setLanguage AdminConfig.lang
    .done ->
      do setDataTableLang
      do tableSettings
  if Meteor.isServer
    do tableSettings
    adminPublishTables AdminConfig?.collections
