# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "raring-server-cloudimg-vagrant-amd64-disk1"
  config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"

  config.vm.network :private_network, type: :dhcp

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
  end

  #
  # Configuring node range to be used as datanode or coordinator
  #
  bases = ["datanode", "coordinator"]
  range = (1..9).to_a

  bases.each do |base|
    range.each do |index|
      name="#{base}#{index}"

      config.vm.define name do |node|
        node.vm.hostname = "#{name}.local"

        node.vm.provider "virtualbox" do |vb|
          vb.name = "#{name}.local"
          vb.customize ["modifyvm", :id, "--nic2", "intnet"]
        end

        #
        # Using Ansible provisioning for postgres-xc
        #
        node.vm.provision :ansible do |ansible|
          ansible.playbook = "provisioning/postgresxc.yml"
          ansible.playbook = "provisioning/#{base}.yml"
          ansible.inventory_file = "provisioning/hosts"
        end
      end
    end
  end
end
