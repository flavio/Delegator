# This file is part of the delegator project
#
# Copyright (C) 2010 Flavio Castelli <flavio@castelli.name>
#
# delegator is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# jump is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Keep; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

require 'test_helper'

class IdentitiesControllerTest < ActionController::TestCase
  context 'GET :show_by_username' do
    context "invalid identity" do
      setup do
        get :show_by_username, :username => "invalid"
      end
      should render_template(:nothing)
    end

    context "valid identity" do
      setup do
        @identity = Factory(:identity)
      end

      should "handle simple url" do
        get :show_by_username, :username => @identity.name
        assert_response :success
        assert_equal @identity, assigns(:identity)
        assert_select( 'head > link[rel="openid.delegate"]').each do |match|
          assert_equal @identity.openid_delegate, match["href"]
        end
        assert_select( 'head > link[rel="openid.server"]').each do |match|
          assert_equal @identity.openid_server, match["href"]
        end
      end

      should "handle complex url" do
        get :show_by_username, :username => "#{@identity.name}+123"
        assert_response :success
        assert_equal @identity, assigns(:identity)
        assert_select( 'head > link[rel="openid.delegate"]').each do |match|
          assert_equal @identity.openid_delegate, match["href"]
        end
        assert_select( 'head > link[rel="openid.server"]').each do |match|
          assert_equal @identity.openid_server, match["href"]
        end
      end
    end
  end

  context 'GET :edit' do
    context "user not logged in" do
      setup do
        get :edit, :id => 1
      end
      should respond_with(:redirect)
    end

    context "logged in" do
      setup do
        @user = Factory(:email_confirmed_user)
        @identity = Factory(:identity)
        @user.identities << @identity
        sign_in_as @user
      end

      should "allow editing of user identities" do
        get :edit, :id => @identity.id
        assert_response :success
        assert_equal @identity, assigns(:identity)
      end

      should "not allow editing of other user identities" do
        another_user = Factory(:email_confirmed_user)
        another_identity = Factory(:identity)
        another_user.identities << another_identity

        get :edit, :id => another_identity.id
        assert_redirected_to user_path(@user)
      end
    end
  end

  context 'PUT :update' do
    context "user not logged in" do
      setup do
        put :update, :id => 1
      end
      should respond_with(:redirect)
    end

    context "logged in" do
      setup do
        @user = Factory(:email_confirmed_user)
        @identity = Factory(:identity)
        @user.identities << @identity
        @new_identity_attributes = {:name => "new name",
          :openid_url => @identity.openid_url,
          :openid_delegate => @identity.openid_delegate,
          :openid_server => @identity.openid_server}
        sign_in_as @user
      end

      should "allow update of user identities" do
        put :update, :id => @identity.id, :identity => @new_identity_attributes
        assert_redirected_to @user
        @identity.reload
        assert_equal @new_identity_attributes[:name], @identity.name
      end

      should "contact the real openid server again if needed" do
        FakeWeb.allow_net_connect=false
        @new_identity_attributes[:openid_url] = "http://another.example.com"
        openid_inspect_reply = {:status => true,
                              :openid_delegate => "http://delegate.example.com",
                              :openid_server => "http://server.example.com"}
        @controller.expects(:inspect_openid_page).\
                    with(@new_identity_attributes[:openid_url]).once.\
                    returns(openid_inspect_reply)
        put :update, :id => @identity.id, :identity => @new_identity_attributes
        @identity.reload
        assert_equal @new_identity_attributes[:name], @identity.name
        assert_equal @new_identity_attributes[:openid_server],
                     @identity.openid_server
        assert_equal @new_identity_attributes[:openid_delegate],
                     @identity.openid_delegate
        assert_equal @new_identity_attributes[:openid_url],
                     @identity.openid_url
        assert_redirected_to @user
        FakeWeb.allow_net_connect=true
      end

      should "not allow editing of other user identities" do
        another_user = Factory(:email_confirmed_user)
        another_identity = Factory(:identity)
        another_user.identities << another_identity

        put :update, :id => another_identity.id, :identity => @new_identity_attributes
        assert_redirected_to user_path(@user)
      end
    end
  end
end
