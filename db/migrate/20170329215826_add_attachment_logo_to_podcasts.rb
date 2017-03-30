class AddAttachmentLogoToPodcasts < ActiveRecord::Migration
  def self.up
    change_table :podcasts do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :podcasts, :logo
  end
end
