Assets plugin for redmine
=========================

Provides a central location to view all your project's assets.

Overview
--------

This will enable the `Assets` tab in your project.  The assets tab groups assets by your different asset types.
There are currently three supported asset types: `Issues`, `Messages`, and `Documents`.  `Files` are not supported,
as this module should be used *instead* of the Files module.  Only the types that have uploaded files in the 
current project will be displayed.  Drilling down into an asset type will show an alphabetical list of assets,
grouped by category if applicable.

Requirements
------------

* Rails 2.2.1 or greater

Installation 
------------

0. Follow the Redmine plugin installation steps at: http://www.redmine.org/wiki/redmine/Plugins 
1. Cd to your redmine vendor/plugins dir.
2. Git-clone the plugin from this repo into a folder in there (git clone git://github.com/bshaffer/redmine-assets-plugin.git redmine_assets_plugin)
3. Run the plugin migrations +rake db:migrate_plugins+
4. Restart your Redmine web servers (e.g. mongrel, thin, mod_rails)
5. Login to your Redmine install as an Administrator
6. Setup the permissions for the assets module for your roles
7. Enable the module on a per-project basis as needed.

NOTE: the plugin directory *has* to be "redmine_assets_plugin"

Activation
----------

To activate in your project:

* Navigate to your project's "Settings" page
* Under the "Modules" tab, check the box next to "Assets list" and save

Config
------

You can configure additional asset types via the `config/mappings.yml` file.  Mappings to the 
content type's project_ids and categories are found here.
Contact me or submit a pull request for additional asset types.  
Leaving out the "category" key in `mappings.yml` will disable categorization.  
Leaving out the "project_id" key will default to *project_id*.
As a bare minimum, the mappings.yml file requires the name of the asset type, followed by an empty hash:

    NewAssetType: {}
    
This will display the assets for class NewAssetType with a project_id field and no categories.
