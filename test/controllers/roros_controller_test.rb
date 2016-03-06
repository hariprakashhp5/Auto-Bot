require 'test_helper'

class RorosControllerTest < ActionController::TestCase
  setup do
    @roro = roros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roro" do
    assert_difference('Roro.count') do
      post :create, roro: { name: @roro.name }
    end

    assert_redirected_to roro_path(assigns(:roro))
  end

  test "should show roro" do
    get :show, id: @roro
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roro
    assert_response :success
  end

  test "should update roro" do
    patch :update, id: @roro, roro: { name: @roro.name }
    assert_redirected_to roro_path(assigns(:roro))
  end

  test "should destroy roro" do
    assert_difference('Roro.count', -1) do
      delete :destroy, id: @roro
    end

    assert_redirected_to roros_path
  end
end
