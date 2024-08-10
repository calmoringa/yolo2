# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/ubuntu2004"

  config.vm.network "public_network"

  # Sync the current directory with the VM
  config.vm.synced_folder ".", "/vagrant"

  # Enable vbguest plugin to update Guest Additions
  # config.vbguest.auto_update = true

  # Add a shell provisioner to install Docker and Docker Compose
  config.vm.provision "shell", inline: <<-SHELL
    # Update package list and install Docker
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt install net-tools -y
    sudo apt-get update
    sudo apt-get install -y chrony
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add vagrant user to the docker group
    sudo usermod -aG docker vagrant

    # Install pip for Python 3 and Docker Compose
    sudo apt-get install -y python3-pip
    pip3 install docker-compose
  SHELL

  # Use Ansible local provisioning
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
