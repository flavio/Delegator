class Mailer < ActionMailer::Base
  def invitation(invite)
    from       "do_not_reply@delegator.com"
    recipients invite.email
    subject    "Welcome to Delegator"
    body       :invite => invite
  end
end
