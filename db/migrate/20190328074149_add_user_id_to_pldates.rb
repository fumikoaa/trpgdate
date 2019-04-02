class AddUserIdToPldates < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM pldates'
    add_reference :pldates, :user, null: false, index: true
  end

  def down
    remove_reference :pldates, :user, index: true
  end
end
