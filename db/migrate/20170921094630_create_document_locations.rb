class CreateDocumentLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :document_locations do |t|
      t.string :s3_location
      t.string :account_id

      t.timestamps
    end
    # add_foreign_key :document_locations, 'sf.accountx', column: :account_id
  end
end
