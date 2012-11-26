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

  def self.start!
    self.application.run
  end
end
