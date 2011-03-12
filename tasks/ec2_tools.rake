# variables in script
# pk--.pem
# cert--.pem 
# volumes, devs, mounts


task :upload_certs do
  #sh "sudo apt-get install apt-get install openjdk-6-jre-headless"
  #sh "sudo apt-get install unzip"
  sh "scp ec2-api-tools.zip #{server}:~/"
  sh "scp ec2.init.sh #{server}:~/"
  sh "sudo cp ec2-api-tools.zip /root/tools.zip && cd /root && unzip tools.zip"
  sh "sudo cp ec2.init.sh /etc/init.d/ec2"
  sh "sudo chmod +x /etc/init.d/ec2"
  sh "sudo update-rc.d ec2 defaults"
end
