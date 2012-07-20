maintainer       'Danial Pearce'
maintainer_email 'danial@tigris.id.au'
license          'MIT'
description      'Creates a init.d scripts for your unicorns.'
version          '0.1'
recipe           'unicorn', 'Creates a init.d scripts for your unicorns.'
supports         'ubuntu'

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

attribute 'unicorn/config',
  :description => 'The file path for the unicorn config.',
  :type        => 'string',
  :default     => '#{unicorn::app_root}/config/unicorn.rb'

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
