# I18N Helper

Helper library for i18n in cozy. Retrieve the cozy locale from the DataSystem

## Requirements

Add CozyInstance to your app's permission


## Usage :

```coffee

# Middleware (express)
app.use require('cozy-i18n-helper').middleware

# Mounted (Compound)
require('cozy-i18n-helper').mount compound

```

## Client Side

```coffee

$.ajax 'cozy-locale.json',
  success: (data) -> #data= {locale: ja}

```
