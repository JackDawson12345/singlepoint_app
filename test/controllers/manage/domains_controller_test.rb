require "test_helper"

class Manage::DomainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manage_domains_index_url
    assert_response :success
  end
end
