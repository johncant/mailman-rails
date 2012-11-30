require "rubygems"
require 'mailman'
require "mailman-rails"
require "mailman-rails/test_support"
require "mailman-rails/version"
#require "mailman-rails/railtie"
#require File.expand_path("../mailman", __FILE__)

module Mailman
  module Rails
    require 'mailman-rails/railtie'

    # Start/stop Mailman::Rails. This method might only be useful during tests. In a later version, this might be threaded to reduce overheads during testing
    def self.start
      `cd #{::Rails.root} && env RAILS_ENV=test bundle exec rake mailman:start`
    end

    def self.stop
      `cd #{::Rails.root} && env RAILS_ENV=test bundle exec rake mailman:stop`
    end

    # Store one instance of Mailman::Application. We only need one!
    @@application = nil

    def self.application
      @@application ||= Mailman::Application.new do end # Avoid forcing Mailman to require a block
    end

    def self.configure(&block)
      Mailman.config.instance_exec(&block)
    end

    def self.receive(&block)
      self.application.instance_exec(&block)
    end

    def self.run!

      # Under no circumstances should Mailman itself load the Rails enviroment!
      Mailman.config.rails_root = false

      self.application.run
    end

  end
end

