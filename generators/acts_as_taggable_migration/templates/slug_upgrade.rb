class ActsAsTaggableSlugUpgrade < ActiveRecord::Migration
  def self.up
    add_column :tags, :slug, :string

    remove_index :tags, :name
    add_index :tags, :slug

    print "Slugizing existing tags. This could take a while..."
    Tag.find(:all).each do |tag|
      tag.slug = ActsAsTaggableOnSteroids.slugizer.call(tag.name)
      tag.save!
    end
    puts " Done. Enjoy!"
  end
  
  def self.down
    remove_column :tags, :slug
    remove_index :tags, :slug
    add_index :tags, :name
  end
end
