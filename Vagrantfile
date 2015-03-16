# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "utopic64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

  config.vm.provision "mysql-container", type: "docker" do |d|
    d.pull_images "mysql:5.6"
    d.run "mysql",
      image: "mysql:5.6",
      args: "-P -e MYSQL_ROOT_PASSWORD=otrspass"
  end
  config.vm.provision "otrs-container", type: "docker" do |d|
    d.build_image "-t takipone/otrs /vagrant"
    d.run "takipone/otrs", args: "-p 80:80 -e OTRS_ENV=develop --link mysql:mysql -v /var/log/httpd:/var/log/httpd"
  end
end
