json.extract! file_adapter, :id, :title, :created_by, :created_at, :updated_at
json.url file_adapter_url(file_adapter, format: :json)
