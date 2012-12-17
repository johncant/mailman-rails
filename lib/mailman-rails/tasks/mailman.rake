require File.expand_path('../../../mailman-rails', __FILE__)



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
      Daemons.run_proc("mailman_daemon", :ARGV => [task_name.to_s], :dir => "tmp/pids", :dir_mode => :normal) do
        # TODO - Can't configure Daemons to output the logfiles to any other dir than the pidfile dir
        # Daemons has the brilliant idea of assuming your pidfile dir is your working dir is your logfile dir
        # :log_output => true # logs STDOUT and STDERR to a file in the pidfile dir.
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

