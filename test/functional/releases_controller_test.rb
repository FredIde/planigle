require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../releases_test_helper"
require "#{File.dirname(__FILE__)}/controller_resource_helper"
require "releases_controller"

# Re-raise errors caught by the controller.
class ReleasesController; def rescue_action(e) raise e end; end

class ReleasesControllerTest < ActionController::TestCase
  include ControllerResourceHelper
  include ReleasesTestHelper

  fixtures :systems
  fixtures :individuals
  fixtures :releases
  fixtures :projects
  fixtures :individuals_projects
    
  # Test getting releases (based on role).
  def test_index_by_admin
    index_by_role(individuals(:quentin), 0)
  end
    
  # Test getting releases (based on role).
  def test_index_by_project_admin
    index_by_role(individuals(:aaron), Release.find_all_by_project_id(1).length)
  end
    
  # Test getting releases (based on role).
  def test_index_by_project_user
    index_by_role(individuals(:user), Release.find_all_by_project_id(1).length)
  end
    
  # Test getting releases (based on role).
  def test_index_by_read_only_user
    index_by_role(individuals(:readonly), Release.find_all_by_project_id(1).length)
  end
    
  # Test getting companies (based on role).
  def test_index_no_changes
    index_by_role(individuals(:aaron), nil, {:date => (Time.now + 5).to_s})
  end
    
  # Test getting companies (based on role).
  def test_index_changes
    index_by_role(individuals(:aaron), Release.find_all_by_project_id(1).length, {:date => (Time.now - 5).to_s})
  end

  # Test getting releases (based on role).
  def index_by_role(user, count, params={})
    login_as(user)
    get :index, {:format => 'xml'}.merge(params)
    assert_response :success
    if (count == 0)
      assert_select "releases", false
    else
      assert_select "releases" do
        assert_select "release", count
      end
    end
  end

  # Test showing an release for another project.
  def test_show_wrong_project
    login_as(individuals(:aaron))
    get :show, :id => 3, :format => 'xml'
    assert_response 401
  end
    
  # Test creating releases (based on role).
  def test_create_by_project_admin
    create_by_role_successful(individuals(:aaron))
  end
    
  # Test creating releases (based on role).
  def test_create_by_project_user
    create_by_role_unsuccessful(individuals(:user))
  end
    
  # Test creating releases (based on role).
  def test_create_by_read_only_user
    create_by_role_unsuccessful(individuals(:readonly))
  end

  # Test creating an release for another project.
  def test_create_wrong_project
    login_as(individuals(:aaron))
    num = resource_count
    params = create_success_parameters.merge( :format => 'xml' )
    params[:record] = params[:record].merge( :project_id => '2' )
    post :create, params
    assert_response 401
    assert_equal num, resource_count
    assert_select 'errors'
  end

  # Create successfully based on role.
  def create_by_role_successful( user )
    login_as(user)
    num = resource_count
    post :create, create_success_parameters.merge( :format => 'xml' )
    assert_response 201
    assert_equal num + 1, resource_count
    assert_create_succeeded
  end    
  
  # Create unsuccessfully based on role.
  def create_by_role_unsuccessful( user )
    login_as(user)
    num = resource_count
    post :create, create_success_parameters.merge( :format => 'xml' )
    assert_response 401
    assert_equal num, resource_count
    assert_select "errors"
  end
    
  # Test updating releases (based on role).
  def test_update_by_project_admin
    update_by_role_successful(individuals(:aaron))
  end
  
  # Test changing project.
  def test_update_project
    update_by_role_unsuccessful(individuals(:aaron), update_success_parameters[resource_symbol].merge({:project_id => 3}))
  end
    
  # Test updating releases (based on role).
  def test_update_by_project_user
    update_by_role_unsuccessful(individuals(:user))
  end
    
  # Test updating releases (based on role).
  def test_update_by_read_only_user
    update_by_role_unsuccessful(individuals(:readonly))
  end
    
  # Test updating an release for another project.
  def test_update_wrong_project
    login_as(individuals(:aaron))
    put :update, {:id => 3, :format => 'xml'}.merge(update_success_parameters)
    assert_response 401
    assert_change_failed
    assert_select 'errors'
  end
  
  # Update successfully based on role.
  def update_by_role_successful( user, params = (update_success_parameters[resource_symbol]) )
    login_as(user)
    put :update, :id => 1, resource_symbol => params, :format => 'xml'
    assert_response :success
    assert_update_succeeded
  end
    
  # Update unsuccessfully based on role.
  def update_by_role_unsuccessful( user, params = (update_success_parameters[resource_symbol]) )
    login_as(user)
    put :update, :id => 1, resource_symbol => params, :format => 'xml'
    assert_response 401
    assert_change_failed
    assert_select "errors"
  end
    
  # Test deleting releases (based on role).
  def test_delete_by_project_admin
    delete_by_role_successful(individuals(:aaron))
  end
    
  # Test deleting releases (based on role).
  def test_delete_by_project_user
    delete_by_role_unsuccessful(individuals(:user))
  end
    
  # Test deleting releases (based on role).
  def test_delete_by_read_only_user
    delete_by_role_unsuccessful(individuals(:readonly))
  end
  
  # Delete from a different project.
  def test_delete_wrong_project
    login_as(individuals(:aaron))
    delete :destroy, :id => 3, :format => 'xml'
    assert_response 401
    assert Release.find_by_name('third')
    assert_select "errors"
  end
      
  # Delete successfully based on role.
  def delete_by_role_successful( user )
    login_as(user)
    delete :destroy, :id => 1, :format => 'xml'
    assert_response :success
    assert_nil Release.find_by_name('first')
  end

  # Delete unsuccessfully based on role.
  def delete_by_role_unsuccessful( user )
    login_as(user)
    delete :destroy, :id => 1, :format => 'xml'
    assert_response 401
    assert Release.find_by_name('first')
    assert_select "errors"
  end
end