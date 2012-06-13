require 'redmine'

Redmine::Plugin.register :redmine_assets_plugin do
  name 'Redmine Assets plugin'
  author 'Brent Shaffer'
  url 'https://github.com/bshaffer/redmine-assets-plugin'
  author_url 'http://brentertainment.com'
  description 'Provides a central location to view all your project\'s assets.'
  version '0.0.1'
  
  project_module :assets_list do
    permission :view_asset, {:assets => [:index, :by_type] }
      
    permission :edit_asset,
      {:asset => [:create, :destroy, :new, :toggle_complete, :sort, :edit, :update],
        :issues => [:create, :destroy, :new, :toggle_complete, :sort, :edit, :update]}
  end
      
  menu :project_menu, :assets, {:controller => 'assets', :action => 'index'}, 
      :caption => :label_asset_plural, :after => :new_issue, :param => :project_id
end

#fix required to make the plugin work in devel mode with rails 2.2
# as per http://www.ruby-forum.com/topic/171629
if defined? load_paths
	load_paths.each do |path|
	  ActiveSupport::Dependencies.load_once_paths.delete(path)
	end
end




