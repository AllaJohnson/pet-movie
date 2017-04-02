class Episode < ApplicationRecord
  belongs_to :podcast

  has_attached_file :episode_logo, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :episode_logo, content_type: /\Aimage\/.*\z/

  #has_attached_file :mp3
  #validates_attachment :mp3, :content_type => { :content_type => ["audio/mpeg", "audio/mp3"] }, :file_name => {:matches => [/mp3\Z/] }

  has_attached_file :video, :styles => {
    :medium => { :geometry => "640x480", :format => 'flv' },
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:transcoder]
   validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/
end
