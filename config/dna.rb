require 'json'

dna = {

  :app_user => "ubuntu",


  # users no worky...
  :users =>  {
    :benjamin => {
      :password => "$1$AMlUfrlU$.OO5fUpKsjXjEsLad2bE7."
    },

    :ruby => { }
  },

  :ssh_keys => {
    :benjamin => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwTY+mCZUxGr1aIRueEmkuu1wHRFPkkqiNPPflkPMMr8gXS8QVZz+q8DmSD/FU+UesXBMa3k9xVij0K6VsMVR2Sn3WJTcIwg5fKnq8Sp4wSdtcpv5bexRHNCOXPov8SJehYrITcBKOdf7rSjh4pVoOyHtHwNDzHGZ0EIcxbyiZYBTuAoDoKdrsqG0SisAsXe+lRZmCx5KaymAkGh4XLKoUtxkaGUGh0u9M0d9V3c3MULcx5IeymuFYm91cUuUPrjkarTzDlqFlocvXzaGAxN8qWlDSS/bInpLnTmRNetrXcQB6mOl+ym56tNoigCqxBw+Lgf7mmAa3OiHDFUQhxBPYQ== benjamin@kenpachi-ubuntu"
  },

  :packages => [
    "imagemagick",
    "libmagickwand-dev"
  ],

  :gems => [
    "bundler"
  ],

  :apps => [
    {
      :name     => 'boxedfiles',
      :deploy   => ''
    },
    {
      :name     => 'boxedmobile',
      :deploy   => ''
    }

  ],

  :recipes => [
    "packages",
    #"users",
    #"sudo",
    "git",
    "logrotate",
    "mongodb::source",
    "mongodb::backup",
    "nginx::default",
    "gems",
    "unicorn",
    "applications"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
