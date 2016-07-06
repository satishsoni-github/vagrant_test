class php {

  # Install the php5-fpm and php5-cli packages
  package { ['php5-fpm',
             'php5-cli']:
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Make sure php5-fpm is running
  service { 'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }

  #Add php-fpm config file, it contains changes like running php on port instead of socket etc
  file { 'vagrant-phpfpm-wwwconf':
    path => '/etc/php5/fpm/pool.d/www.conf',
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => 0644,
    notify => Service['php5-fpm'],
    require => Package['php5-fpm'],
    source => 'puppet:///modules/php/www.conf',
  }

  #Add web php.ini
  file { 'vagrant-phpfpm-phpini':
    path => '/etc/php5/fpm/php.ini',
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => 0644,
    notify => Service['php5-fpm'],
    require => Package['php5-fpm'],
    source => 'puppet:///modules/php/php.ini',
  }

  #Add cli php.ini
  file { 'vagrant-phpfpm-cli-phpini':
    path => '/etc/php5/cli/php.ini',
    ensure => file,
    owner => 'root',
    group => 'root',    
    mode => 0644,
    require => Package['php5-cli'],
    source => 'puppet:///modules/php/php-cli.ini',
  }

  #Install important php extensions
  package { ['php5-mysql',
             'php5-curl',
             'php5-gd',
             'php5-intl',
             'php-pear',
             'php5-imagick',
             'php5-xdebug',
             'php5-imap',
             'php5-mcrypt',
             'php5-memcache',
             'php5-ming',
             'php5-tidy',
             'php5-xmlrpc',
             'php5-xsl',]:
    ensure => present,
    notify => Service['php5-fpm'],
    require => [
      Package['php5-fpm'],
      File['vagrant-phpfpm-phpini'],
      File['vagrant-phpfpm-cli-phpini'],
      File['vagrant-phpfpm-wwwconf'],
    ],
  }

}