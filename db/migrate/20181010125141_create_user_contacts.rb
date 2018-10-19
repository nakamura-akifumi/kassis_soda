class CreateUserContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_contacts do |t|
      t.references :user
      t.string :contact_detail
      t.integer :contact_type
      t.string :contact_sub
      t.text :contact_note
    end

  end

end
