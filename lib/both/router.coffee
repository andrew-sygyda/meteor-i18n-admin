@AdminController = RouteController.extend
	layoutTemplate: 'AdminLayout'
	waitOn: ->
		[
			Meteor.subscribe 'adminUsers'
			Meteor.subscribe 'adminUser'
			Meteor.subscribe 'adminCollectionsCount'
		]
	onBeforeAction: ->
		Session.set 'adminSuccess', null
		Session.set 'adminError', null

		Session.set 'admin_title', ''
		Session.set 'admin_subtitle', ''
		Session.set 'admin_collection_page', null
		Session.set 'admin_collection_name', null
		Session.set 'admin_id', null
		Session.set 'admin_doc', null

		if not Roles.userIsInRole Meteor.userId(), ['admin']
			Meteor.call 'adminCheckAdmin'
			if typeof AdminConfig?.nonAdminRedirectRoute == 'string'
				Router.go AdminConfig.nonAdminRedirectRoute

		@next()


Router.route "adminDashboard",
	path: "/admin"
	template: "AdminDashboard"
	controller: "AdminController"
	action: ->
		@render()
	onAfterAction: ->
		Session.set 'admin_title', __ 'admin'
		Session.set 'admin_collection_name', ''
		Session.set 'admin_collection_page', ''

Router.route "adminDashboardUsersNew",
	path: "/admin/Users/new"
	template: "AdminDashboardUsersNew"
	controller: 'AdminController'
	action: ->
		@render()
	onAfterAction: ->
		Session.set 'admin_title', __ 'user.users'
		Session.set 'admin_subtitle', __ 'user.createNew'
		Session.set 'admin_collection_page', __ 'user.new'
		Session.set 'admin_collection_name', 'Users'

Router.route "adminDashboardUsersEdit",
	path: "/admin/Users/:_id/edit"
	template: "AdminDashboardUsersEdit"
	controller: "AdminController"
	data: ->
		user: Meteor.users.find(@params._id).fetch()
		roles: Roles.getRolesForUser @params._id
		otherRoles: _.difference _.map(Meteor.roles.find().fetch(), (role) -> role.name), Roles.getRolesForUser(@params._id)
	action: ->
		@render()
	onAfterAction: ->
		user = Meteor.users.findOne _id: @params._id
		Session.set 'admin_title', __ 'user.users'
		Session.set 'admin_subtitle', __('user.editUser') + " #{user.username or @params._id}"
		Session.set 'admin_collection_page', __ 'user.edit'
		Session.set 'admin_collection_name', 'Users'
		Session.set 'admin_id', @params._id
		Session.set 'admin_doc', user

Router.route "adminDashboardView",
	path: "/admin/:collection"
	template: "AdminDashboardViewWrapper"
	controller: "AdminController"
	data: ->
		admin_table: AdminTables[@params.collection]
	action: ->
		@render()
	onAfterAction: ->
		Session.set 'admin_title', AdminDashboard.collectionLabel @params.collection
		Session.set 'admin_subtitle', __ 'widgets.view'
		Session.set 'admin_collection_name', @params.collection

Router.route "adminDashboardNew",
	path: "/admin/:collection/new"
	template: "AdminDashboardNew"
	controller: "AdminController"
	waitOn: ->
		Meteor.subscribe 'adminAuxCollections', @params.collection
	action: ->
		@render()
	onAfterAction: ->
		Session.set 'admin_title', AdminDashboard.collectionLabel @params.collection
		Session.set 'admin_subtitle', __ 'widgets.createNew'
		Session.set 'admin_collection_page', __ 'widgets.new'
		Session.set 'admin_collection_name', @params.collection.charAt(0).toUpperCase() + @params.collection.slice(1)
	data: ->
		admin_collection: adminCollectionObject @params.collection

Router.route "adminDashboardEdit",
	path: "/admin/:collection/:_id/edit"
	template: "AdminDashboardEdit"
	controller: "AdminController"
	waitOn: ->
		[
			Meteor.subscribe 'adminCollectionDoc', @params.collection, @params._id
			Meteor.subscribe 'adminAuxCollections', @params.collection
		]
	action: ->
		@render()
	onAfterAction: ->
		doc = adminCollectionObject(@params.collection).findOne _id : @params._id
		Session.set 'admin_title', AdminDashboard.collectionLabel @params.collection
		Session.set 'admin_subtitle', __('widgets.Edit') + " #{doc and (doc.name or doc.title or doc.firstName) or @params._id}"
		Session.set 'admin_collection_page', __ 'widgets.edit'
		Session.set 'admin_collection_name', @params.collection.charAt(0).toUpperCase() + @params.collection.slice(1)
		Session.set 'admin_id', @params._id
		Session.set 'admin_doc', doc
	data: ->
		admin_collection: adminCollectionObject @params.collection
