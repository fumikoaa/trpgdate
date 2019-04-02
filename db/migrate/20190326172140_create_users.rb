class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name,  limit: 50, null:false
      t.string :email,limit: 191, null: false
      t.string :password_digest, null: false
      t.string :remember_token

      t.timestamps
      t.index :email, unique: true
    end
  end
end
