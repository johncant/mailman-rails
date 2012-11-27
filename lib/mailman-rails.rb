require "mailman-rails/version"
Gem.send :require, "mailman" # Force loading of the Gem, not my file
require 'mailman'
require "mailman/rails"
require "mailman/rails/railtie"
require File.expand_path("../mailman", __FILE__)

module Mailman
  module Rails
    # Railtie added further down the tree
  end
end
