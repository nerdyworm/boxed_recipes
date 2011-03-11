require 'json'

dna = {

  :app_user => "ubuntu",

  #:rvm_bin  => "/home/benjamin/.rvm/gems/ruby-1.9.2-p0@rails3/bin",
  :rvm_bin  => "/usr/local/rvm/gems/ruby-1.9.2-p180/bin",

  :users =>  [
    {
      :username => "benjamin",
      :sudo     => true,
      :key      => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwTY+mCZUxGr1aIRueEmkuu1wHRFPkkqiNPPflkPMMr8gXS8QVZz+q8DmSD/FU+UesXBMa3k9xVij0K6VsMVR2Sn3WJTcIwg5fKnq8Sp4wSdtcpv5bexRHNCOXPov8SJehYrITcBKOdf7rSjh4pVoOyHtHwNDzHGZ0EIcxbyiZYBTuAoDoKdrsqG0SisAsXe+lRZmCx5KaymAkGh4XLKoUtxkaGUGh0u9M0d9V3c3MULcx5IeymuFYm91cUuUPrjkarTzDlqFlocvXzaGAxN8qWlDSS/bInpLnTmRNetrXcQB6mOl+ym56tNoigCqxBw+Lgf7mmAa3OiHDFUQhxBPYQ== benjamin@kenpachi-ubuntu"
    },
    {
      :username => "ruby",
      :system   => true
    }
  ],

  :packages => [
    "imagemagick",
    "libmagickwand-dev"
  ],

  :apps => [
    {
      :name     => 'boxedfiles',
      :deploy   => '',
      :servername => '_'
    }
    #,
    #{
    #  :name     => 'boxedmobile',
    #  :deploy   => ''
    #}

  ],

  :mongodb => {
    :datadir  => "/data/db",
    :backup   => {
      :backupdir => "/data/backups/mongodb"
    }
  },

  :rvm => {
    :install_rubies => 'disable'
  },

  :recipes => [
    "packages",
    #"simple_users",
    #"sudo",
    "git",
    "logrotate",
    "mongodb::source",
    "mongodb::backup",
    "nginx::default",
    "rvm",
    "unicorn",
    "god",
    "applications"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
