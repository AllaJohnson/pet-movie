class Episode < ApplicationRecord
  belongs_to :podcast

  has_attached_file :episode_logo, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :episode_logo, content_type: /\Aimage\/.*\z/
end
