require 'redmine'

Redmine::Plugin.register :redmine_priorities_plugin do
  name 'Redmine Assets plugin'
  author 'centresource interactive agency'
  description 'Provides a central location to view all your project\'s assets.'
  version '0.0.1'
  
  project_module :asset_lists do
    permission :view_asset, {:assets => [:index, :by_type] }
      
    permission :edit_asset,
      {:asset => [:create, :destroy, :new, :toggle_complete, :sort, :edit, :update],
        :issues => [:create, :destroy, :new, :toggle_complete, :sort, :edit, :update]}
  end
 
  menu :top_menu, :assets, { :controller => 'assets', :action => 'index' }, 
    :caption => :assets_title,
    :if => Proc.new {
      User.current.allowed_to?(:use_personal_assets, nil, :global => true)
    }
     
  menu :project_menu, :assets, {:controller => 'assets', :action => 'index'}, 
      :caption => :label_asset_plural, :after => :new_issue, :param => :project_id

  activity_provider :assets, :default => false
end

#fix required to make the plugin work in devel mode with rails 2.2
# as per http://www.ruby-forum.com/topic/171629
load_paths.each do |path|
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end




