Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  #change this, if you also change in manifests/site.pp  
  config.vm.hostname = "devphp.local"
  config.vm.network :private_network, ip: "192.168.56.111"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "puppet/modules"
  end
end