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

class IdentityTest < ActiveSupport::TestCase
  context "validation" do
    setup do
      @identity = Factory.create(:identity)
    end
    
    should belong_to(:user)
    should validate_uniqueness_of(:name)
    should validate_presence_of(:name)

    [:openid_server,:openid_delegate,:openid_url].each do |url_attribute|
      should validate_presence_of(url_attribute)
      should_not allow_value("broken_url").for(url_attribute)
      should_not allow_value("").for(url_attribute)
      should_not allow_value(nil).for(url_attribute)
      should_not allow_value("http:/example.com").for(url_attribute)
      should allow_value("http://example.com").for(url_attribute)
    end
  end
end
