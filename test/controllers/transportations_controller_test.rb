require 'test_helper'

class TransportationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transportations_index_url
    assert_response :success
  end

end
