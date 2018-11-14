class CreateMessageAdapters < ActiveRecord::Migration[5.2]
  def change
    create_table :message_adapters do |t|
      t.string :msgid, null: false
      t.string :title
      t.string :status
      t.string :state
      t.string :message_type
      t.integer :created_by, null: false

      t.timestamps
    end

    add_index :message_adapters, :msgid, unique: true

  end
end
