require File.expand_path('../../../mailman-rails', __FILE__)
require 'daemons'


namespace :mailman do

  mailman_tasks = [:start, :stop, :restart, :status]

  mailman_tasks.each do |task_name|

    # Generate description
    if task_name == :status
      desc "Check the status of the Mailman service"
    else
      desc "#{task_name.to_s.camelize} the Mailman service"
    end

    task task_name do
      Daemons.run_proc(Mailman::Rails.daemon_name, :ARGV => [task_name.to_s], :dir => "tmp/pids", :dir_mode => :normal) do
        # TODO - Can't configure Daemons to output the logfiles to any other dir than the pidfile dir
        # Daemons has the brilliant idea of assuming your pidfile dir is your working dir is your logfile dir
        # :log_output => true # logs STDOUT and STDERR to a file in the pidfile dir.
        # Use :log_output if you want to debug the daemon itself. We're going to take matters into our own hands:
        $stderr.reopen("#{Rails.root}/log/#{Mailman::Rails.daemon_name}.stdout.log", "w")
        $stdout.reopen("#{Rails.root}/log/#{Mailman::Rails.daemon_name}.stderr.log", "w")
        warn "Foo"
        puts "Bar"
        chdir "#{Rails.root}"
        puts "Running daemon command!"
        Rake::Task["mailman"].invoke
      end
    end

  end

end


desc "Mailman service in the foreground"
task :mailman => :environment do

  Mailman.config.logger = Logger.new("#{Rails.root}/log/mailman.#{Rails.env}.log")

  Mailman::Rails.run!

end

