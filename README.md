# Mailman::Rails

This gem helps you integrate <a href="https://github.com/titanous/mailman">ruby Mailman</a> with Rails. It adds rake tasks to manage a mailman daemon and allows you to configure a Mailman::Application instance from within your models.

## Installation

Add this line to your application's Gemfile:

    gem 'mailman-rails'

And maybe one of these lines depending on status of pull requests, versions etc:

    gem 'mailman', :git => 'https://github.com/johncant/mailman'
    gem 'mailman', :git => 'https://github.com/titanous/mailman'
    gem 'mailman'

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install mailman-rails

## Usage

Put your Mailman config in config/initializers/mailman.rb

Match Mailman stuff from your models:
```
class Post < ActiveRecord::Base # Or whatever

  Mailman::Rails.receive do
    to "posts@example.com" do
      Post.create(JSON.parse(message.body))
    end
  end

  # The daemon would be started from the rake task but only after all the code is loaded. You need to enable cache\_classes or something to take advantage of this.

end
```

Rake tasks
```
rake mailman              # Start Mailman service in foreground
rake mailman:start        # Start Mailman service in background
rake mailman:stop         # Stop Mailman service
rake mailman:restart      # Restart Mailman service in background
rake mailman:status       # Check Mailman service status
```

## Testing with Test::Unit

Please see the RSpec section - the helpers contain no RSpec specific code.

## Testing with Cucumber

In features/support/mailman.rb
```
World(Mailman::Rails::TestSupport)
```

Please see the RSpec section - the helpers contain no RSpec specific code.

## Testing with RSpec

You can test your Mailman integration using this gem. Since Mailman::Rails::TestSupport is not specific to any testing framework, you can use it where you like!

In spec/spec\_helper.rb:
```
# Existing RSpec.configure block:
RSpec.configure do |config|

  include Mailman::Rails::TestSupport # Add this line

end
```

In your spec:
```
RSpec.describe "Mailman Maildir integration" do

  before(:each) do
    setup_maildir # This sets up a maildir in the place that Mailman wil read from
  end

  after(:each) do
    clean_maildir # This cleans all messages from the maildir that Mailman will read from
  end

  before(:all) do
    Mailman::Rails.start # Start the Mailman service
  end

  after(:all) do
    Mailman::Rails.stop # Stop the Mailman service
  end

  it "should receive emails from a Maildir" do

    # Imagine the service modifies the database or replies

    send_email_to_maildir(pass_me_a_Mail_object_or_a_hash_for_the_Mail_constructor) # This writes the email to the maildir

    # Wait for the email to be received
    # Check that the database was modified or a reply was sent

  end

end
```

## Limitations

Mailman::Rails.start/stop use the command line to spawn Mailman rather than start it in a new thread ATM. That means that ActionMailer::Base.deliveries won't be shared, there is no waiting for Mailman to start, and the test is slow because the your code gets loaded again during the test.

No Test::Unit, RSpec, or Cucumber specific test support.

Hopefully we can get these fixed soon!

## Suggested use

You only need one unit test or spec per Mailman matcher to prove that Mailman is receiving the messages and that your matchers are working. You then only really need this in integration tests. Make sure you only start the service once, or you'll be waiting for weeks for your tests/specs/scenarios to run!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
