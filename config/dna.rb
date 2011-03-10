require 'json'

dna = {
  :users => [
    {
      :username => "benjamin",
      :password => "...",
      :authorized_keys => "...",
      :gid => 1000,
      :uid => 1000,
      :sudo => true
    },
    {
      :username => "ruby",
      :gid => 1101,
      :uid => 1101
    }
  ],

  :packages => [
    "imagemagic",
    "libmagickwand-dev"
  ],

  :applications => [
  
  ],

  :recipes => [
    "packages",
    "users",
    "sudo",
    "git",
    "logrotate",
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
