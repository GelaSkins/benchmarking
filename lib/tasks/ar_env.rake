namespace :ar do
  task :connect do
    DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'
    ActiveRecord::Base.establish_connection YAML.load_file(File.join(Dir.pwd,'config/database.yml'))[DATABASE_ENV]
  end
end
