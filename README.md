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
You need to set the following 2 variables at a minimum. Your "installs" array can be either just 1 unicorn, or a bunch of unicorns
all with different app_root settings.

* **['installs']** _(no default, required attribute!)_ - An array of hashes for your unicorn installs.
* **['installs'][n]['app\_root']** _(no default, required attribute!)_ - The root of your unicorn app.

The list of attributes available per install and their defaults are listed below. If you want to override the default, then
you can set node['unicorn'][$KEY] and have that as your default for all your unicorns, or you can override it in your installs
hash directly.

* **['rack\_env']** _(default: `production`)_ - The rack env to be passed to unicorn.
* **['pid']** _(default: `$APP_ROOT/tmp/pids/unicorn.pid`)_ - The file path for the unicorn pid.
* **['config']** _(default: `$APP_ROOT/config/unicorn.rb`)_ - The file path for the unicorn config.
* **['service']** _(default: `unicorn-$RACK_ENV`)_ - The identifier for this unicorn.
* **['command']** _(default: `cd $APP_ROOT && bundle exec unicorn_rails -D -E $RACK_ENV -c $CONFIG`)_ - The command used to start unicorn.
* **['user']** _(default: `root`)_ - The user to run unicorn as, this user will also own the config file.
* **['group']** _(default: `root`)_ - The group to run unicorn as, this group will also own the config file.

Then there are the attributes specific to creating the config file. By default unicorn will generate your config in `config/unicorn.rb` relative
from your app_root. You can turn off config generation if you already store your config in your repo yourself. I used to do it this way, but
personally I got sick of re-using the unicorn pid path and port numbers everywhere so prefer to set them in my node.js file once and have chef
generate the rest of the configs from there.

* **['config']['generate']** _(default: `true`)_ - Should chef generate your config?
* **['config']['path']** _(default: `$APP_ROOT/config/unicorn.rb`)_ - The path to where the generated config will go.
* **['config']['listen']** _(default: `[['3000', '{ :tcp_nodelay => true, :tries => 5 }']]`)_ - An array of listeners. Each listener is itself an array where the first element is a port or socket path and the second optional element is a hash of options for that listener (see unicorn docs).
* **['config']['stderr\_path']** _(default: `$APP_ROOT/log/unicorn.log`)_ - The path for the unicorn error log.
* **['config']['stdout\_path']** _(default: `$APP_ROOT/log/unicorn.log`)_ - The path for the unicorn error log.
* **['config']['working\_directory']** _(default: `nil`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['worker\_timeout']** _(default: `60`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['preload\_app']** _(default: `false`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['worker\_processes']** _(default: `1`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['before\_exec']** _(default: `nil`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['before\_fork']** _(default: `nil`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.
* **['config']['after\_fork']** _(default: `nil`)_ - Please see the unicorn configurator docs for a detailed explanation of this option.

# Examples #

If you have more than 1 unicorn, let's say maybe your production environment and a staging
environment, then you could do this in your node.json and you will have a unicorn-production service
as well as a unicorn-staging service.

    "unicorn": {
      "installs": [
        { "app_root": "/home/john/myapp" },
        { "app_root": "/home/john/myapp-staging", "rack_env": "staging" }
      ]
    }

Or maybe you just want to set up unicorn on your development server. That's how I roll!

    "unicorn": {
      "installs": [ { "app_root": "/home/frank/projects/app", "rack_env": "development" } ]
    }

Another example, you might be setting your unicorn config based on some template in your own recipes. You have access
to the unicorn service(s) using the identifiers.

    node["unicorn"]["installs"] = [{ "app_root" => "/home/bob/myapp" }]
    node["unicorn"]["config"]["generate"] = false
    include_recipe "unicorn"
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

# Changelog #

## 0.2 ##

 * Add support for config generation

## 0.1 ##

 * Initial commit
