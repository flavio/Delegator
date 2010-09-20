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

module OpenidInspector
  def inspect_openid_page url
    reply = {:status => true}
    begin
      doc = Nokogiri::HTML(open(url))
      if doc.css('head > link[@rel="openid.server"]').empty?
        reply[:status] = false
        reply[:errors] = [["Error while contacting your openid server",
                           "cannot find openid.server value"]]
      else
        reply[:openid_server] =  doc.css('head > link[@rel="openid.server"]').first.attributes["href"].to_s
      end

      if doc.css('head > link[@rel="openid.delegate"]').empty?
        reply[:openid_delegate] =  url
      else
        reply[:openid_delegate] =  doc.css('head > link[@rel="openid.delegate"]').first.attributes["href"].to_s
      end
    rescue
      logger.error "Error while contacting remote openid server: #{$!}"
      reply[:status] = false
      reply[:errors] = [["Error while contacting your openid server", ""]]
    end
    return reply
  end
end