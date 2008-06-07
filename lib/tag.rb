class Tag < ActiveRecord::Base
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  cattr_accessor :destroy_unused
  self.destroy_unused = false
  
  def self.find_or_create_with_like_by_name(name)
    slug = ActsAsTaggableOnSteroids.slugizer.call(name)
    find(:first, :conditions => ["slug=?", slug]) || create(:name => name)
  end

  before_save :make_slug
  def make_slug
    self.slug = ActsAsTaggableOnSteroids.slugizer.call(self.name)
  end

  def ==(object)
    super || (object.is_a?(Tag) && slug == object.slug)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end
end
