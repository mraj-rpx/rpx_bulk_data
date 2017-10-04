class CreateRequestLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :request_logs do |t|
      t.integer :user_id, index: true
      t.string :s3_key
      t.string :request_method
      t.string :remote_addr
      t.string :http_host
      t.string :http_authentication
      t.string :http_user_agent
      t.string :request_uri
      t.string :http_version
      t.text :query_string

      t.timestamps
    end
    add_foreign_key :request_logs, :users
  end
end
