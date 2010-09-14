class Identity < ActiveRecord::Base
  include UrlValidatorHelper
  belongs_to :user
  validates_presence_of :name, :openid_server, :openid_delegate
  validates_uniqueness_of :name
  validates_format_of_url :openid_server, :openid_delegate
end
