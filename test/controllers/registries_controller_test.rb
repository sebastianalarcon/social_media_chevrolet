require 'test_helper'

class RegistriesControllerTest < ActionController::TestCase
  setup do
    @registry = registries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registry" do
    assert_difference('Registry.count') do
      post :create, registry: { last_registry: @registry.last_registry }
    end

    assert_redirected_to registry_path(assigns(:registry))
  end

  test "should show registry" do
    get :show, id: @registry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registry
    assert_response :success
  end

  test "should update registry" do
    patch :update, id: @registry, registry: { last_registry: @registry.last_registry }
    assert_redirected_to registry_path(assigns(:registry))
  end

  test "should destroy registry" do
    assert_difference('Registry.count', -1) do
      delete :destroy, id: @registry
    end

    assert_redirected_to registries_path
  end
end
