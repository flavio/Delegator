class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.string :name, :null => false, :unique => true
      t.integer :user_id
      t.string :openid_server, :string
      t.string :openid_delegate, :string
      t.string :openid_url, :string
      t.timestamps
    end

    add_index :identities, :name
  end

  def self.down
    drop_table :identities
  end
end
