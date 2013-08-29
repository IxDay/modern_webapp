# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu12.04_amd64"
    
    config.ssh.timeout=3600
    config.vm.provision :shell, :path => "bootstrap.sh"
    config.vm.network :private_network, ip: "192.168.50.2"
end
