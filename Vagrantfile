Vagrant.configure("2") do |config|
    config.vm.box = "geerlingguy/ubuntu2004"

  # Forward ports for accessing services
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5000, host: 5000

  # Provisioning with Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.install = true
  end

  # SSH access
  config.vm.network "private_network", type: "dhcp"
end
