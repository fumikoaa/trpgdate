class CreatePldates < ActiveRecord::Migration[5.2]
  def change
    create_table :pldates do |t|
      t.string :name, limit: 40, null: false
      t.text :url
      t.text :title, limit: 30, null: false
      t.timestamps
    end
  end
end
