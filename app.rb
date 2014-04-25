require_relative 'init'

class App
  def self.load_tasks!
    Dir[(File.expand_path(File.dirname(__FILE__)) + '/lib/tasks/*')].each { |f| load f }
  end
end