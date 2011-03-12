# Boxed Recipes 

Chef deployment recipies for my server

## OK here we go


packages

gems

application
  gemset
    bundler
    s

services
  unicorn
  nginx
  mongodb
  god


DataDrive Thing
  - ...

MongoDB
  - all set really...

God
  - gem
  - rvm_wrapper
  - service


Nginx
  - install..
  - remove default install
  - god monitor

Unicorn
  - gem
  - rvm_wrapper


Global Setup
  - directories
    - /data/
    - /data/logs
  


Rails Application
  - create
    - /data/apps/{{name}}
    - 
  - rvm gemset
  - gems
    - unicorn
  - rvm_wrappers
    - bootup_unicorn_{{name}}
  

  - nginx config
    - enable config
 
  - unicorn
    - config
    - socket path
    - service
    - god
