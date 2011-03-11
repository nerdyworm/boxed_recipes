server = ENV["server"]

desc "Upload and run the prepare.sh file on the server"
task :prepare do
  puts "Uploading prepare.sh to #{server}"
  sh "scp prepare.sh #{server}:~/prepare.sh"
  sh "ssh #{server} 'chmod +x prepare.sh && sudo ./prepare.sh'"

  Rake::Task[:cook].execute
end

desc "Create server"
task :create => [:prepare] do
  Rake::Task[:cook].execute
end
