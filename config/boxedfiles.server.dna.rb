require 'json'

pk_name = "pk-Q4SGBNISNF4KGIBXD5QHSJF2XO3EQAUI.pem"
cert_name = "cert-Q4SGBNISNF4KGIBXD5QHSJF2XO3EQAUI.pem"

dna = {

  :aws_access_key => "#{ENV['AWS_ACCESS_KEY']}",
  :aws_secret_key => "#{ENV['AWS_SECRET_KEY']}",

  :app_user => "ubuntu",

  :server_name => "boxedfiles",

  :packages => [
    "git-core",
    "xfsprogs",
    "openjdk-6-jre-headless",  #for ec2_tools
    "libmagickwand-dev",
    "imagemagick",
    "unzip"
  ],

  :ec2 => {
    :pk => {
      :name => pk_name,
      :contents => File.open(File.expand_path("~/.ec2/#{pk_name}")) { |f| f.read }
    },
    :cert => {
      :name => cert_name,
      :contents => File.open(File.expand_path("~/.ec2/#{cert_name}")) { |f| f.read }
    },
    :eip    => "75.101.145.116",
    :zone   => "us-east-1a",
    :volume => "vol-68ebb700",
    :dev    => "/dev/sdf",
    :mnt    => "/data",
    :home   => "/root/ec2-api-tools",
    :url    => "https://us-east-1.ec2.amazonaws.com"
  },

  :mongodb => {
    :datadir  => "/data/db",
  },

  :recipes => [
    "packages",
    "ec2_api_tools",
    "logrotate",
    "mongodb::source",
    "nginx::default",
    "rvm",
    "god",
    "ec2_backup"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
