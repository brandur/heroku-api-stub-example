ENV["COOKIE_SECRET"] = "my-cookie-secret"
ENV["RACK_ENV"]      = "test"

require "bundler/setup"
Bundler.require(:default, :test)

require "minitest/autorun"
require "minitest/unit"
require_relative "../app"
