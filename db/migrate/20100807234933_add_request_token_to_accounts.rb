class AddRequestTokenToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :request_token, :string
    add_column :accounts, :request_secret, :string 
    add_column :accounts, :authorized, :boolean
    rename_column :accounts, :token, :access_token
    rename_column :accounts, :key, :access_secret
  end

  def self.down
    remove_column :accounts, :authorized
    rename_column :accounts, :access_secret, :key
    rename_column :accounts, :access_token, :token
    remove_column :accounts, :request_secret
    remove_column :accounts, :request_token
  end
end
