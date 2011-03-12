require 'json'

dna = {

  :app_user => "ubuntu",

  :apps => [
    {
      :name     => 'boxedfiles',
      :deploy   => '',
      :servername => '_'
    }
  ],

  :recipes => [
    "applications"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
