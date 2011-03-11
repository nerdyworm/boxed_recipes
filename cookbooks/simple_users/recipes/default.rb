node[:users].each do |user|

  cmd = "useradd #{user[:username]} --shell /bin/bash"
  cmd += " --create-home" if !user[:system]
  cmd += " --system" if user[:system]

  `#{cmd}`

  if user[:key]
    directory "/home/#{user[:username]}/.ssh" do
      owner node[:appuser]
      group node[:appuser]
      mode 0755
      recursive true
    end

    template "/home/#{user[:username]}/.ssh/authorized_keys" do
      owner node[:username]
      group node[:username]
      mode 0644
      source "authorized_keys.erb"
      variables(
        :key => user[:key]
      )
    end
  end
end
