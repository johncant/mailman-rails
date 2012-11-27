module Mailman
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
