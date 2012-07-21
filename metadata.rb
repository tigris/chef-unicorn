maintainer       'Danial Pearce'
maintainer_email 'danial@tigris.id.au'
license          'MIT'
description      'Creates a init.d scripts for your unicorns.'
version          '0.2'
recipe           'unicorn', 'Creates a init.d scripts and configs for your unicorns.'
supports         'ubuntu'

attribute 'unicorn/installs',
  :description => 'An array of your unicorn installs.',
  :type        => 'array'

attribute 'unicorn/app_root',
  :description => 'The root of your unicorn app.',
  :type        => 'string'

attribute 'unicorn/rack_env',
  :description => 'The rack env to be passed to unicorn.',
  :type        => 'string',
  :default     => 'production'

attribute 'unicorn/pid',
  :description => 'The file path for the unicorn pid.',
  :type        => 'string',
  :default     => '#{unicorn::app_root}/tmp/pids/unicorn.pid'

attribute 'unicorn/service',
  :description => 'The identifier for this service.',
  :type        => 'string',
  :default     => 'unicorn-#{unicorn::rack_env}'

attribute 'unicorn/command',
  :description => 'The command used to start unicorn.',
  :type        => 'string',
  :default     => 'cd #{unicorn::app_root} && bundle exec unicorn_rails -D -E #{unicorn::rack_env} -c #{unicorn::config}'

attribute 'unicorn/user',
  :description => 'The user to start the master unicorn as.',
  :type        => 'string',
  :default     => 'root'

attribute 'unicorn/config',
  :description => 'Hash of config attributes.',
  :type        => 'hash'

attribute 'unicorn/config/path',
  :description => 'The file path for the unicorn config.',
  :type        => 'string',
  :default     => '#{unicorn::app_root}/config/unicorn.rb'

attribute 'unicorn/config/stderr_path',
  :description => 'Where stderr goes for unicorn.',
  :type        => 'string',
  :default     => '#{unicorn::app_root}/log/unicorn.log'

attribute 'unicorn/config/stdout_path',
  :description => 'Where stdout goes for unicorn.',
  :type        => 'string',
  :default     => '#{unicorn::app_root}/log/unicorn.log'

attribute 'unicorn/config/listen',
  :description => 'An array of ways unicorn will listen. First element is the port or socket, second element is the options for that listener (optional).',
  :type        => 'array',
  :default     => [['3000', '{ :tcp_nodelay => true, :tries => 5 }']]

attribute 'unicorn/config/working_directory',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => nil

attribute 'unicorn/config/worker_timeout',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => '60'

attribute 'unicorn/config/preload_app',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => 'false'

attribute 'unicorn/config/worker_processes',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => '1'

attribute 'unicorn/config/before_exec',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => nil

attribute 'unicorn/config/before_fork',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => nil

attribute 'unicorn/config/after_fork',
  :description => 'Please see the unicorn documentation for a description of this setting.',
  :type        => 'string',
  :default     => nil
