server = ENV["server"]
dna = ENV['dna']

desc "Upload and run the prepare.sh file on the server"
task :prepare do
  puts "Uploading prepare.sh to #{server}"
  sh "scp prepare.sh #{server}:~/prepare.sh"
  sh "ssh #{server} 'chmod +x prepare.sh && sudo ./prepare.sh'"
end

desc "Create server"
task :create => [:prepare] do

  dna_file = File.join(File.dirname(__FILE__), '../config', dna)
  sh "ruby #{dna_file}"

  Rake::Task[:upload].execute
 
  # run the create server stuff 
  puts "* Running chef solo on remote server *"  
  sh "ssh #{ENV['server']} \"cd #{REMOTE_CHEF_PATH};source /usr/local/lib/rvm && rvmsudo chef-solo -c config/solo.rb -j config/dna.json -l debug\""
e

  # Rake::Task[:cook].execute
end
