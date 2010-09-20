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

Factory.define :invite do |invite|
  invite.email { Factory.next :email }
end

Factory.define :invite_sent, :parent => :invite do |invite|
  invite.invite_code { "foobar" }
  invite.invited_at  { 10.minutes.ago }
end

Factory.define :invite_accepted, :parent => :invite_sent do |invite|
  invite.redeemed_at { 5.minutes.ago }
end