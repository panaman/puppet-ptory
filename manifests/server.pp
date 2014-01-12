class ptory::server(
  $apache_server = $ptory::params::apache_server,
  $apache_php = $ptory::params::apache_php,
  $vhost_conf_dir = $ptory::params::vhost_conf_dir,
  $path      = $ptory::params::path,
  $ptory_dir = $ptory::params::dir,
  $ptory_ip = $::ip,
  $ptory_url = $::fqdn,
  $ptory_port = 69,
  $ptory_owner = root,
  $ptory_group = root,
  $ptory_mode  = 0644,
  $ptory_color = "",
  ) inherits ptory::params {
  ############################
  #         COLORS           #
  ############################
  if ( $ptory_color == 'red' ) {
    $color_a = '#5f1920'
    $color_b = '#a94a58'
  } elsif ( $ptory_color == 'blue' ) {
    $color_a = '#081964'
    $color_b = '#9daae2'
  } elsif ( $ptory_color == 'green' ) {
    $color_a = '#213c21'
    $color_b = '#bcd2c3'
  } elsif ( $ptory_color == 'yellow' ) {
    $color_a = '#777615'
    $color_b = '#e5e48b'
  } elsif ( $ptory_color == 'purple' ) {
    $color_a = '#522255'
    $color_b = '#bf9ec1'
  } elsif ( $ptory_color == 'pink' ) {
    $color_a = '#bf0190'
    $color_b = '#ff8fe3'
  } else {
    $color_a = '#081964'
    $color_b = '#9daae2'
  }
  ############################
  #      END COLORS          #
  ############################
  #ensure_resource('package', ["$apache_server","$apache_php"], {'ensure' => 'present' })
  #ensure_resource('service', "$apache_server", {'ensure' => 'running' })
  #if ! defined_with_params(Package[$apache_php]) {
  #  package { "$apache_php": ensure => present, }
  #}
  #if ! defined_with_params(Package[$apache_server], {'ensure' => 'present'}) {
  #  package { "$apache_server": ensure => present, }
  #}
  Exec{
    path => $path,
  }
  File {
    ensure => present,
    owner  => $ptory_owner,
    group  => $ptory_group,
    mode   => $ptory_mode,
  }
  exec { 'ptory_base_dir':
    command => "mkdir -p $ptory_dir",
    creates => "$ptory_dir",
  }
  $ptory_root = "$ptory_dir/ptory"
  file { "$ptory_root":
    ensure => directory,
    recurse => true,
    purge   => true,
    force   => true,
    require => Exec['ptory_base_dir'],
  }
  $ptory_web_dirs = [
    "$ptory_root/web",
    "$ptory_root/inc",
    "$ptory_root/servervar"
  ]
  file { $ptory_web_dirs:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }
  file { "$vhost_conf_dir/ptory.conf":
    owner  => '0',
    group  => '0',
    mode   => '0644',
    content => template('ptory/ptory.conf.erb'),
    require => Package["$apache_server"],
    notify => Service["$apache_server"],
  }
  file { "$ptory_root/web/ptory.css":
    content => template('ptory/ptory.css.erb'),
  }
  file { "$ptory_root/web/index.php":
    content => template('ptory/index.php.erb'),
  }
  file { "$ptory_root/web/hostname_long.php":
    content => template('ptory/hostname_long.php.erb'),
  }
  file { "$ptory_root/web/hostname_short.php":
    content => template('ptory/hostname_short.php.erb'),
  }
  file { "$ptory_root/web/search.php":
    content => template('ptory/search.php.erb'),
  }
  file { "$ptory_root/inc/head_main.php":
    source => 'puppet:///modules/ptory/head_main.php',
  }
  file { "$ptory_root/inc/foot_main.php":
    source => 'puppet:///modules/ptory/foot_main.php',
  }
  file { "$ptory_root/inc/menu.php":
    source => 'puppet:///modules/ptory/menu.php',
  }
  File <<| tag == 'ptory_server_var' |>>
}
