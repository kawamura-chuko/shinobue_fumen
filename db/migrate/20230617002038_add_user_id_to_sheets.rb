class AddUserIdToSheets < ActiveRecord::Migration[7.0]
  def change
    add_reference :sheets, :user, null: false, foreign_key: true
    add_column :sheets, :state, :integer, null: false, default: 0
  end
end
