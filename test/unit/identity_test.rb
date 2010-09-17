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
