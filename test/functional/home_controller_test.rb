require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  context "on GET :index" do
    context "user not logged" do
      should "not show identities" do
        get :index
        assert_response :success
        assert_nil assigns(:user)
        assert_nil assigns(:identities)
      end
    end

    context "user logged in" do
      should "not show identities" do
        user = Factory(:email_confirmed_user)
        5.times { user.identities << Factory(:identity) }
        sign_in_as(user)

        get :index
        assert_response :success
        assert_equal user, assigns(:user)
        assert_same_elements(user.identities, assigns(:identities))
      end
    end
  end
end
