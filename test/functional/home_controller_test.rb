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

class HomeControllerTest < ActionController::TestCase
  context "on GET :index" do
    setup do
      puts "global setup"
    end
    
    teardown do
      puts "global teardown"
    end

    context "user not logged" do
      setup do
        puts "local setup"
        get :index
      end

      teardown do
        puts "local teardown"
      end

      should respond_with :success
      should render_template(:index)
      should_not assign_to(:users)
      should_not assign_to(:identities)
    end

    context "user logged in" do
      setup do
        @user = Factory(:email_confirmed_user)
        5.times { @user.identities << Factory(:identity) }
        sign_in_as(@user)
        get :index
      end

      should assign_to(:user) 
      should "not show identities" do
        assert_response :success
        assert_equal @user, assigns(:user)
        assert_same_elements(@user.identities, assigns(:identities))
      end
    end
  end
end
