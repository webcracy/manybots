require 'test_helper'

class VerbsControllerTest < ActionController::TestCase
  setup do
    @verb = verbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create verb" do
    assert_difference('Verb.count') do
      post :create, :verb => @verb.attributes
    end

    assert_redirected_to verb_path(assigns(:verb))
  end

  test "should show verb" do
    get :show, :id => @verb.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @verb.to_param
    assert_response :success
  end

  test "should update verb" do
    put :update, :id => @verb.to_param, :verb => @verb.attributes
    assert_redirected_to verb_path(assigns(:verb))
  end

  test "should destroy verb" do
    assert_difference('Verb.count', -1) do
      delete :destroy, :id => @verb.to_param
    end

    assert_redirected_to verbs_path
  end
end
