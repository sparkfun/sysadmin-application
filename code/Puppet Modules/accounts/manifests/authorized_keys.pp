
class accounts::authorized_keys {

  ssh_authorized_key { 'user1@machine.com':
    ensure  => present,
    user    => 'user1',
    type    => 'ssh-rsa',
    key     => 'derpfoobarlalalalala243k5jh432jk5h43kj25h432kjh53jh',
    require => User['user1'],
  }

  ssh_authorized_key { 'user1@machine2.com':
    ensure  => present,
    user    => 'user1',
    type    => 'ssh-rsa',
    key     => 'nopefoobarlalalalala24mnb523g5hjk43253234543k5jh423j5k',
    require => User['user1'],
  }



}

# vim: ts =2:sw=2:expandtab
