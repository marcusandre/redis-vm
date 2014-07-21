# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.hostname = "redis"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 6379, host: 6379

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Redis"
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.provision "shell", path: "setup.sh"
end
