require_relative "test_helper"

class AppTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    HerokuAPIStub.initialize
  end

  def test_apps_list
    get "/apps"
    assert_equal 200, last_response.status
  end

  def test_apps_show
    # the stub will respond for any app
    get "/apps/anything"
    assert_equal 200, last_response.status
  end

  def test_bad_request_error
    HerokuAPIStub.initialize do
      get("/apps/anything") { 400 }
    end

    get "/apps/anything"
    assert_equal 503, last_response.status
  end

  def test_unauthorized_error
    HerokuAPIStub.initialize do
      get("/apps/anything") { 401 }
    end

    get "/apps/anything"
    assert_equal 302, last_response.status
  end
end
