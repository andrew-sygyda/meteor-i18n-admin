Meteor i18n Admin
============

## How to instal

`$ meteor add ansyg:i18n-admin`

This is fork of [yogiben:admin](https://atmospherejs.com/yogiben/admin) package (a complete admin dashboard solution for meteor). It is add localization support for labels. For complete documentation  please visit [yogiben:admin](https://atmospherejs.com/yogiben/admin).

This package add lang field to AdminConfig object.
```CoffeeScript
@AdminConfig =
  lang: 'ru'
```

Curently added `'ru'` and `'en'` support.

In version 0.1.15 added `auxCollections` option, you can define it like:

```CoffeeScript
@AdminConfig =
  # ...
  collections:
    Staff:
      auxCollections: [
        'SomeCollection',
      ,
      # or you can provide object with collection name and fields options,
      # to specify wich fields you will be subscribed when add or edit document
        collection: 'CollectionName'
        fields:
          _id: 1
          name: 1
          date: 1
      ]
```

### NOTE!

In your project folder must be files with translations such as `ru.i18n.js` and `en.i18n.js`. From package TAPi18n.
