require_dependency 'user'
require_dependency 'service'
require_dependency 'application_helper'
require_dependency 'users_helper'

class User
  has_one :employee
  has_many :checkings
  
  has_search_index  :additional_attributes => { :expired? => :boolean },
                    :only_attributes       => [ :username, :enabled, :last_connection, :last_activity ],
                    :displayed_attributes  => [ :id, :username, :enabled, :expired?, :last_activity ],
                    :main_model            => true

  def employee_name
    self.employee ? self.employee.fullname : self.username
  end

  def can_be_destroyed?
    self.employee.nil?
  end
end

module UsersHelper

  alias_method :get_headers_rh_override, :get_headers

  def get_headers
    result = ["Employ&eacute;"]
    result += get_headers_rh_override
  end
  
  alias_method :get_rows_rh_override, :get_rows

  def get_rows(user)
    result = [ (user.employee.nil? ? "" : user.employee.fullname) ]
    result += get_rows_rh_override(user)
  end
end

class Service
  has_many :employees
  has_many :jobs

  def can_be_destroyed?
    self.employees.empty? and self.children.empty?
  end
  
  # return all responsibles (employees) for the service
  def responsibles
    responsibles_employees = []
    self.jobs.reject {|n| n.responsible == false}.each do |job|
      responsibles_employees += job.employees
    end
    return responsibles_employees.uniq
  end
  
  # return all employees belonging to the current service according to the belonging jobs or the belonging employees
  def members
    Employee.all(:include => [:service, {:jobs => [:service] }], :conditions => ["services.id =? or services_jobs.id =?", id, id])
  end
end

module ApplicationHelper
  def display_welcome_message
    "Bienvenue, #{current_user.employee_name}"
  end
end
