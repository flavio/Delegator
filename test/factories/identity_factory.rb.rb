Factory.define :identity do |identity|
  identity.sequence(:name) {|n| "name#{n}" }
  identity.openid_server "http://www.myopenid.com/server"
  identity.openid_delegate "http://foo.myopenid.com/"
  identity.openid_url "http://foo.com"
end