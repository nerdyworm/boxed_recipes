include_recipe "rvm"

# install god gem
rvm_gem "god" do
  ruby_string "ruby-1.9.2-p180"
end

# make a rvm wrapper for init script
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
