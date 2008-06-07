require File.dirname(__FILE__) + '/abstract_unit'

class TagTest < Test::Unit::TestCase
  fixtures :tags, :taggings, :users, :photos, :posts
  
  def test_name_required
    t = Tag.create
    assert_match /blank/, t.errors[:name].to_s
  end
  
  def test_name_unique
    t = Tag.create!(:name => "My tag")
    duplicate = t.clone
    
    assert !duplicate.save
    assert_match /taken/, duplicate.errors[:name].to_s
  end
  
  def test_taggings
    assert_equivalent [taggings(:jonathan_sky_good), taggings(:sam_flowers_good), taggings(:sam_flower_good), taggings(:ruby_good)], tags(:good).taggings
    assert_equivalent [taggings(:sam_ground_bad), taggings(:jonathan_bad_cat_bad)], tags(:bad).taggings
  end
  
  def test_to_s
    assert_equal tags(:good).name, tags(:good).to_s
  end

  def test_default_slugizer
    name = "Foobar has left the building"
    t = Tag.new(:name => name)
    t.save
    assert_equal name, t.slug
  end

  def test_custom_slugizer
    old_slugizer = ActsAsTaggableOnSteroids.slugizer
    ActsAsTaggableOnSteroids.slugizer = Proc.new do |name|
      name.gsub(%r{([^a-z0-9]|-)+}i, '-').gsub(%r{^-?(.*?)-?$}, '\1') \
        .downcase
    end

    name = "My (baby) girl got born!"
    t = Tag.new(:name => name)
    t.save
    assert_equal 'my-baby-girl-got-born', t.slug
    ActsAsTaggableOnSteroids.slugizer = old_slugizer
  end 

  def test_equality
    assert_equal tags(:good), tags(:good)
    assert_equal Tag.find(1), Tag.find(1)
    assert_equal Tag.new(:name => 'A'), Tag.new(:name => 'A')
    assert_not_equal Tag.new(:name => 'A'), Tag.new(:name => 'B')
  end
end
