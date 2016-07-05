class nagioslogserver {
  file { '/tmp/setup-linux.sh':
    ensure   => 'file',
    source   =>  "puppet:///modules/nagioslogserver/setup-linux.sh",
    notify   => Exec['nagioslogserverscript'],
  }

  exec { "nagioslogserverscript":
      command => "bash /tmp/setup-linux.sh -s fislog.colo.seagate.com -p 5544 &> /tmp/setup-linux.txt",
      path        => ["/bin","/usr/bin","/sbin","/usr/sbin"],
      refreshonly => true,
  }

}

# vim: ts=2:sw=2:expandtab
