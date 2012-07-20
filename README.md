# Overview #
Chef cookbook for the [unicorn](https://github.com/blog/517-unicorn) rack server.

At the moment this simply puts an init.d script in /etc/ for you so your unicorn(s) will come
up on boot. It also sets up a chef service so you can interact with it in your chef recipes.

I am planning on having this generate your unicorn config as well, but is not a priority at the moment.

# Requirements #
Currently I have only tested this on ubuntu. I'm sure it will work on debian as well. RedHat
I am not so sure.

Getting the unicorn gem into your application is up to you. This script assumes you already have the gem in your app root,
but is configurable enough that you may have installed unicorn somewhere else, e.g. maybe you installed it system wide.

# Attributes #
The list of attributes available are listed below. The only required attribute is the app_root.
Defaults are listed as well. If you require more than 1 unicorn script (e.g. you have more than
1 app), then simply set node['unicorn'] to an array of these hashes.

* **node['unicorn']['app\_root']** _(no default, required attribute!)_ - 'The root of your unicorn app.
* **node['unicorn']['rack\_env']** _(default: `production`)_ - The rack env to be passed to unicorn.
* **node['unicorn']['pid']** _(default: `$APP_ROOT/tmp/pids/unicorn.pid`)_ - The file path for the unicorn pid.
* **node['unicorn']['config']** _(default: `$APP_ROOT/config/unicorn.rb`)_ - The file path for the unicorn config.
* **node['unicorn']['service']** _(default: `unicorn-$RACK_ENV`)_ - The identifier for this unicorn.
* **node['unicorn']['command']** _(default: `cd $APP_ROOT && bundle exec unicorn_rails -D -E $RACK_ENV -c $CONFIG`)_ - The command used to start unicorn.
* **node['unicorn']['user']** _(default: `root`)_ - The user to start the master unicorn as.

# Examples #

Say for example, you might be setting your unicorn config based on some template in your own recipes. You have access
to the unicorn service(s) using the identifiers.

    template "/home/bob/myapp/config/unicorn.rb" do
      source "/home/bob/myapp/config/unicorn.rb.erb"
      variables :foo => 'bar'
      mode "775"
      notifies :reload, resources(:service => 'unicorn-production'), :delayed
    end

Which is pretty handy since chef is smart enough to know when the template changes or not, so it won't
reload your unicorns if the config doesn't change.

However, if you wanted to restart your unicorn anyway, perhaps you have precompiled assets
that mean unicorn needs reloading every deploy. Simply add this to your deploy recipe somewhere.

    service 'unicorn-production' do
      action :restart
    end

Lastly, if you have more than 1 unicorn, let's say maybe your production environment and a staging
environment, then you could do this in your node.json and you will have a unicorn-production service
as well as a unicorn-staging service.

    "unicorn": [
      { "app_root": "/home/john/myapp" },
      { "app_root": "/home/john/myapp-staging", "rack_env": "staging" }
    ]

Or maybe you just want to set up unicorn on your development server. That's how I roll!

    "unicorn": { "app_root": "/home/frank/projects/app", "rack_env": "development" }

# Changelog #
## 0.1 - 2012-07-20 ##
 * Initial commit
