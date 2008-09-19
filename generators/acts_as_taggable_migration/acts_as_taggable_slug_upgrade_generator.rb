class ActsAsTaggableSlugUpgradeGenerator < Rails::Generator::Base 
  def manifest 
    record do |m| 
      m.migration_template 'slug_upgrade.rb', 'db/migrate' 
    end 
  end
  
  def file_name
    "acts_as_taggable_slug_upgrade"
  end
end
