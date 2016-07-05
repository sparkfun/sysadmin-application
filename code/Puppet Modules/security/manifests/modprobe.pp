class security::modprobe {

  case $operatingsystem {
    centos, redhat, fedora: {
      file { 'CIS.conf':
        path    => '/etc/modprobe.d/CIS.conf',
        ensure  => present,
        source  => "puppet:///modules/security/modprobe_CIS.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
      }
    }
  }

}

# vim: ts=2:sw=2:expandtab
