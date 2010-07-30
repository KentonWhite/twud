class CreateIncomingMails < ActiveRecord::Migration
  def self.up
    create_table :incoming_mails do |t|
      t.string :to
      t.string :from
      t.string :subject
      t.text :text
      t.text :html

      t.timestamps
    end
  end

  def self.down
    drop_table :incoming_mails
  end
end
