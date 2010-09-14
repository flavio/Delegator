module IdentitiesHelper
  def actions identity_id
    html = "<a href='javascript:delete_identity(#{identity_id})'>Delete</a>"
    html += " "
    html += link_to "Edit", :controller => :identities, :action => :edit,
                            :id => identity_id.to_i
    html
  end
end
