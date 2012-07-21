default['unicorn']['installs'] = []
default['unicorn']['rack_env'] = 'production'
default['unicorn']['user']     = 'root'
default['unicorn']['group']    = 'root'
default['unicorn']['pid']      = Proc.new{|root| "#{root}/tmp/pids/unicorn.pid" }
default['unicorn']['service']  = Proc.new{|env| "unicorn-#{env}" }
default['unicorn']['command']  = Proc.new{|root, env, config| "cd #{root} && bundle exec unicorn_rails -D -E #{env} -c #{config}" }

default['unicorn']['config']['generate']          = true
default['unicorn']['config']['path']              = Proc.new{|root| "#{root}/config/unicorn.rb" }
default['unicorn']['config']['stderr_path']       = Proc.new{|root| "#{root}/log/unicorn.log"   }
default['unicorn']['config']['stdout_path']       = Proc.new{|root| "#{root}/log/unicorn.log"   }
default['unicorn']['config']['listen']            = [['3000', '{ :tcp_nodelay => true, :tries => 5 }']]
default['unicorn']['config']['working_directory'] = nil
default['unicorn']['config']['worker_timeout']    = 60
default['unicorn']['config']['preload_app']       = false
default['unicorn']['config']['worker_processes']  = 1
default['unicorn']['config']['before_exec']       = nil
default['unicorn']['config']['before_fork']       = nil
default['unicorn']['config']['after_fork']        = nil
