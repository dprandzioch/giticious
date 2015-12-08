#!/bin/bash

sudo apt-get update
sudo apt-get install -y git ruby ruby-dev libsqlite3-dev build-essential
sudo gem install giticious

echo "Please start SSH service on port 22 and enable PubkeyAuthentication."
echo "Now create a user called 'git', log in and run 'giticious init'."
echo "From then on, your Git server can be managed through the giticious CLI util."