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
