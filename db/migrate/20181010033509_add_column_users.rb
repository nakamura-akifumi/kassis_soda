class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :personid, :string
    add_column :users, :cardid, :string
    add_column :users, :full_name, :string
    add_column :users, :full_name_transcription, :string
    add_column :users, :expired_at, :datetime
    add_column :users, :registration_date, :date
    add_column :users, :note, :text
    add_column :users, :number_of_reminder, :integer
    add_column :users, :deactive, :boolean, null: false, default: false
    add_column :users, :deactive_at, :datetime

    add_index :users, :personid, unique: true
    add_index :users, :cardid
    add_index :users, :deactive

  end

end
