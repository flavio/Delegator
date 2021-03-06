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

class InvitesControllerTest < ActionController::TestCase
  context "user not logged in" do
    [:index, :send_invitation, :show, :new].each do |action|
      context "GET #{action}" do
        setup do
          get action
        end
        should respond_with(:redirect)
      end
    end

    context "POST create" do
      setup do
        post :create
      end
      should respond_with(:redirect)
    end

    context "DELETE destroy" do
      setup do
        delete :destroy
      end
      should respond_with(:redirect)
    end

  end

  context "normal user logged in" do
    [:index, :send_invitation, :show, :new].each do |action|
      context "GET #{action}" do
        setup do
          sign_in
          get action
        end
        should respond_with(:redirect)
      end
    end

    context "POST create" do
      setup do
        sign_in
        post :create
      end
      should respond_with(:redirect)
    end

    context "DELETE destroy" do
      setup do
        sign_in
        delete :destroy
      end
      should respond_with(:redirect)
    end
  end


  context "admin logged in" do
    setup do
      sign_in_as Factory(:admin_user)
    end

    context "get index" do
      setup do
        get :index
      end
      should respond_with(:success)
      should render_template(:index)
    end

    context "get new" do
      setup do
        get :new
      end
      should respond_with(:success)
      should render_template(:new)
    end

    should "create invite" do
      assert_difference('Invite.count', +1) do
        post :create, :invite => {:email => "foo@example.com" }
      end

      assert_redirected_to invite_path(assigns(:invite))
    end

    context "show invite" do
      setup do
        get :show, :id => Factory(:invite).id
      end
      should render_template(:show)
      should respond_with(:success)
    end

    should "destroy invite" do
      invite = Factory(:invite)
      assert_difference('Invite.count', -1) do
        delete :destroy, :id => invite.id
      end

      assert_redirected_to invites_path
    end
  end
end
