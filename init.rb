require 'redmine'

Dir[File.join(File.dirname(__FILE__),'vendor','plugins','*')].each do |dir|
  path = File.join(dir, 'lib')
  $LOAD_PATH << path
  Dependencies.load_paths << path
  Dependencies.load_once_paths.delete(path)
end

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
      
  menu :project_menu, :project_assets, {:controller => 'assets', :action => 'index'}, :caption => :label_asset_plural, :after => :new_issue, :param => :project_id
end


