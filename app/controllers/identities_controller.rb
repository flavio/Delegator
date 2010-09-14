class IdentitiesController < ApplicationController
  before_filter :authenticate, :only => [:edit]
  include OpenidInspector

  def show_by_username
    params[:username] =~ /(\A\w+)(\+\d+)?/
    @username = $1

    @identity = Identity.find_by_name @username
    if @identity.nil?
      render "nothing", :status => 404
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @identity }
      end
    end
  end

  def edit
    user = current_user
    @identity = Identity.find(params[:id])
    if !user.identities.include?(@identity)
      flash[:error] = "Authorization error"
      redirect_to user
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def update
    @identity = Identity.find(params[:id])

    if @identity.openid_url != params[:identity][:openid_url]
      details = inspect_openid_page(params[:identity][:openid_url])
      if details[:status] == false
        flash[:error] = details[:errors].join(" ")
        render :action => "edit"
        return
      else
        @identity.openid_server = details[:openid_server]
        @identity.openid_delegate = details[:openid_delegate]
      end
    end
    if @identity.update_attributes(params[:identity])
      flash[:notice] = 'Identity was successfully updated.'
      redirect_to(current_user)
    else
      render :action => "edit"
    end
  end
end
