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

class InviteTest < ActiveSupport::TestCase
  context "validation" do
    setup do
      @invite = Factory.create(:invite)
    end
    should belong_to(:user)
    should validate_uniqueness_of(:email).with_message("is already registered")
    should validate_presence_of(:email)
  end

  context "manage invite" do
    should "create invitation code" do
      invite = Factory.create(:invite)
      assert_nil invite.invite_code
      invite.invite!
      assert_not_nil invite.invite_code
    end

    should "overwrite invitation code" do
      old_invite_code = "foo"
      invite = Factory.create(:invite, :invite_code => old_invite_code)
      invite.invite!
      assert_not_equal old_invite_code, invite.invite_code
    end

    should "redeem the invitation" do
      invite = Factory.create(:invite_sent)
      assert_nil invite.redeemed_at
      invite.redeemed!
      assert_not_nil invite.redeemed_at
    end

    should "find not invited" do
      assert !Factory.create(:invite).invited?
    end
    should "find invited" do
      assert Factory.create(:invite_sent).invited?
      assert Factory.create(:invite_accepted).invited?
    end
  end
end