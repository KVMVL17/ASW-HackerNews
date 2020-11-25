require 'test_helper'

class Api::V1::ContributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_contribution = api_v1_contributions(:one)
  end

  test "should get index" do
    get api_v1_contributions_url
    assert_response :success
  end

  test "should get new" do
    get new_api_v1_contribution_url
    assert_response :success
  end

  test "should create api_v1_contribution" do
    assert_difference('Api::V1::Contribution.count') do
      post api_v1_contributions_url, params: { api_v1_contribution: {  } }
    end

    assert_redirected_to api_v1_contribution_url(Api::V1::Contribution.last)
  end

  test "should show api_v1_contribution" do
    get api_v1_contribution_url(@api_v1_contribution)
    assert_response :success
  end

  test "should get edit" do
    get edit_api_v1_contribution_url(@api_v1_contribution)
    assert_response :success
  end

  test "should update api_v1_contribution" do
    patch api_v1_contribution_url(@api_v1_contribution), params: { api_v1_contribution: {  } }
    assert_redirected_to api_v1_contribution_url(@api_v1_contribution)
  end

  test "should destroy api_v1_contribution" do
    assert_difference('Api::V1::Contribution.count', -1) do
      delete api_v1_contribution_url(@api_v1_contribution)
    end

    assert_redirected_to api_v1_contributions_url
  end
end
