module IterationsTestHelper
    # Return the parameters to use for a successful create.
  def create_success_parameters
    {:record => {:name => 'foo', :start => Date.today, :project_id => 1, :finish => Date.today + 14}}
  end

  # Return the parameters to use for a failed create.
  def create_failure_parameters
    {:record => {:name => '', :start => Date.today, :project_id => 1}}
  end

  # Return the parameters to use for a successful update.
  def update_success_parameters
    {:record => {:name => 'foo'}}
  end

  # Return the parameters to use for a failed update.
  def update_failure_parameters
    {:record => {:name => ''}}
  end
  
  # Answer the context for this resource (if contained within scope of others).
  def context
    {}
  end
  
  # Answer the number of resources that exist.
  def resource_count
    Iteration.count(:conditions => {:project_id => 1})
  end

  # Verify that the object was created.
  def assert_create_succeeded
    assert Iteration.find_by_name('foo')
  end

  # Verify that the object was updated.
  def assert_update_succeeded
    assert Iteration.find_by_name('foo')
  end

  # Verify that the object was not created / updated.
  def assert_change_failed
    assert_nil Iteration.find_by_name('')
  end

  # Verify that the object was not created / updated with valid changes.
  def assert_valid_change_failed
    assert_nil Iteration.find_by_name('foo')
  end

  # Verify that the object was deleted.
  def assert_delete_succeeded
    assert_nil Iteration.find_by_name('second', :conditions => 'project_id=1')
  end

  # Verify that the object was not deleted.
  def assert_delete_failed
    assert Iteration.find_by_name('second')
  end
end