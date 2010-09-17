require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "validation" do
    setup do
      @user = Factory.create(:user)
    end
    should have_many(:identities)
    should have_one(:invite)
  end
end