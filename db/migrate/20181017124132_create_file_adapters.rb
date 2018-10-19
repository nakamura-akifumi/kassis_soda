class CreateFileAdapters < ActiveRecord::Migration[5.2]
  def change
    create_table :file_adapters do |t|
      t.string :title
      t.integer :created_by

      t.timestamps
    end
  end
end
