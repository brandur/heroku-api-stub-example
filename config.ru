require "bundler/setup"
Bundler.require

# so logging output appears properly
$stdout.sync = true

require "./app"

run Sinatra::Application
