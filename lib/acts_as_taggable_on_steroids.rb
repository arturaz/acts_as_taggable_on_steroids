module ActsAsTaggableOnSteroids
  mattr_accessor :slugizer

  self.slugizer = Proc.new { |name| name }
end
