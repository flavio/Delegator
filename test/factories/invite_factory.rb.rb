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