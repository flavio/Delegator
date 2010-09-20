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

class IdentitiesController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  include OpenidInspector

  def show_by_username
    params[:username] =~ /(\A\w+)(\+\d+)?/
    @username = $1

    @identity = Identity.find_by_name @username
    if @identity.nil?
      render :nothing
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
