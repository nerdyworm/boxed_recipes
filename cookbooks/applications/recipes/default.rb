include_recipe "unicorn"

node[:apps].each do |app|

  app_path = "/data/apps/#{app[:name]}" 
  sock     = "/data/sockets/#{app[:name]}.sock"

  app_directories = [
    "/data/sockets/",
    "/data/logs",
    "/data/logs/#{app[:name]}",
    "/data/pids",
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

  template "/etc/nginx/sites-available/#{app[:name]}" do
    owner node[:app_user]
    mode 0644
    source "nginxsite.conf.erb"
    variables(
      :name       => app[:name],
      :servername => app[:domain],
      :sock       => sock,
      :root       => "/#{app_path}/current/public"
    )
  end

  unicorn_config "#{app_path}/shared/config/unicorn.rb" do
    listen            "'#{sock}'" => { :backlog => 64 }
    owner             node[:app_user]
    group             node[:app_user]
    preload_app       true
    worker_processes  4 
    pid               "/data/pids/unicorn_#{app[:name]}.pid"
    working_directory "/data/apps/#{app[:name]}/current/public" 
    stderr_path       "/data/logs/#{app[:name]}/error.log"
    stdout_path       "/data/logs/#{app[:name]}/out.log"
  end


  # stilll need to make get repos...
  # still need ot make unicorn start ups...
end
