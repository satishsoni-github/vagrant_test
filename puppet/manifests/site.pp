exec { 'apt-get update':
  path => '/usr/bin',
}

package { 'vim':
  ensure => present,
}

file { '/var/www/':
  ensure => 'directory',
}

file { '/vagrant/app':
  ensure => 'directory',
}

include nginx, php, mysql