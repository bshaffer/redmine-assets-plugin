#require 'ruby-debug'


class AssetsController < ApplicationController

  before_filter :authorize
  
  def index
    find_project
    
    @types = types_for_project #Attachment.find(:all, :group => "container_type", :select => "container_type" ).collect(&:container_type)
  end
  
  def by_type
    find_project
    @type     = params[:type];
    
    (eval @type).nil? rescue return render :file => "#{RAILS_ROOT}/public/404.html", :status => 404

    @table    = (eval @type)
    table_name    = @table.table_name
    @options  = {:deletable => true, :author => true}
    
    if (@type == 'Message')
      project_id_path = "boards.project_id"
      joins      = "INNER JOIN #{table_name} ON #{table_name}.id = container_id and container_type = '#{@type}' INNER JOIN boards on #{table_name}.board_id = boards.id"
    else
      project_id_path = "#{table_name}.project_id"
      joins      = "INNER JOIN #{table_name} ON #{table_name}.id = container_id and container_type = '#{@type}'"
    end
    
    conditions = "container_type = '#{@type}' AND #{project_id_path} = #{@project.id}";
    
    if(@table.column_names.include? 'category_id')
      @assets   = Attachment.find(:all, {
        :conditions => conditions, 
        :joins => joins,
        :order => "category_id ASC"})
              
      render 'by_type_and_category'
    else
      @assets   = Attachment.find(:all, {
        :conditions => conditions, 
        :joins => joins})
    end
  end

 private
  def types_for_project
     alltypes = Attachment.find(:all, :group => "container_type", :select => "container_type" ).collect(&:container_type)
     joins = []
     wheres = []

     for type in alltypes
       table    = (eval type).table_name
       joins << "LEFT JOIN #{table} ON #{table}.id = container_id AND container_type = '#{type}'"
       if (table == 'messages') 
         joins << "LEFT JOIN boards on #{table}.board_id = boards.id"
         wheres << "(boards.project_id = #{@project.id})"
       else
         wheres << "(#{table}.project_id = #{@project.id})"
       end
     end

     return Attachment.find(:all, {:group => "container_type", :conditions => wheres.join(' OR '), :joins => joins.join(' ')}).collect(&:container_type)
  end
 
  def find_project
    @project = Project.find(params[:project_id])
    raise ActiveRecord::RecordNotFound, l(:todo_project_not_found_error) + " id:" + params[:project_id] unless @project
  end
  
  def authorize
    find_project
    super
  end
end
