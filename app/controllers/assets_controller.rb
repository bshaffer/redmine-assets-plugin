#require 'ruby-debug'


class AssetsController < ApplicationController

  before_filter :authorize, :asset_types
  before_filter :find_project, :only => [:index, :by_type]
  
  def index
    @types = types_for_project #Attachment.find(:all, :group => "container_type", :select => "container_type" ).collect(&:container_type)
  end
  
  def by_type
    @type     = params[:type];
    
    # Forward 404 if type does not exist in the mapping
    @mappings[@type].nil? rescue return render :file => "#{RAILS_ROOT}/public/404.html", :status => 404

    @mapping  = @mappings[@type];
    table_name    = (eval @type).table_name
    @options  = {:deletable => true, :author => true}
    
    # Every type will have this join
    joins      = ["INNER JOIN #{table_name} ON #{table_name}.id = container_id and container_type = '#{@type}'"]
    
    # Add extra joins if applicable (for categories or project ID)
    if !@mapping['joins'].nil?
      joins << "INNER JOIN #{@mapping['joins']}"
    end
    
    # Every type will have these conditions
    conditions = "container_type = '#{@type}' AND #{@mapping['project_id']} = #{@project.id}";
    
    # If a category mapping exists
    if(!@mapping['category'].nil?)
      @assets   = Attachment.find(:all, {
        :conditions => conditions, 
        :joins      => joins.join(' '),
        :order      => "#{@mapping['category']['name']} ASC, attachments.filename ASC"})

    # If a category mapping doesnt exist
    else
      @assets   = Attachment.find(:all, {
        :conditions => conditions, 
        :joins      => joins.join(' '),
        :order      => "attachments.filename ASC"})
        
    end
  end

 private
  def types_for_project
     joins = []
     wheres = []
     @mappings.each_pair do |type, mapping|
       table    = (eval type).table_name
       
       joins << "LEFT JOIN #{table} ON #{table}.id = container_id AND container_type = '#{type}'"

       if !mapping['joins'].nil?
         joins << "LEFT JOIN #{mapping['joins']}"
       end
       
       wheres << "(#{mapping['project_id']} = #{@project.id})"
     end

     return Attachment.find(:all, {:group => "container_type", :conditions => wheres.join(' OR '), :joins => joins.join(' ')}).collect(&:container_type).compact
  end
 
  def find_project
    @project = Project.find(params[:project_id])
    raise ActiveRecord::RecordNotFound, l(:asset_project_not_found_error) + " id:" + params[:project_id] unless @project
  end
  
  def asset_types
    require 'yaml'
    @mappings = YAML::load(File.open("#{RAILS_ROOT}/vendor/plugins/redmine_assets_plugin/config/mappings.yml"))
    # set defaults
    @mappings.each_pair do |type, mapping|
       table    = (eval type).table_name
       if mapping.nil?
         @mappings[type] = mapping = {}
       end
       
       if mapping['project_id'].nil?
         @mappings[type]['project_id'] = "#{table}.project_id"
       end

       if !mapping['category'].nil? && mapping['category']['relation'].nil?
        @mappings[type]['category']['relation'] = 'category'
       end

       if !mapping['category'].nil? && mapping['category']['id'].nil?
        @mappings[type]['category']['id'] = 'category_id'
       end
       
       if !mapping['category'].nil? && mapping['category']['name'].nil?
        @mappings[type]['category']['name'] = 'name'
       end
    end
  end
  
  def authorize
    find_project
    super
  end
end
