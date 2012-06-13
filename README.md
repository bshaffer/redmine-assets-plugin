Assets plugin for redmine
=========================

Provides a central location to view all your project's assets.

Overview
--------

This will enable the `Assets` tab in your project.  The assets tab groups assets by your different asset types.
The asset types currently supported are `Issues`, `Messages`, `Documents`, `Versions` (from the Files module), and `WikiPages`.
Only the types that have uploaded files in the current project will be displayed.  Drilling down into an asset type 
will show an alphabetical list of assets, grouped by category if applicable.

Requirements
------------

* Rails 3

Installation 
------------

0. Follow the Redmine plugin installation steps at: [http://www.redmine.org/wiki/redmine/Plugins](http://www.redmine.org/wiki/redmine/Plugins)
1. Cd to your redmine `plugins/` dir
2. Git-clone the plugin from this repo into a folder in there: `git clone git://github.com/bshaffer/redmine-assets-plugin.git redmine_assets_plugin` (*You must name your directory with underscores as shown here, or the plugin will throw a fatal error*)
3. Run the plugin migrations `rake redmine:plugins:migrate`
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
content type's project_ids and categories are found here. Contact me or submit a pull request for additional asset types.  

* Leaving out the "category" key in `mappings.yml` will disable categorization.  
* Leaving out the "project_id" key will default to *project_id*.

As a bare minimum, the mappings.yml file requires the name of the asset type, followed by an empty hash:

    NewAssetType: {}
    
This will display the assets for class NewAssetType with a project_id field and no categories.

Screenshots
-----------

When you click the **Assets** Tab in your project, you will see all the content types in your project that have assets uploaded to them:
![Asset Landing Page](http://brentertainment.com/other/screenshots/redmine_assets_plugin_landing.png)

If anyone has attached any files to the **Document** content type, they will be listed here, organized by Document Category
![Document Assets](http://brentertainment.com/other/screenshots/redmine_assets_plugin_documents.png)

All files attached to **Issues** will be listed here, organized by Issue Category
![Issue Assets](http://brentertainment.com/other/screenshots/redmine_assets_plugin_issues.png)
