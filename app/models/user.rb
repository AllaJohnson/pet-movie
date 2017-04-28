class User < ApplicationRecord
   # Include default devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable and :omniauthable
   devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
   has_many :movies

   has_attached_file :photo, styles: { medium: "300x300#", thumb: "100x100" }, default_url: "/images/:style/c-missing.png"
   validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
