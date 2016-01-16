Package {
  allow_virtual => true,
}

include wget

$jenkins_user = 'jenkins'
$jenkins_home = '/home/jenkins'

class { 'jenkins::slave':
  masterurl                => '$MASTER_URL',
  executors                => 1,
  labels                   => '$NODE_LABEL',
  manage_slave_user        => true,
  slave_user               => $jenkins_user,
  slave_home               => $jenkins_home,
  slave_name               => '$NODE_NAME',
  slave_mode               => 'exclusive',
  disable_ssl_verification => true,
  version                  => '1.26',
  install_java             => true,
  ensure                   => 'stopped',
  enable                   => false,
  require                  => Class['wget'],
}
