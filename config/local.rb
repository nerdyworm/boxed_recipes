#
# Boxed Apps Solo Config

puts "WARNIGN LOCAL COOKBOOK PATH"
cookbook_path     "/home/benjamin/Documents/Workspace/boxedfiles.com/chef/cookbooks"
log_level         :info
file_store_path  File.join(File.dirname(__FILE__), '..')
file_cache_path  File.join(File.dirname(__FILE__), '..')
Chef::Log::Formatter.show_time = false
