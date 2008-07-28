class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.boolean :enabled
      t.datetime :expire_date
      t.datetime :last_connection
      t.references :employee

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end