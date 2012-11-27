require "rubygems"
require 'mailman'
require "mailman-rails"
require "mailman-rails/version"
#require "mailman-rails/railtie"
#require File.expand_path("../mailman", __FILE__)

module Mailman
  module Rails
    require 'mailman-rails/railtie'

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

