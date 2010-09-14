module OpenidInspector
  def inspect_openid_page url
    reply = {:status => true}
    begin
      doc = Nokogiri::HTML(open(url))
      if doc.css('head > link[@rel="openid.server"]').empty?
        reply[:status] = false
        reply[:errors] = [["Error while contacting your openid server",
                           "cannot find openid.server value"]]
      elsif doc.css('head > link[@rel="openid.delegate"]').empty?
        reply[:status] = false
        reply[:errors] = [["Error while contacting your openid server",
                           "cannot find openid.server value"]]
      else
        reply[:openid_delegate] =  doc.css('head > link[@rel="openid.delegate"]').first.attributes["href"].to_s
        reply[:openid_server] =  doc.css('head > link[@rel="openid.server"]').first.attributes["href"].to_s
      end
    rescue
      logger.error "Error while contacting remote openid server: #{$!}"
      reply[:status] = false
      reply[:errors] = [["Error while contacting your openid server", ""]]
    end
    return reply
  end
end