class AddAttachmentEpisodeLogoToEpisodes < ActiveRecord::Migration
  def self.up
    change_table :episodes do |t|
      t.attachment :episode_logo
    end
  end

  def self.down
    remove_attachment :episodes, :episode_logo
  end
end
