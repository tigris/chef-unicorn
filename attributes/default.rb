default['unicorn']['installs'] = []

default['unicorn']['config']['generate']          = true
default['unicorn']['config']['path']              = "#{node['unicorn']['app_root']}/config/unicorn.rb"
default['unicorn']['config']['stderr_path']       = "#{node['unicorn']['app_root']}/log/unicorn.log"
default['unicorn']['config']['stdout_path']       = "#{node['unicorn']['app_root']}/log/unicorn.log"
default['unicorn']['config']['listen']            = [['3000', '{ :tcp_nodelay => true, :tries => 5 }']]
default['unicorn']['config']['working_directory'] = nil
default['unicorn']['config']['worker_timeout']    = 60
default['unicorn']['config']['preload_app']       = false
default['unicorn']['config']['worker_processes']  = 1
default['unicorn']['config']['before_exec']       = nil
default['unicorn']['config']['before_fork']       = nil
default['unicorn']['config']['after_fork']        = nil

default['unicorn']['rack_env'] = 'production'
default['unicorn']['user']     = 'root'
default['unicorn']['group']    = 'root'
default['unicorn']['pid']      = "#{node['unicorn']['app_root']}/tmp/pids/unicorn.pid"
default['unicorn']['service']  = "unicorn-#{node['unicorn']['rack_env']}"
default['unicorn']['command']  = "cd #{node['unicorn']['app_root']} && bundle exec unicorn_rails -D -E #{node['unicorn']['rack_env']} -c #{node['unicorn']['config']['path']}"
