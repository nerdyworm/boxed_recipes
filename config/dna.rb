require 'json'

dna = {

  :app_user => "ubuntu",


  # users no worky...
  :users =>  {
    :benjamin => {
      :password => ""
    },

    :ruby => { }
  },

  :ssh_keys => {
    :benjamin => ""
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
