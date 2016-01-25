Package {
  allow_virtual => true,
}

include wget
include stdlib
include epel

$jenkins_home       = '/var/jenkins_home'
$backup_dir         = '/backup'
$jenkins_master_img = 'reppard/buildbox-jenkins-master'
$swarm_node_img     = 'reppard/buildbox-swarm-node'

# in order to let the Jenkins master in a container access /var/run/docker.sock,
# we need to have the Jenkins user **inside the container** in a group with
# the same gid as the docker group. The RedHat docker package only creates
# the docker system group if it doesn't already exist.
group {'docker':
  ensure => present,
  gid    => 2001,
}

package { [
  'device-mapper-event',
  'device-mapper-libs',
  'device-mapper-event-libs',
  ]:
  ensure => installed,
  before => Class['docker'],
}

class { 'docker':
  tcp_bind                => 'tcp://0.0.0.0:2375',
  socket_bind             => 'unix:///var/run/docker.sock',
  dm_basesize             => '20G',
  package_source_location => 'https://yum.dockerproject.org/repo/main/centos/7/',
  package_release         => 'docker',
  version                 => '1.9.1-1.el7.centos',
  log_opt                 => ['tag=docker;{{.ImageName}};{{.ImageID}}'],
  require                 => [Group['docker']],
}

docker::run { 'seagull':
  image         => 'tobegit3hub/seagull',
  ports         => ['65138:10086'],
  volumes       => ['/var/run/docker.sock:/var/run/docker.sock'],
  pull_on_start => true,
  require       => Class['docker'],
}

docker::run { 'jenkins-master':
  image           => $jenkins_master_img,
  ports           => ['8080:8080','50000:50000'],
  env             => ["ROOT_URL=https://${::fqdn}"],
  restart_service => true,
  volumes_from    => ['jenkins-data'],
  # Allows master to access the host
  volumes         => '/var/run/docker.sock:/var/run/docker.sock',
  require         => [Class['docker'], Exec['jenkins-data']],
}

docker::run { 'swarm-node01':
  image           => $swarm_node_img,
  env             => [
    "NODE_NAME=BuildboxSwarmNode01",
    "NODE_LABEL=dev",
    "NODE_EXECUTORS=2",
  ],
  links           => ['jenkins-master:master'],
  restart_service => true,
  require         => [Class['docker']],
}

docker::run { 'swarm-node02':
  image           => $swarm_node_img,
  env             => [
    "NODE_NAME=BuildboxSwarmNode02",
    "NODE_LABEL=dev",
    "NODE_EXECUTORS=2",
  ],
  links           => ['jenkins-master:master'],
  restart_service => true,
  require         => [Class['docker']],
}

exec {'jenkins-data':
  path    => "/usr/bin",
  command => "docker create -v ${jenkins_home} --name jenkins-data ${jenkins_master_img} /bin/true",
  require => Class['docker'],
}

file {'/backup':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

cron { data_backup:
  command => "/usr/bin/docker run --volumes-from jenkins-data -u root -v ${backup_dir}:/backup ${jenkins_master_img} tar cvf ${backup_dir}/`date +\\%s`.tar /var/jenkins_home",
  user    => root,
  minute  => 0,
}
