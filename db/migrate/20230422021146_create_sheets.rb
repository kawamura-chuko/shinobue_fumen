class CreateSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :sheets do |t|
      t.string :title, null: false
      t.integer :level, null: false
      t.text :comma_joined_mml, null: false

      t.timestamps
    end
  end
end
