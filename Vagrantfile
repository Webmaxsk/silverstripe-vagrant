# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config file sample (config.json)
# {
#	"provider": "lxc",
#	"box": false, 
#	"ip_address": "192.168.2.199",
#	"db_name": "silverstripe",
#	"theme": "source_silverstripe",
#	"forward_agent": true
# }
settings = JSON.parse(File.read('../../config.json'))
ip_address = settings['ip_address']
provider = settings['provider']
box = settings['box']
container_name = settings['container_name']
forward_agent = settings['forward_agent']
puts "IP #{ip_address}, provider #{provider}"

# initialize with vagrant up --provider="YOUR PROVIDER FROM config.json"

Vagrant.configure("2") do |config|

  if provider == "lxc"
	# Provider: lxc
	if box
		config.vm.box = "../../#{box}"
	else 
		config.vm.box = "frensjan/centos-7-64-lxc"
	end

    config.vm.network "private_network", ip: ip_address, lxc__bridge_name: 'vlxcbr1'

    config.vm.provider :lxc do |lxc|
      lxc.customize 'cgroup.memory.limit_in_bytes', '1024M'
	  if container_name
	  	lxc.container_name = "lxc_#{container_name}"
	  end
    end

	config.vm.synced_folder "../../", "/vagrant"

  else
	# Provider: virtualbox
	if box
		config.vm.box = "../../#{box}"
	else 
		config.vm.box = "puppetlabs/centos-7.0-64-nocm"
	end

    config.vm.network :private_network, ip: ip_address

    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.customize ["modifyvm", :id, "--ioapic", "on"]
    end

	# Windows as host? Make your vagrant much faster with NFS. 
	# See https://github.com/winnfsd/vagrant-winnfsd
	config.vm.synced_folder "../../", "/vagrant", type: "nfs"

  end

  # Forward SSH key to Vagrant machine?
  if forward_agent
    config.ssh.forward_agent = true
    config.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
        if ( ! grep -q '#{ssh_pub_key}' /home/vagrant/.ssh/authorized_keys ); then echo '#{ssh_pub_key}' >> /home/vagrant/.ssh/authorized_keys; fi
      SHELL
    end
  end
  
  # Provision
  config.vm.provision "shell", path: "setup.sh"
  config.vm.provision "shell", path: "always.sh", run: "always"

end
