#!/bin/bash
#
# ami-7d43ae14
#
# This script enables you to get a working ruby on rails 
# enviroment with mongodb, rvm, and rmagick.

sudo apt-get update
sudo apt-get -y install build-essential zlib1g-dev libxml2-dev libxslt-dev \
libssl-dev libcurl4-openssl-dev git-core libreadline5-dev

## Install Ruby and set up path information for rvm
bash < <( curl -L http://bit.ly/rvm-install-system-wide )

echo '[[ -s "/usr/local/lib/rvm" ]] && . "/usr/local/lib/rvm"' >> ~/.bashrc

echo 'if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
  . "$HOME/.rvm/scripts/rvm"
elif [ -s "/usr/local/rvm/scripts/rvm" ] ; then
  . "/usr/local/rvm/scripts/rvm"
fi' >> /etc/profile

echo "gem: --no-ri --no-rdoc" > ~/.gemrc

source /usr/local/lib/rvm 

/usr/local/bin/rvm install 1.9.2
/usr/local/bin/rvm --default 1.9.2

/usr/local/bin/rvm gem install chef --no-ri --no-rdoc
