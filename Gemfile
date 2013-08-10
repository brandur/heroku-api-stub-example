source "https://rubygems.org"

gem "excon"
gem "multi_json"
gem "omniauth-heroku"
gem "puma"
gem "sinatra"
gem "slim"

group :development, :test do
  gem "heroku_api_stub", "~> 0.1.8",
    require: ["heroku_api_stub", "heroku_api_stub/test"]
  gem "rack-test"
  gem "webmock"
end
