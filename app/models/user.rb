class User < ActiveRecord::Base
  include Clearance::User
  has_many :identities, :dependent => :destroy
  has_one :invite, :dependent => :destroy
end
