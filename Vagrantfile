Vagrant.configure('2') do |config|
  # vagrant plugin install --plugin-source https://rubygems.org/ --plugin-prerelease vagrant-vbguest
  config.vbguest.auto_update = true

  config.vm.box = 'saucy64'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.network :forwarded_port, guest: 8080, host:8080
  config.vm.network :private_network, ip: "192.168.50.4"

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048', '--natdnsproxy1', 'on']
  end
  config.vm.provision :shell, path: 'setup.sh'
end
