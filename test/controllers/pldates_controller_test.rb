require 'test_helper'

class PldatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pldates_index_url
    assert_response :success
  end

  test "should get show" do
    get pldates_show_url
    assert_response :success
  end

  test "should get new" do
    get pldates_new_url
    assert_response :success
  end

  test "should get edit" do
    get pldates_edit_url
    assert_response :success
  end

end
