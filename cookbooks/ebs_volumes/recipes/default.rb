include_recipe "xfs"
include_recipe "aws"

node[:ebs_volumes].each do |ebs|

  aws_ebs_volume ebs[:name] do
   provider "aws_ebs_volume"
   aws_access_key node[:aws_access_key]
   aws_secret_access_key node[:aws_secret_key]
   action :attach
   device ebs[:device]
   volume_id ebs[:volume_id]
   availability_zone ebs[:zone]
  end

  mount ebs[:mount_to] do
    device ebs[:device]
    options "rw noatime"
    fstype "xfs"
    action [ :enable, :mount ]
    # Do not execute if its already mounted
    not_if "cat /proc/mounts | grep /var/cookies"
  end

  # mkfs.xfs /dev/sdh && mount -t xfs -o defaults /dev/sdh /data
end
