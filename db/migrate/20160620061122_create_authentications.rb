class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.text :uid

      t.timestamps null: false
    end

    add_index :authentications, :provider
    add_index :authentications, :uid
  end
end
