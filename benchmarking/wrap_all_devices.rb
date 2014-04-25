require 'net/http'
require_relative '../timer'
require 'csv'

class WrapAllDevices
  def run(wrap_size, artwork_id, csv_path)
    wrap_size = wrap_size || 'normal'
    csv_path  = csv_path  || Dir.pwd
    times = []
    art = artwork(artwork_id)
    devices.each do |device|
      resp = Timer.time { for_artwork(device, art, wrap_size) }
      time = Timer.elapsedTime
      times << [device, time, art, resp]
    end

    CSV.open(File.join(csv_path, 'server_wrap_times.csv'), 'wb') do |csv|
      csv << ['Device id','Device name','Time elapsed','Artwork', 'Http response']
      times.each do |row|
        csv << %W(#{row.first.id} #{row.first.name} #{row[1]} #{row[2].name}, #{row.last.code})
      end
    end
  end

  def for_artwork(device, artwork, size)
    uri = URI("#{Settings.image_server_url}/public_wraps/iphone/#{artwork.artist_name}/#{artwork.artwork_id}/#{device.device_id}/#{size}/benchmark.jpg")
    Net::HTTP.get_response uri
  end

  def devices
    Device.all
  end

  def artwork(id)
    if id
      Artwork.find id
    else
      Artwork.find_by_name 'tokidoki All Stars'
    end
  end
end

