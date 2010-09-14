class UsersController < Clearance::UsersController
  include OpenidInspector

  # Override and add in a check for invitation code
  def create
    @user = User.new params[:user]
    invite_code = params[:invite][:invite_code]
    @invite = Invite.find_redeemable(invite_code)

    if invite_code && @invite
      if @user.save
        @user.invite = @invite
        @invite.redeemed!
        ClearanceMailer.deliver_confirmation @user
        flash[:notice] = "You will receive an email within the next few minutes. " <<
                         "It contains instructions for confirming your account."
        redirect_to url_after_create
      else
        render :action => "new"
      end
    else
      flash.now[:notice] = "Sorry, that code is not redeemable"
      render :action => "new"
    end
  end

  def new
    @invite_code = params[:invite_code]
    if @invite_code.blank? || Invite.find_redeemable(@invite_code).nil?
      flash[:notice] = "You don't have an invitation code."
      redirect_to root_url
    else
      super
    end
  end

  def index
    @users = User.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def show
    @user = User.find params[:id]
    @identities = @user.identities.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def add_identity
    user = User.find_by_id(params[:user_id])
    reply = {:status => true}
    if user != current_user
      reply[:status] = false
      reply[:errors] = [["User error", ""]]
    else
      identity = Identity.new(params[:identity])
      identity.user = user
      reply.update(inspect_openid_page(identity.openid_url))

      if reply[:status]
        identity.openid_server = reply[:openid_server]
        identity.openid_delegate = reply[:openid_delegate]
        if identity.save
          reply[:status] = true
          reply[:html] = render_to_string({ :partial => "identity_row",
                                            :layout => false,
                                            :locals => {:identity => identity}})
        else
          reply[:status] = false
          reply[:errors] = identity.errors
        end
      end
    end

    render :json => reply.to_json
  end

  def del_identity
    user = current_user
    reply = {}

    identity = Identity.find_by_id(params[:id])
    if identity.nil?
      reply[:status] = false
      reply[:error_message] = "Cannot find identity."
    elsif !user.identities.include?(identity)
      reply[:status] = false
      reply[:error_message] = "Authorization error."
    else
      user.identities.delete(identity)
      identity.destroy
      reply[:status] = true
    end
    
    render :json => reply.to_json
  end
end
