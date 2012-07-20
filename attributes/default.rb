default['unicorn']['rack_env'] = 'production'
default['unicorn']['user']     = 'root'
default['unicorn']['pid']      = Proc.new{|root| "#{root}/tmp/pids/unicorn.pid" }
default['unicorn']['config']   = Proc.new{|root| "#{root}/config/unicorn.rb" }
default['unicorn']['service']  = Proc.new{|env| "unicorn-#{env}" }
default['unicorn']['command']  = Proc.new{|root, env, config| "cd #{root} && bundle exec unicorn_rails -D -E #{env} -c #{config}" }
