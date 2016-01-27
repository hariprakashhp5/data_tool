require 'test_helper'

class PrlinksControllerTest < ActionController::TestCase
  setup do
    @prlink = prlinks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prlinks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prlink" do
    assert_difference('Prlink.count') do
      post :create, prlink: { link1: @prlink.link1, link2: @prlink.link2, link3: @prlink.link3, link4: @prlink.link4, operator_id: @prlink.operator_id, region_id: @prlink.region_id }
    end

    assert_redirected_to prlink_path(assigns(:prlink))
  end

  test "should show prlink" do
    get :show, id: @prlink
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prlink
    assert_response :success
  end

  test "should update prlink" do
    patch :update, id: @prlink, prlink: { link1: @prlink.link1, link2: @prlink.link2, link3: @prlink.link3, link4: @prlink.link4, operator_id: @prlink.operator_id, region_id: @prlink.region_id }
    assert_redirected_to prlink_path(assigns(:prlink))
  end

  test "should destroy prlink" do
    assert_difference('Prlink.count', -1) do
      delete :destroy, id: @prlink
    end

    assert_redirected_to prlinks_path
  end
end
