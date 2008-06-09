class Survey < ActiveRecord::Base
  require 'bigdecimal'

  belongs_to :project
  has_many :survey_mappings, :dependent => :destroy
  
  validates_presence_of     :project_id, :email
  validates_length_of       :email,    :within => 6..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i

  attr_accessible :project_id, :email, :excluded
  
  # Override to_xml to include survey mappings.
  def to_xml(options = {})
    if !options[:include]
      options[:include] = [:survey_mappings]
    end
    super(options)
  end

  # Update the user rankings on the stories
  def apply_to_stories
    self.class.update_rankings(project)
  end
  
  # Update the user rankings on the stories for a project.
  def self.update_rankings(project)
    # For each survey, adjust priority by removing stories that have been accepted.  This ensures that
    # older surveys don't throw off the rankings.
    hash = {}
    project.surveys.find(:all, :conditions => 'excluded=false').each do |survey|
      i = 1
      survey.survey_mappings.find(:all, :conditions => 's.status_code < 2', :joins => 'inner join stories as s on survey_mappings.story_id = s.id', :order => 'survey_mappings.priority').each do |sm|
        if !hash.include? sm.story
          hash[sm.story] = []
        end
        hash[sm.story] << i
        i += 1
      end
    end

    # Now update the stories user priority to be an average.
    hash.each_key do |story| # Use BigDecimal for more precision
      story.user_priority = BigDecimal((hash[story].inject(0) {|total, priority| total + priority }).to_s) / hash[story].length
    end
    
    hash.keys
  end
end