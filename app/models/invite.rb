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

require 'digest/sha1'

class Invite < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email, :on => :save, :message => "can't be blank"
  validates_uniqueness_of :email, :on => :save, :message => "is already registered"

  named_scope :unsent_invitations, :conditions => {:redeemed_at => nil, :invite_code => nil}

  def invited?
    !!self.invite_code && !!self.invited_at
  end

  def invite!
    self.invite_code = Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--#{self.email}--")
    self.invited_at = Time.now.utc
    self.save!
  end

  def self.find_redeemable(invite_code)
    self.find(:first, :conditions => {:redeemed_at => nil, :invite_code => invite_code})
  end

  def redeemed!
    self.redeemed_at = Time.now.utc
    self.save!
  end
end
