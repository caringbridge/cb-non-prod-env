Vagrant.configure('2') do |config|

  # Used to set hostnames and IP addresses for the VMs
  # ENV version number
  env_ver = ''

  # IP info per host
  cfgsvr_ip = ''
  s1_ip = ''
  s2_ip = ''
  zend_ip = ''
  default_router = '192.168.3.1'

  # Install Chef
  config.omnibus.chef_version = '12.2.1'
  config.omnibus.install_url = 'http://www.opscode.com/chef/install.sh'

  #Common config shared between multiple VMs
  def shared_chef_config(chef)
    chef.chef_server_url = "https://chef.caringbridge.org"
    chef.validation_key_path = "/etc/chef/validation.pem"
    chef.validation_client_name = "cb-validator"
    chef.delete_node = true
    chef.delete_client = true

    # Set the environment for the chef server
    chef.environment = "_default"

    # Put the client.rb in /etc/chef so chef-client can be run w/o specifying
    chef.provisioning_path = "/etc/chef"

    # logging
    # chef.log_level = :debug
  end

  config.vm.define "cfgsvr-#{env_ver}" do |cs|
    # Set hostname
    cs.vm.hostname = "cfgsvr-#{env_ver}"

    # Every Vagrant virtual environment requires a box to build off of
    cs.vm.box = 'chef/centos-6.5'

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system
    cs.vm.box_url = 'http://vagrant.caringbridge.org/centos-chef.box'

    cs.vm.network :public_network, ip: "#{cfgsvr_ip}", bridge: 'br0'

    # This is a work around line for the default route this needs to be fixed
    # You must run vagrant reload --provision to keep the default route working
    cs.vm.provision :shell, :inline => "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"

    # Customize VM CPU and Memory
    config.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    # Chef run to create things
    cs.vm.provision :chef_client do |chef|
      shared_chef_config chef
      chef.json = {
        'mongodb' => {
          'configserver_url' => "cfgsvr-#{env_ver}"
        }
      }

      # chef.add_recipe 'se-yum::default'
      chef.add_recipe 'role-mongodb-configserver::default'
    end
  end

  config.vm.define "s1-#{env_ver}" do |shard1|
    # Set hostname
    shard1.vm.hostname = "s1-#{env_ver}"

    # Every Vagrant virtual environment requires a box to build off of
    shard1.vm.box = 'chef/centos-6.5'

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system
    shard1.vm.box_url = 'http://sun4600.cbeagan.org/centos-chef.box'

    shard1.vm.network :public_network, ip: "#{s1_ip}", bridge: 'br0'

    # This is a work around line for the default route this needs to be fixed
    # You must run vagrant reload --provision to keep the default route working
    shard1.vm.provision :shell, :inline => "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"

    # Customize VM CPU and Memory
    config.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    # Chef run to create things
    shard1.vm.provision :chef_client do |chef|
      shared_chef_config chef
      # chef.add_recipe 'se-yum::default'
      chef.add_recipe 'role-mongodb-shard1::default'
      chef.add_recipe 'role-mongodb-replicaset1::default'
    end
  end

  config.vm.define "s2-#{env_ver}" do |shard2|
    # Set hostname
    shard2.vm.hostname = "s2-#{env_ver}"

    # Every Vagrant virtual environment requires a box to build off of
    shard2.vm.box = 'chef/centos-6.5'

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system
    shard2.vm.box_url = 'http://sun4600.cbeagan.org/centos-chef.box'

    shard2.vm.network :public_network, ip: "#{s2_ip}", bridge: 'br0'

    # This is a work around line for the default route this needs to be fixed
    # You must run vagrant reload --provision to keep the default route working
    shard2.vm.provision :shell, :inline => "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"

    # Customize VM CPU and Memory
    config.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end

    # Chef run to create things
    shard2.vm.provision :chef_client do |chef|
      shared_chef_config chef
      # chef.add_recipe 'se-yum::default'
      chef.add_recipe 'role-mongodb-shard2::default'
      chef.add_recipe 'role-mongodb-replicaset2::default'
    end
  end

  config.vm.define "zend-#{env_ver}" do |mongos|
    # Set hostname
    mongos.vm.hostname = "zend-#{env_ver}"

    # Every Vagrant virtual environment requires a box to build off of
    mongos.vm.box = 'chef/centos-6.5'

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system
    mongos.vm.box_url = 'http://sun4600.cbeagan.org/centos-chef.box'

    # Set up network configuration
    mongos.vm.network :public_network, ip: "#{zend_IP}", bridge: 'br0'

    # This is a work around line for the default route this needs to be fixed
    # You must run vagrant reload --provision to keep the default route working
     mongos.vm.provision :shell, :inline => "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"

    # Customize VM CPU and Memory
    config.vm.provider "virtualbox" do |v|
      v.memory = 1536
      v.cpus = 1
    end

      # This is a work around line for the default route this needs to be fixed
      # You must run vagrant reload --provision to keep the default route working
      mongos.vm.provision :shell, inline: "if [ -a /etc/init.d/zend-server ]; then /etc/init.d/zend-server restart; fi", run: "always"

      mongos.vm.provision :chef_client do |chef|
        shared_chef_config chef
        # chef.add_recipe 'se-yum::default'
        # chef.add_recipe 'se-hostfile::default'
        chef.add_recipe 'role-mongodb-mongos::default'
        chef.add_recipe 'role-zendserver::default'
        chef.add_recipe 'role-rabbitmq::default'
        chef.add_recipe 'role-twemcache::default'
        # chef.add_recipe 'cb-platform::default'
        chef.add_recipe 'role-sphinx::default'
      end
    end
  end
