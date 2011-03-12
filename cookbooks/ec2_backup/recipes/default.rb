include_recipe "rvm"

rvm_gem "aws-sdb" do
  ruby_string "ruby-1.9.2-p180"
end

directory "/root/ec2_backups/" do
  owner 'root'
  group 'root'
end

template "/root/ec2_backups/simpledb.rb" do
  source "simpledb.rb.erb"
  owner "root"
  group "root"
  variables(
    :domain   => "#{node[:server_name]}_snapshots"
  )
end

backup = "/root/ec2_backups/make_backup"
purge  = "/root/ec2_backups/purge_backups"

template backup do
  source "make_backup.sh.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :pk_name   => node[:ec2][:pk][:name],
    :cert_name => node[:ec2][:cert][:name],
    :home      => node[:ec2][:home],
    :url       => node[:ec2][:url],
    :key       => node[:aws_access_key],
    :secret    => node[:aws_secret_key],
    :volume    => node[:ec2][:volume],
    :mnt       => node[:ec2][:mnt]
  )
end

template purge do
  source "purge_backups.sh.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :pk_name   => node[:ec2][:pk][:name],
    :cert_name => node[:ec2][:cert][:name],
    :home      => node[:ec2][:home],
    :url       => node[:ec2][:url],
    :key       => node[:aws_access_key],
    :secret    => node[:aws_secret_key]
  )
end

include_recipe "cron"

cron "purge backups" do
  hour 1
  command "#{purge} > /dev/null 2>&1"
end

cron "backups every 3 hours" do
  hour "*/3"
  command "#{backup} '24 hours' > /dev/null 2>&1"
end

cron "backups daily" do
  hour 2
  command "#{backup} '7 days' > /dev/null 2>&1"
end

cron "backups weekly" do
  weekday 1
  command "#{backup} '1 month' > /dev/null 2>&1"
end
