require 'mail'

module Mailman
  module Rails

    module TestSupport

      # Prepare ruby Maildir to insert messages
      def setup_maildir
        clean_maildir
        @@maildir = Maildir.new(Mailman.config.maildir)
      end

      # Delete all messages in the maildir
      def clean_maildir
        FileUtils.rm_rf "#{Mailman.config.maildir}/*/*" if File.exists? Mailman.config.maildir
      end

      # Fake an email. Pass in a Mail object or Mail object constructor args
      def send_email_to_maildir(mail_or_hash)

        if mail_or_hash.is_a? Hash
          mail_or_hash = Mail.new(mail_or_hash)
        end

        # Now we have a mail object.

        @@maildir.serializer = Maildir::Serializer::Mail.new
        @@maildir.add(mail_or_hash)
      end

    end

  end
end
