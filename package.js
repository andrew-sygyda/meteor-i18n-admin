'use strict';

Package.describe({
  name: 'admin-i18n',
  summary: 'A complete admin dashboard i18n solution',
  version: '0.1.18',
  git: 'https://github.com/andrew-sygyda/meteor-i18n-admin',
  documentation: 'README.md'
});

Package.onUse(function (api) {
  var both = [ 'client', 'server' ];

  api.versionsFrom('METEOR@1.0');

  api.use([
    'tap:i18n@1.4.1',
    'iron:router@1.0.7',
    'coffeescript',
    'underscore',
    'aldeed:collection2@2.3.2',
    'aldeed:autoform@5.0.3',
    'aldeed:template-extension@3.1.1',
    'alanning:roles@1.2.13',
    'raix:handlebar-helpers@0.2.4',
    'reywood:publish-composite@1.3.5',
    'momentjs:moment@2.9.0',
    'aldeed:tabular@1.1.0',
    'meteorhacks:unblock@1.1.0',
    'reactive-var'
  ], both);

  api.use([
    'less',
    'session',
    'jquery',
    'templating'
  ], 'client');

  api.use([
    'email'
  ], 'server');

  api.addFiles([
    'package-tap.i18n',
    'lib/both/AdminDashboard.coffee',
    'lib/both/router.coffee',
    'lib/both/utils.coffee',
    'lib/both/startup.coffee',
    'lib/both/collections.coffee'
  ], both);

  api.addFiles([
    'lib/client/html/admin_templates.html',
    'lib/client/html/admin_widgets.html',
    'lib/client/html/admin_layouts.html',
    'lib/client/html/admin_sidebar.html',
    'lib/client/html/admin_header.html',
    'lib/client/css/admin-layout.less',
    'lib/client/css/admin-custom.less',
    'lib/client/js/admin_layout.js',
    'lib/client/js/helpers.coffee',
    'lib/client/js/templates.coffee',
    'lib/client/js/events.coffee',
    'lib/client/js/slim_scroll.js',
    'lib/client/js/autoForm.coffee'
  ], 'client');

  api.addFiles([
    'lib/server/publish.coffee',
    'lib/server/methods.coffee'
  ], 'server');

  api.export('AdminDashboard', both);

  api.addFiles([
    'i18n/en.i18n.json',
    'i18n/ru.i18n.json',
    'i18n/zh-CN.i18n.json'
  ], both);
});
