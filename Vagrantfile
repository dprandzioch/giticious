Vagrant.configure(2) do |config|
  
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder ".", "/vagrant", type: :nfs

  config.vm.define "vivid" do |box|
    box.vm.box = "ubuntu/vivid64"

    box.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y git ruby ruby-dev libsqlite3-dev build-essential
      sudo gem install rake bundler
      cd /vagrant
      sudo bundle install
    SHELL
  end

  config.vm.define "centos7" do |box|
    box.vm.box = "centos/7"

    box.vm.provision "shell", inline: <<-SHELL
      sudo yum install -y git ruby ruby-devel rubygems rubygem-bundler rubygem-rake sqlite-devel gcc-c++
      cd /vagrant
      sudo bundle install
    SHELL
  end
end