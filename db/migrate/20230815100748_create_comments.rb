class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.integer :embed_type, null: false, default: 0
      t.string :identifier
      t.string :audio
      t.string :video
      t.references :user, null: false, foreign_key: true
      t.references :sheet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
