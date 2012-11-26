# Mailman::Rails

This gem helps you integrate <a href="https://github.com/titanous/mailman">ruby Mailman</a> with Rails. It adds rake tasks to manage a mailman daemon and allows you to configure a Mailman::Application instance from within your models.

## Installation

Add this line to your application's Gemfile:

    gem 'mailman-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mailman-rails

## Usage

Put your Mailman config in config/initializers/mailman.rb

Match Mailman stuff from your models:
<pre>
class Post < ActiveRecord::Base # Or whatever

  Mailman::Rails.receive do
    to "posts@example.com" do
      Post.create(JSON.parse(message.body))
    end
  end

  # The daemon would be started from the rake task but only after all the code is loaded.

end
</pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
