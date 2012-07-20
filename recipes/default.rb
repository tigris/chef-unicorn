# Force array of pretty pink unicorns!
configs = node['unicorn'].is_a?(Array) ? node['unicorn'] : [node['unicorn']]

configs.each do |config|
  # Make sure the config defaults come across for each unicorn instance
  %w(rack_env user pid config service command).each do |k|
    config[k] ||= node.default['unicorn'][k]
  end

  # Configure defaults, tricky since some defaults are dependant on others and we have interpolation!
  parsed_pid     = config['pid']    .is_a?(Proc) ? config['pid']    .call(config['app_root']) : config['pid']
  parsed_config  = config['config'] .is_a?(Proc) ? config['config'] .call(config['app_root']) : config['config']
  parsed_service = config['service'].is_a?(Proc) ? config['service'].call(config['rack_env']) : config['service']
  parsed_command = config['command'].is_a?(Proc) ? config['command'].call(config['app_root'], config['rack_env'], parsed_config) : config['command']

  # Create the init.d script
  template "/etc/init.d/#{parsed_service}" do
    source 'unicorn.erb'
    variables(
      :root    => config['app_root'],
      :env     => config['rack_env'],
      :user    => config['user'],
      :pid     => parsed_pid,
      :command => parsed_command
    )
    mode '775'
  end

  # Setup the boot time flags
  bash "update-rc.d #{parsed_service} defaults" do
    user 'root'
    code "update-rc.d #{parsed_service} defaults"
  end

  # Setup the chef service
  service parsed_service do
    enabled true
    supports [:start, :restart, :reload, :stop, :status]
  end
end
