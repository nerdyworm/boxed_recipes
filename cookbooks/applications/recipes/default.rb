include_recipe "unicorn"

node[:apps].each do |app|

  app_path = "/data/apps/#{app[:name]}" 
  git_path = "/data/git/#{app[:name]}.git"
  sock     = "/data/sockets/#{app[:name]}.sock"

  app_directories = [
    "/data/sockets/",
    "/data/logs",
    "/data/logs/#{app[:name]}",
    "/data/pids",
    "/data/git/",
    git_path,
    "#{app_path}",
    "#{app_path}/shared",
    "#{app_path}/shared/config",
    "#{app_path}/shared/system",
    "#{app_path}/releases" 
  ]

  app_directories.each do |dir|
    directory dir do
      owner node[:app_user]
      group node[:app_user]
      mode 0755
      recursive true
    end
  end
  
  bash "creating deploy git #{app[:name]}" do
    user node[:app_user]
    code "cd #{git_path} &&  git init --bare"
  end


  # This is so that the app user can install
  # gems with bundler with out have to use
  # sudo or rvmsudo etc...
  #
  bash "changing perms of rvm to user" do
    user "root"
    code "chown -R ubuntu:ubuntu /usr/local/rvm"
  end

  ruby_ver = "ruby-1.9.2-p180"
  ruby_str = "#{ruby_ver}@#{app[:name]}"

  rvm_gemset app[:name] do
    ruby_string ruby_ver
    action :create
  end

  rvm_gem "bundler" do
    ruby_string ruby_str
  end

  rvm_gem "unicorn" do
    ruby_string ruby_str
  end

  rvm_wrapper app[:name] do
    ruby_string ruby_str
    binary "unicorn_rails"
  end

  template "/etc/nginx/sites-available/#{app[:name]}" do
    owner node[:app_user]
    mode 0644
    source "nginxsite.conf.erb"
    variables(
      :name       => app[:name],
      :servername => app[:servername],
      :sock       => sock,
      :root       => "/#{app_path}/current/public"
    )
  end

  bash "enabling nginx site #{app[:name]}" do
    user "root" 
    code "/usr/sbin/nxensite #{app[:name]}"
  end

  unicorn_file = "#{app_path}/shared/config/unicorn.rb"

  unicorn_config unicorn_file do
    listen            "'#{sock}'" => { :backlog => 64 }
    owner             node[:app_user]
    group             node[:app_user]
    preload_app       true
    worker_processes  2 
    pid               "/data/pids/unicorn_#{app[:name]}.pid"
    working_directory "/data/apps/#{app[:name]}/current/" 
    stderr_path       "/data/logs/#{app[:name]}/error.log"
    stdout_path       "/data/logs/#{app[:name]}/out.log"
  end

  unicorn_cmd = "cd #{app_path}/current && /usr/local/bin/#{app[:name]}_unicorn_rails -D -E production -c #{unicorn_file}"
  unicorn_pid = "/data/pids/unicorn_#{app[:name]}.pid"

  template "/etc/init.d/unicorn_#{app[:name]}" do
    owner node[:app_user]
    mode 0744
    source "unicorn.init.erb"
    variables(
      :name       => app[:name],
      :cmd        => unicorn_cmd,
      :app_root   => "#{app_path}/current",
      :pid        => unicorn_pid,
      :config_path=> unicorn_file
    )
  end

  service "unicorn_#{app[:name]}" do
    supports :start => true, :stop => true, :restart => true
    action [ :enable, :start ]
  end

  god_monitor "unicorn_#{app[:name]}" do
    config "unicorn.god.erb"
    vars(
      {
        :root => "#{app_path}",
        :cmd => unicorn_cmd,#"/etc/init.d/unicorn_#{app[:name]} start",
        :pid => unicorn_pid,
        :uid => node[:app_user],
        :gid => node[:app_user]
      }
    )
  end
end


# God monitoring config... extract to cookbook
rvm_gem "god" do
  ruby_string "ruby-1.9.2-p180"
end

rvm_wrapper "bootup" do
  ruby_string "ruby-1.9.2-p180"
  binary "god"
end

directory "/etc/god/conf.d" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

template "/etc/god/master.god" do
  source "master.god.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/init.d/god" do
  owner node[:root]
  mode 0755
  source "god.init.erb"
end

service "god" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end
# end god


# monitor nginx
god_monitor "nginx" do
  config "nginx.god.erb"
end

# remove default site...
bash "disabling nginx default" do
  only_if "[ -f /etc/nginx/sites-enabled/default ]"
  user "root" 
  code "/usr/sbin/nxdissite default"
  notifies :restart, resources(:service => "nginx")
end

#need to restart nginx x














