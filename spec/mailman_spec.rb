require 'spec_helper'

# WARNING - Requires mailman version from GitHub to run the tests

describe Mailman do

  def gem_root
    File.expand_path('../../', __FILE__)
  end

  before do
    `cp -r #{gem_root}/examples #{gem_root}/tmp/examples`
  end

  it "Should store one instance configurable from different places" do

    # Imagine that these next two blocks are in separate Rails models
    # This spec reports that only 1 spec has been executed, despite my best efforts. (See hackery below)
    # It's not true though, if one of the "ghost" specs fails, you still notice.
    spec = self

    Mailman::Rails.configure do
      self.maildir = "#{spec.gem_root}/tmp/examples/"
    end

    emails_parsed = 0

    Mailman::Rails.receive do
      to('email1@example') do
        route = self
        spec.instance_eval do
          # Tried making sure that self refers to the spec
          route.message.body.should match(/Foo/)
          emails_parsed += 1
        end
      end
    end

    Mailman::Rails.receive do
      to('email2@example') do
        route = self
        spec.instance_eval do
          # Tried making sure that self refers to the spec
          route.message.body.should spec.match(/Bar/)
          emails_parsed += 1
        end
      end
    end

    Mailman::Rails.application.process_maildir # If this had already happened, the spec would fail

    emails_parsed.should == 2

  end

  after do
    `rm -r #{gem_root}/tmp/examples`
  end
end
