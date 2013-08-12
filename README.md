# Basic Heroku API Stub Example

A basic app demonstrating how an API service stub can be used to ease
development and testing against a foreign service. This case makes use of the
[Heroku API stub](https://github.com/heroku/heroku-api-stub) specifically.

## Development

To start this up pointing to the stub:

```
git clone https://github.com/brandur/heroku-api-stub-example.git
gem install foreman
foreman start
open http://localhost:5000/apps
```

## Test

To run the test suite:

```
gem install rake
rake
```

## Production

In `.env`, set:

```
HEROKU_API_URL=https://api.heroku.com
RACK_ENV=production
```

Then start it up:

```
foreman start
open http://localhost:5000/apps
```
