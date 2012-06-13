#custom routes for this plugin
RedmineApp::Application.routes.draw do
  match '/projects/:project_id/assets' => 'assets#index', :via => [:get], :as => 'assets'
  match '/projects/:project_id/assets/:type/type' => 'assets#by_type', :as => 'assets_by_type', :via => [:get]
end
