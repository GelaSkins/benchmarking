require 'net/http'
require_relative '../timer'
require 'csv'

class WrapAllDevices
  attr_reader :wrap_size, :artwork

  def run(wrap_size, artwork_id, csv_path)
    @wrap_size = wrap_size || 'normal'
    @artwork = find_artwork artwork_id
    csv_path  = csv_path || Dir.pwd
    times = []

    devices.each do |device|
      resp = Timer.time { curl_wrap device }
      time = Timer.elapsedTime
      times << [device, time, artwork, resp]
    end

    CSV.open(File.join(csv_path, 'server_wrap_times.csv'), 'wb') do |csv|
      csv << ['Device id','Device name','Time elapsed','Artwork', 'Http response']
      times.each do |row|
        csv << %W(#{row.first.device_id}
                   #{row.first.name}
                   #{row[1]}
                   #{row[2].name}
                   #{row.last.code}
                )
      end
    end
  end

  def curl_wrap(device)
    uri = URI(URI.escape(make_server_url(device)))
    Net::HTTP.get_response uri
  end

  def make_server_url(device)
    %W(#{Settings.image_server_url}
        public_wraps
        iphone
        #{artwork.artist_name}
        #{artwork.artwork_id}
        #{device.device_id}
        #{wrap_size}
        benchmark.jpg
      ).join('/')
  end

  def devices
    Device.all
  end

  def find_artwork(id)
    if id
      Artwork.find_by_artwork_id id
    else
      Artwork.find_by_name 'tokidoki All Stars'
    end
  end
end

