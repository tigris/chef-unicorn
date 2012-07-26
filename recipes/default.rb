node['unicorn']['installs'].each do |install|

  # Since a lot of defaults rely on app_root, set it and reload defeaults
  node.set['unicorn']['app_root'] = install['app_root']
  node.load_attribute_by_short_filename('default', 'unicorn')

  # Apply the defaults for each unicorn install
  install['config'] ||= {}
  %w(rack_env user group pid service command).each do |k|
    install[k] ||= node['unicorn'][k]
  end
  %w(generate path stderr_path stdout_path listen working_directory worker_timeout preload_app worker_processes before_exec before_fork after_fork).each do |k|
    install['config'][k] ||= node['unicorn']['config'][k]
  end

  # Create the init.d script
  template "/etc/init.d/#{install['service']}" do
    source 'unicorn.erb'
    variables(
      :root    => install['app_root'],
      :env     => install['rack_env'],
      :user    => install['user'],
      :pid     => install['pid'],
      :command => install['command']
    )
    mode '775'
  end

  # Setup the service to run at boot. We can't start it yet cos no config,
  # but we need to enable it so the config can notify the restarter.
  service install['service'] do
    supports [:start, :restart, :reload, :stop, :status]
    action :enable
  end

  # Create the install if necessary
  template install['config']['path'] do
    only_if   { install['config']['generate'] }
    source    'config.rb.erb'
    user      install['user']
    group     install['group']
    variables(
      :identifier        => install['service'],
      :listen            => install['config']['listen'],
      :user              => install['user'],
      :group             => install['group'],
      :working_directory => install['config']['working_directory'],
      :worker_timeout    => install['config']['worker_timeout'],
      :preload_app       => install['config']['preload_app'],
      :worker_processes  => install['config']['worker_processes'],
      :before_exec       => install['config']['before_exec'],
      :before_fork       => install['config']['before_fork'],
      :after_fork        => install['config']['after_fork'],
      :pid               => install['pid'],
      :stderr_path       => install['config']['stderr_path'],
      :stdout_path       => install['config']['stdout_path']
    )
    mode '755'
    notifies :restart, resources(:service => install['service']), :delayed
  end

  # Start 'er up.
  service install['service'] do
    action :start
  end
end
