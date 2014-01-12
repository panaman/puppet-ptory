class ptory::node(
  $dir = $ptory::params::dir, 
  $role = 'UNKNOWN',
  $desc = "",
  $role_dir = $ptory::params::role_dir,
  $ensure_pkgs = 'YES',
  ) inherits ptory::params {
  schedule { 'ptory_daily':
    period => daily,
    repeat => '1',
  }
  @@file { "$dir/ptory/servervar/${hostname}_server_var.php":
    ensure   => present,
    content  => template('ptory/server_var.php.erb'),
  #  schedule => 'ptory_daily',
    tag      => 'ptory_server_var',
  }
  file { "$role_dir":
    ensure => directory,
    mode   => '0755',
  }
  file { "$role_dir/role.txt":
    ensure  => present,
    mode    => '0600',
    content => "$role\n",
  }
  file { "$role_dir/ptory_info.txt":
    ensure => present,
    mode   => '0644',
    content => template('ptory/ptory_info.txt.erb'),
  }
  case $ensure_pkgs {
    'YES': {
      if ( $::kernel == 'Linux' ) {
        if ! defined_with_params(Package['ethtool']) {
          package { 'ethtool': ensure => present, }
        }
      }
    }
  }
  if ( $::operatingsystem != 'windows' ) {
    file { '/usr/local/bin/ptory':
      ensure => present,
      mode => '0755',
      content => "cat /etc/ptory/ptory_info.txt\n",
    }
  } else {}
}
