ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"

  map.resources :users, :controller => 'users'
  map.sign_up '/sign_up', :controller => :users, :action => "new"
  Clearance::Routes.draw(map)

  map.login '/login', :controller => "clearance/sessions", :action => "new"
  map.send_invitation '/send_invitation/:id', :controller => "invites", :action => "send_invitation"
  map.redeem_invitation '/signup/:invite_code', :controller => 'users', :action => 'new'

  map.resources :invites
  map.resources :identities
  

  

  map.connect 'openid/:username',
              :controller => "identities",
              :action => :show_by_username,
              :requirements => {:username => /\w+(\+\d+)?/}
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
