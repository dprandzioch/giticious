Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y git ruby ruby-dev libsqlite3-dev build-essential
    sudo gem install rake bundler
    cd /vagrant
    sudo bundle install
  SHELL
end