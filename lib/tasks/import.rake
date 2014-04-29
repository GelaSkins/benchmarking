desc 'Imports all devices and artworks from rails db'
task :import do
  client = Mysql2::Client.new(host: Settings.store_host,
                              username: Settings.store_username,
                              database: Settings.store_db)


  devices = client.query(<<-SQL)
     SELECT id, presentation AS name
      FROM spree_option_values
      WHERE production_name IS NOT NULL
      AND deleted_at IS NULL
      AND parent_id = 0
      AND id <> 131
      AND is_archived = 0
      AND is_virtual = 0
  SQL

  works = client.query(<<-SQL)
    SELECT a.id AS artwork_id, a.name AS name,
           u.name AS artist_name
    FROM spree_products a
    LEFT JOIN spree_users u ON a.user_id = u.id
    WHERE a.is_gift_card = 0
    AND a.custom = 0
    AND a.deleted_at IS NULL
  SQL


  Rake::Task['ar:connect'].invoke
  Device.delete_all
  Artwork.delete_all

  devices.each do |device|
    Device.create!(name: device['name'], device_id: device['id'])
  end

  works.each do |work|
    Artwork.create!(name: work['name'],
                    artist_name: work['artist_name'],
                    artwork_id: work['artwork_id'])
  end
end
