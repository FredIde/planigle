class AddPriority < ActiveRecord::Migration
  def self.up
    add_column :stories, :priority, :integer
    Story.find_with_deleted(:all).each {|story| story.priority = story.id; story.save(false)}
  end

  def self.down
    remove_column :stories, :priority
  end
end
