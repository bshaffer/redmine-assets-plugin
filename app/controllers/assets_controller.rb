#require 'ruby-debug'


class AssetsController < ApplicationController

  before_filter :authorize
  
 #global string to use as the suffix for the element id for todo's <UL> 
  UL_ID = "todo-children-ul_"
  TODO_LI_ID = "todo_"
  
  def index
    find_project
   
  end

 private
  def find_project
    @project = Project.find(params[:project_id])
    raise ActiveRecord::RecordNotFound, l(:todo_project_not_found_error) + " id:" + params[:project_id] unless @project
  end
  
  def authorize
    find_project
    super
  end
end
