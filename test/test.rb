require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

def app
  ServiceBroker.new
end

describe "/v2/catalog" do
  describe "when basic auth credentials are missing" do
    before do
      get "/v2/catalog"
    end

    it "returns a 401 unauthorized response" do
      assert_equal 401, last_response.status
    end
  end

  describe "when basic auth credentials are incorrect" do
    before do
      authorize "admin", "wrong-password"
      get "/v2/catalog"
    end

    it "returns a 401 unauthorized response" do
      assert_equal 401, last_response.status
    end
  end

  describe "when basic auth credentials are correct" do
    before do
      authorize "admin", "password"
      get "/v2/catalog"
    end

    it "returns a 200 response" do
      assert_equal 200, last_response.status
    end

    it "returns a JSON" do
      last_response.header["Content-Type"].must_include("application/json")
    end

    it "returns correct keys in JSON" do
      response_json = JSON.parse last_response.body

      response_json.keys.must_equal ["services"]

      services = response_json["services"]
      assert services.length > 0

      services.each do |service|
        service.keys.length.must_equal 5
        assert service.keys.include? "id"
        assert service.keys.include? "name"
        assert service.keys.include? "description"
        assert service.keys.include? "bindable"
        assert service.keys.include? "plans"

        plans = service["plans"]
        assert plans.length > 0
        plans.each do |plan|
          plan.keys.length.must_equal 3
          assert plan.keys.include? "id"
          assert plan.keys.include? "name"
          assert plan.keys.include? "description"
        end
      end
    end
  end
end

