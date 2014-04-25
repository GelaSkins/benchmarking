desc 'Benchmarks wrap generation againts all devices'
desc 'default artwork is tokidoki All Stars'
desc 'outputs the csv file server_wrap_times.csv in the current_directory or to a path'
namespace :benchmarking do
  task :wrap_all_devices, [:wrap_size, :artwork_id, :csv_path] do |t, args|
    Rake::Task['ar:connect'].invoke
    WrapAllDevices.new.run(args[:wrap_size], args[:artwork_id], args[:csv_path])
  end
end
