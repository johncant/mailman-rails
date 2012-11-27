require 'rails'

module Mailman
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        Dir[File.expand_path('../tasks/*.rake', __FILE__)].each { |f| puts f ; load f }
      end
    end
  end
end
