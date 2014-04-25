class CreateArtworks < ActiveRecord::Migration
  def change
    create_table :artworks do |t|
      t.string :name
      t.string :artist_name
      t.string :artwork_id

      t.timestamps
    end
  end
end
