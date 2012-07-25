node['unicorn']['installs'].each do |install|
  # Make sure the install defaults come across for each unicorn install
  install['config'] ||= {}
  %w(rack_env user group pid service command).each do |k|
    install[k] ||= node['unicorn'][k]
  end
  %w(generate path stderr_path stdout_path listen working_directory worker_timeout preload_app worker_processes before_exec before_fork after_fork).each do |k|
    install['config'][k] ||= node['unicorn']['config'][k]
  end

  # installure defaults, tricky since some defaults are dependant on others and we have interpolation!
  parsed_pid         = install['pid']    .is_a?(Proc) ? install['pid']    .call(install['app_root']) : install['pid']
  parsed_service     = install['service'].is_a?(Proc) ? install['service'].call(install['rack_env']) : install['service']
  parsed_config      = install['config']['path']       .is_a?(Proc) ? install['config']['path']       .call(install['app_root']) : install['config']['path']
  parsed_stdout_path = install['config']['stdout_path'].is_a?(Proc) ? install['config']['stdout_path'].call(install['app_root']) : install['config']['stdout_path']
  parsed_stderr_path = install['config']['stderr_path'].is_a?(Proc) ? install['config']['stderr_path'].call(install['app_root']) : install['config']['stderr_path']
  parsed_command     = install['command'].is_a?(Proc) ? install['command'].call(install['app_root'], install['rack_env'], parsed_config) : install['command']

  # Setup the boot time flags
  bash "update-rc.d #{parsed_service} defaults" do
    user 'root'
    code "update-rc.d #{parsed_service} defaults"
    action :nothing
  end

  # Create the init.d script
  template "/etc/init.d/#{parsed_service}" do
    source 'unicorn.erb'
    variables(
      :root    => install['app_root'],
      :env     => install['rack_env'],
      :user    => install['user'],
      :pid     => parsed_pid,
      :command => parsed_command
    )
    mode '775'
    notifies :run, resources(:bash => "update-rc.d #{parsed_service} defaults")
  end

  # Setup the chef service
  service parsed_service do
    supports [:start, :restart, :reload, :stop, :status]
    action :enable
  end

  # Create the install if necessary
  template parsed_config do
    only_if   { install['config']['generate'] }
    source    'config.rb.erb'
    user      install['user']
    group     install['group']
    variables(
      :identifier        => parsed_service,
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
      :pid               => parsed_pid,
      :stderr_path       => parsed_stderr_path,
      :stdout_path       => parsed_stdout_path
    )
    mode '755'
    notifies :restart, resources(:service => parsed_service), :delayed
  end

  service parsed_service do
    action :start
  end
end
