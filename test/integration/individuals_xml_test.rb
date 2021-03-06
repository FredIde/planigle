require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../individuals_test_helper"
require "#{File.dirname(__FILE__)}/resource_helper"
require "application"

class IndividualsXmlTest < ActionController::IntegrationTest
  include ResourceHelper
  include IndividualsTestHelper

  fixtures :systems
  fixtures :individuals
  
  class IndividualsController
    # Change so that we're not redirected to SSL.
    def ssl_supported?
      false
    end

    # Re-raise errors caught by the controller.
    def rescue_action(e)
      raise e
    end
  end

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    IndividualMailer.site = 'www.testxyz.com'
    admin2 = individuals(:admin2)
    admin2.selected_project_id=1
    admin2.save(false)
  end

  # Test that you can't delete yourself.
  def test_destroy_self
    delete resource_url << '/6', {}, authorization_header
    assert_response 401 # Unprocessable Entity
    assert Individual.find_by_login('quentin')
  end

  # Test that you can't delete yourself from Flex.
  def test_destroy_self_flex
    flex_login
    delete resource_url << '/6.xml', {}, flex_header
    assert_response 200 # Success
    assert Individual.find_by_login('quentin')
    assert_select 'errors'
  end
end
