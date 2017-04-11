class AddAttributesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :tell_something, :text
  end
end
