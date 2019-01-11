class CreateKassisFileAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :kassis_file_attachments do |t|
      t.string :msgid
      t.string :fileid
      t.string :filename
      t.bigint :byte_size
      t.string :checksum

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [ :msgid, :fileid ]
    end
  end
end
