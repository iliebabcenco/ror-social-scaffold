class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :initiator, foreign_key: { to_table: :users }
      t.references :invitee, foreign_key: { to_table: :users }
      t.boolean :confirmed

      t.timestamps
    end
  end
end
