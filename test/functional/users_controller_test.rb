require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'GET :index' do
    context "user not logged in" do
      setup do
        get :index
      end

      should respond_with(:redirect)
    end

    context "normal user logged in" do
      setup do
        sign_in_as Factory(:email_confirmed_user)
        get :index
      end
      should respond_with(:redirect)
    end

    context "admin user logged in" do
      setup do
        sign_in_as Factory(:admin_user)
        10.times { Factory(:user) }
        get :index
      end
      should respond_with(:success)
      should render_template(:index)
    end
  end

  context 'GET :new' do
    context "no invitation code supplied" do
      setup do
        get :new
      end

      should respond_with(:redirect)
    end

    context "invalid invitation code supplied" do
      setup do
        get :new, :invite_code => "foo"
      end
      should respond_with(:redirect)
    end

    context "valid invitation code" do
      setup do
        invite = Factory(:invite_sent)
        get :new, :invite_code => invite.invite_code
      end
      should respond_with(:success)
      should render_template(:new)
    end
  end

  context 'create user' do
    setup do
      @user_params = {:email => "foo@example.com", :password => "pass"}
    end

    context "no invitation code supplied" do
      setup do
        post :create, :user => @user_params
      end

      should respond_with(:redirect)
    end

    context "invalid invitation code supplied" do
      setup do
        post :create, :user => @user_params,
                      :invite => {:invite_code => "invalid code"}
      end
      should respond_with(:redirect)
    end

    context "valid invitation code" do
      should "create a new user" do
        invite = Factory(:invite_sent)
        assert_difference("User.count", +1) do
          post :create, :user => @user_params,
                        :invite => {:invite_code => invite.invite_code}
        end
        assert_redirected_to sign_in_url
      end
    end
  end

  context 'GET :show' do
    setup do
      @user = Factory.create(:user)
    end

    context "user not logged in" do
      setup do
        get :show, :id => @user.id
      end

      should respond_with(:redirect)
    end

    context "normal user logged in" do
      setup do
        sign_in_as Factory(:email_confirmed_user)
        get :show, :id => @user.id
      end
      should respond_with(:redirect)
    end

    context "admin user logged in" do
      setup do
        sign_in_as Factory(:admin_user)
        get :show, :id => @user.id
      end
      should respond_with(:success)
      should render_template(:show)
    end
  end

  context 'add identity to user' do
    setup do
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect=false
      @user = Factory(:email_confirmed_user)
    end

    teardown do
      FakeWeb.allow_net_connect=true
    end

    context "user is not logged in" do
      should "be accessible only by registered users" do
        get :add_identity, :user_id => @user.id
        assert_response :redirect
      end
    end

    context "user is logged in" do
      setup do
        sign_in_as @user
      end

      should "add a correct openid identity" do
        url = 'http://example.com'
        identity_params = {:name => "foo", :openid_url => url}
        register_fake_response(url, "myopenid_page")
        
        assert @user.identities.empty?
        get :add_identity, :user_id => @user.id, :identity => identity_params
        @user.reload
        assert !@user.identities.empty?

        reply = ActiveSupport::JSON.decode(@response.body)
        assert reply["status"]
      end

      should "add an invalid" do
        identity_params = {:name => "foo"}

        get :add_identity, :user_id => @user.id, :identity => identity_params

        reply = ActiveSupport::JSON.decode(@response.body)
        assert !reply["status"]
      end

      should "not add an identity to another user" do
        url = 'http://example.com'
        another_user =  Factory(:email_confirmed_user)
        identity_params = {:name => "foo", :openid_url => url}
        register_fake_response(url, "myopenid_page")

        assert @user.identities.empty?
        assert another_user.identities.empty?
        get :add_identity, :user_id => another_user.id,
                           :identity => identity_params
        @user.reload
        assert @user.identities.empty?
        another_user.reload
        assert another_user.identities.empty?

        reply = ActiveSupport::JSON.decode(@response.body)
        assert !reply["status"]
      end
    end
  end

  context 'remove identity from user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @identity = Factory(:identity)
      @user.identities << @identity
    end

    context "user is not logged in" do
      should "be accessible only by registered users" do
        get :del_identity, :id => @identity.id, :user_id => @user.id
        assert_response :redirect
      end
    end

    context "user is logged in" do
      setup do
        sign_in_as @user
      end

      should "remove identity" do
        get :del_identity, :id => @identity.id, :user_id => @user.id
        @user.reload
        assert @user.identities.empty?

        reply = ActiveSupport::JSON.decode(@response.body)
        assert reply["status"]
      end

      should "handle references to non existing identities" do
        id = @identity.id
        @identity.delete
        get :del_identity, :id => id, :user_id => @user.id

        reply = ActiveSupport::JSON.decode(@response.body)
        assert !reply["status"]
      end

      should "not delete an identity from another user" do
        url = 'http://example.com'
        another_user =  Factory(:email_confirmed_user)
        another_identity = Factory(:identity)
        another_user.identities << another_identity
        assert !another_user.identities.empty?

        get :del_identity, :id => another_identity.id,
                           :user_id => another_user.id

        another_user.reload
        assert !another_user.identities.empty?

        reply = ActiveSupport::JSON.decode(@response.body)
        assert !reply["status"]
      end
    end
  end
end
