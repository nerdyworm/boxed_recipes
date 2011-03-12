bash "moving api-tools" do
  user 'root'
  code <<-EOH
    cp /etc/chef/cookbooks/ec2_api_tools/lib/ec2-api-tools.zip /root/
    cd /root
    unzip -o ec2-api-tools.zip
    rm ec2-api-tools.zip
    rm -rf #{node[:ec2][:home]}
    mv ec2-api-tools* #{node[:ec2][:home]}
  EOH
end

directory "/root/.ec2/" do
  owner 'root'
  group 'root'
end

template "/root/.ec2/#{node[:ec2][:pk][:name]}" do
  source "key.erb"
  owner "root"
  group "root"
  mode 0440
  variables(:contents => node[:ec2][:pk][:contents])
end

template "/root/.ec2/#{node[:ec2][:cert][:name]}" do
  source "key.erb"
  owner "root"
  group "root"
  mode 0440
  variables(:contents => node[:ec2][:cert][:contents])
end

template "/etc/init.d/ec2" do
  source "ec2.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :pk_name   => node[:ec2][:pk][:name],
    :cert_name => node[:ec2][:cert][:name],
    :home      => node[:ec2][:home],
    :url       => node[:ec2][:url],
    :volume    => node[:ec2][:volume],
    :dev       => node[:ec2][:dev],
    :mnt       => node[:ec2][:mnt],
    :eip       => node[:ec2][:eip]
  )
end

service "ec2" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end
