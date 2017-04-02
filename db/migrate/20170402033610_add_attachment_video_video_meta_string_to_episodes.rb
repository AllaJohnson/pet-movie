class AddAttachmentVideoVideoMetaStringToEpisodes < ActiveRecord::Migration
  def self.up
    change_table :episodes do |t|
      t.attachment :video
      t.attachment :video_meta, :string

    end
  end

  def self.down
    remove_attachment :episodes, :video
    remove_attachment :episodes, :video_meta, :string
    
  end
end
