class Image
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :product

  has_mongoid_attached_file :attachment, styles: { small: ['110x', :png], medium: ['200x', :png] }
  validates_attachment :attachment, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }
end
