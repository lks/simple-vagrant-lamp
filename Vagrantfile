Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :private_network, ip: "192.168.56.101"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.synced_folder "/Applications/MAMP/htdocs/wine-be-cool/", "/var/www", id: "vagrant-root",
    owner: "vagrant",
    group: "vagrant",
    mount_options: ["dmode=777,fmode=777"]
  config.vm.synced_folder "/Applications/MAMP/htdocs/phpMyAdmin/", "/var/www/phpMyAdmin", id: "vagrant-root",
    owner: "vagrant",
    group: "vagrant",
    mount_options: ["dmode=777,fmode=777"]
  config.vm.synced_folder "./sqldump", "/var/sqldump", create: true
  config.vm.synced_folder "./scripts", "/var/scripts", create: true
  config.vm.synced_folder "../ParserClover", "/var/www/parserClover", create: true


  config.vm.provision :shell, :path => "bootstrap.sh"
end
