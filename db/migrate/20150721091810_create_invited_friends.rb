class CreateInvitedFriends < ActiveRecord::Migration
  def change
    create_table :invited_friends do |t|
      t.references :user, index: true
      t.string :email
      t.string :invite_token
      t.datetime :invite_last_send_at

      t.timestamps null: false
    end

    add_index :invited_friends, :email, unique: true
    add_index :invited_friends, :invite_token, unique: true
  end
end
