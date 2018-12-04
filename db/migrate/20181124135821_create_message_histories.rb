class CreateMessageHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :message_histories do |t|
      t.string :msgid
      t.string :row
      t.string :message_type
      t.string :status
      t.text :note
      t.text :note2

      t.timestamps
    end

    add_index :message_histories, [:msgid, :row]

  end
end
