require 'test_helper'

class ObjectTypesControllerTest < ActionController::TestCase
  setup do
    @object_type = object_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:object_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create object_type" do
    assert_difference('ObjectType.count') do
      post :create, :object_type => @object_type.attributes
    end

    assert_redirected_to object_type_path(assigns(:object_type))
  end

  test "should show object_type" do
    get :show, :id => @object_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @object_type.to_param
    assert_response :success
  end

  test "should update object_type" do
    put :update, :id => @object_type.to_param, :object_type => @object_type.attributes
    assert_redirected_to object_type_path(assigns(:object_type))
  end

  test "should destroy object_type" do
    assert_difference('ObjectType.count', -1) do
      delete :destroy, :id => @object_type.to_param
    end

    assert_redirected_to object_types_path
  end
end
