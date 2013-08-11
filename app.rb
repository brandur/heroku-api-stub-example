require "bundler/setup"
Bundler.require

def api
  @api ||= Excon.new(
    ENV["HEROKU_API_URL"] || "https://api.heroku.com",
    headers: {
      "Accept"        => "application/vnd.heroku+json; version=3",
      "Authorization" => "Bearer #{@access_token}",
    }
  )
end

def authorized!
  if session[:access_token]
    @access_token = session[:access_token]
  elsif production?
    # initiate the OmniAuth authentication process
    redirect("/auth/heroku")
  else
    @access_token = "my-fake-access-token"
  end
end

def production?
  !%w{development test}.include?(ENV["RACK_ENV"])
end

def api_request
  yield
rescue Excon::Errors::Unauthorized
  session[:access_token] = nil
  # access token probably expired; re-authenticate
  redirect("/auth/heroku")
end

set :run, false
set :views, File.expand_path("../views", __FILE__)

use Rack::Session::Cookie, secret: ENV["COOKIE_SECRET"]
use OmniAuth::Builder do
  provider :heroku, ENV["HEROKU_OAUTH_ID"], ENV["HEROKU_OAUTH_SECRET"],
    { scope: "read" }
end

error Excon::Errors::Error do
  halt(503)
end

get "/" do
  redirect to("/apps")
end

get "/apps" do
  authorized!
  response = api_request { api.get(path: "/apps", expects: 200) }
  @apps = MultiJson.decode(response.body).sort_by { |a| a["name"] }
  slim :index
end

get "/apps/:id" do |id|
  authorized!
  response = api_request { api.get(path: "/apps/#{id}", expects: 200) }
  @app = MultiJson.decode(response.body)
  slim :show
end

get "/auth/:provider/callback" do
  session[:access_token] =
    request.env["omniauth.auth"]["credentials"]["token"]
  redirect to("/apps")
end
