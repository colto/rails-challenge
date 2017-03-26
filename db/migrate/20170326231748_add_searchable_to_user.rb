class AddSearchableToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :searchable, :text, default: ''
  end
end
