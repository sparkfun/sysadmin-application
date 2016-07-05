class accounts {

  group { "nagios":
    ensure  => "present",
    gid     => "129",
  }

  @accounts::virtual { "user1":
    ensure   => "present",
    password => 'nope',
    uid      => "1005",
    comment  => "user1",
    groups   => [ 'user1', 'puppet', 'nagios', 'wheel',],
    require  => Group["nagios"],
    tags     => ['sysadmin',],
    keys     => ["nope", ],
  }

  @accounts::virtual { 'user2':
    ensure   => 'present',
    password => 'nope',
    uid      => '1009',
    comment  => 'user2',
    groups   => [ 'user2', 'nagios', 'wheel',],
    require  => Group['nagios'],
    tags     => ['sysadmin',],

  }

  @accounts::virtual { 'user3':
    ensure   => 'present',
    password => 'nope',
    uid      => "1008",
    comment  => "user3",
    groups   => [ 'user3', 'wheel',],
    tags     => ['dba',],
  }



  @accounts::virtual { 'amanda':
    ensure   => 'present',
    uid      => '33',
    comment  => 'Amanda',
    groups   => [ 'disk', ],
  }

  @accounts::virtual { 'addm':
    ensure   => 'present',
    password => 'nope',
    uid      => '560',
    comment  => 'addm',
    groups   => [ 'addm', ],
  }

  @accounts::virtual { 'nagios':
    ensure   => 'present',
    uid      => '129',
    comment  => 'Nagios',
    groups   => [ 'nagios', ],
    require  => Group['nagios'],
  }

  @accounts::virtual { 'scanner':
    ensure   => 'present',
    uid      => '10010',
    groups   => [ 'scanner', ],
    comment  => 'Scanner',
    password => 'nope',
    tags     => [ 'scanner', ],
  }


}

# vim: ts=2:sw=2:expandtab
