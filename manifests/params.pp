class ptory::params {
  $apache_server = $osfamily ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'NOTSET',
  }
  $vhost_conf_dir = $osfamily ? {
    'RedHat' => '/etc/httpd/conf.d',
    'Debian' => '/etc/apache2/sites-enabled',
    default  => 'NOTSET',
  }
  $apache_php = $osfamily? {
    'RedHat' => 'php',
    'Debian' => 'libapache2-mod-php5',
    default  => 'NOTSET',
  }
  $path = [ "/usr/local/bin/","/bin/","/usr/bin","/sbin" ]
  $dir = '/var/www/vhosts'
  $role_dir = $operatingsystem ? {
    'windows' => 'C:/ptory',
    default   => '/etc/ptory',
  }
}

