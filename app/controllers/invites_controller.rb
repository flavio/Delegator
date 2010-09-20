# This file is part of the delegator project
#
# Copyright (C) 2010 Flavio Castelli <flavio@castelli.name>
#
# delegator is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# jump is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Keep; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

class InvitesController < ApplicationController
  before_filter :access_for_admin

  # GET /invites
  # GET /invites.xml
  def index
    @invites = Invite.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invites }
    end
  end

  def send_invitation
    @invite = Invite.find(params[:id])
    @invite.invite!
    Mailer.deliver_invitation(@invite)
    flash[:notice] = "Invite sent to #{@invite.email}"
    redirect_to(invites_url)
  end


  # GET /invites/1
  # GET /invites/1.xml
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.xml
  def new
    @invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # POST /invites
  # POST /invites.xml
  def create
    @invite = Invite.new(params[:invite])

    respond_to do |format|
      if @invite.save
        format.html { redirect_to(@invite, :notice => 'Invite was successfully created.') }
        format.xml  { render :xml => @invite, :status => :created, :location => @invite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.xml
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to(invites_url) }
      format.xml  { head :ok }
    end
  end
end
