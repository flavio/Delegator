class HomeController < ApplicationController
  def index
    unless current_user.nil?
      @user = current_user
      @identities = @user.identities.paginate :page => params[:page], :order => 'created_at DESC'
    end
  end
end
