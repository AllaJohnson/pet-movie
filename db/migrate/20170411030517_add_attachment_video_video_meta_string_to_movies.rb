class AddAttachmentVideoVideoMetaStringToMovies < ActiveRecord::Migration[5.0]
  def self.up
    change_table :movies do |t|
      t.attachment :video
      t.attachment :video_meta, :string

    end
  end

  def self.down
    remove_attachment :movies, :video
    remove_attachment :movies, :video_meta, :string

  end
end
