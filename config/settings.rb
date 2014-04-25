class Settings
  class << self
    @config = YAML.load_file(File.join(Dir.pwd,'config/settings.yml'))
    @config.each do |k,v|
      define_method k do
        v
      end
    end
  end
end