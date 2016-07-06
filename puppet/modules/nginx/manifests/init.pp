class nginx {

  # Symlink /var/www/app on our guest with 
  # host /path/to/vagrant/app on our system
  file { '/var/www/app':
    ensure  => 'link',
    target  => '/vagrant/app',
  }

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure  => 'present',
    require => Exec['apt-get update'],
  }

  # Make sure that the nginx service is running
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }

  # Add a vhost template
  file { 'vagrant-nginx-vhost-devphp':
    path    => '/etc/nginx/sites-available/devphp.local',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['nginx'],
    source  => 'puppet:///modules/nginx/devphp.local',
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
    path    => '/etc/nginx/sites-enabled/default',
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    ensure  => absent,
    require => Package['nginx'],
  }

  # Symlink our vhost in sites-enabled to enable it
  file { 'vagrant-nginx-enable':
    path    => '/etc/nginx/sites-enabled/devphp.local',
    target  => '/etc/nginx/sites-available/devphp.local',
    ensure  => link,
    notify  => Service['nginx'],
    require => [
      File['vagrant-nginx-vhost-devphp'],
      File['default-nginx-disable'],
    ],
  }
}