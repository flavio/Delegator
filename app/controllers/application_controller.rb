# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def access_for_admin
    if !signed_in?
      deny_access 
    elsif !current_user.admin
      flash[:error] = "Authorization error."
      redirect_to current_user
    end
  end
end
