class PortfolioEntry < ActiveRecord::Base
  belongs_to :title_image, :class_name => 'Image'
  belongs_to :title_resource, :class_name => 'Resource'  

  validates :title, :presence => true

  # call to gems included in refinery.
  has_friendly_id :title, :use_slug => true
  acts_as_nested_set
  default_scope :order => 'lft ASC'
  acts_as_indexed :fields => [:title, :image_titles, :image_names, :resource_titles, :resource_names]

  has_many :images_portfolio_entries
  has_many :images, :through => :images_portfolio_entries, :order => 'images_portfolio_entries.position ASC'
  has_many :resources_portfolio_entries
  has_many :resources, :through => :resources_portfolio_entries, :order => 'resources_portfolio_entries.position ASC'  
  accepts_nested_attributes_for :images, :allow_destroy => false
  accepts_nested_attributes_for :resources, :allow_destroy => false  

  def images_attributes=(data)
    self.images.clear

    self.images = (0..(data.length-1)).collect { |i|
      unless (image_id = data[i.to_s]['id'].to_i) == 0
        Image.find(image_id) rescue nil
      end
    }.compact
  end
  
  def image_titles
    self.images.collect{|i| i.title}
  end
  
  def image_names
    self.images.collect{|i| i.image_name}
  end
  
  def resources_attributes=(data)
    self.resources.clear

    self.resources = (0..(data.length-1)).collect { |i|
      unless (resource_id = data[i.to_s]['id'].to_i) == 0
        Resource.find(resource_id) rescue nil
      end
    }.compact
  end
  
  def resource_titles
    self.resources.collect{|i| i.title}
  end
  
  def resource_names
    self.resources.collect{|i| i.resource_name}
  end

  alias_attribute :content, :body

end
