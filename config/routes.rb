#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|

  map.resources :assets, :name_prefix => 'project_', :path_prefix => '/projects/:project_id',
    :member => {:toggle_complete => :post }, :collection => {:sort => :post}
  
  map.resources :assets, :name_prefix => 'user_', :path_prefix => '/users/:user_id', :controller => :assets,
    :member => {:toggle_complete => :post }, :collection => {:sort => :post}
  
  map.assets 'assets', :controller => :assets, :action => :index
end
