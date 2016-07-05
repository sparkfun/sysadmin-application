# Defined type for creating virtual user accounts
#
define accounts::virtual ($ensure,$password,$uid,$comment,$groups,$tags,$keys="") {
#Create User
if $ensure == "present" {
  user { $title:
    ensure            =>  $ensure,
    uid               =>  $uid,
    gid               =>  $uid,
    home              =>  "/home/${title}",
    comment           =>  $comment,
    groups	          =>  $groups,
    password          =>  $password,
    password_max_age  => '180',
    password_min_age  => '0',
    tag               =>  $tags,
    managehome        =>  true,
    require           =>  Group[$title],
  }

  group { $title:
    ensure            =>  $ensure,
    gid               =>  $uid,
  }

  file { "/home/${title}":
    ensure            =>  directory,
    owner             =>  $title,
    group             =>  $title,
    mode              =>  '0750',
    require           =>  [ User[$title], Group[$title] ],
  }

  if ( $keys != "" ) {
    ssh_authorized_key { $title:
      ensure          =>  $ensure,
      type            =>  "ssh-rsa",
      key             =>  "$keys",
      user            =>  "$title",
      require         =>  User["$title"],
      name            =>  "$title",
    }

   #failed attempt at multiple keys in one virtual account 
   # pubkey { $keys: 
   #     user => $title, 
   # } 
  }

}
#Delete User
else {
  user { $title:
    ensure            =>  $ensure,
    uid               =>  $uid,
    gid               =>  $uid,
    home              =>  "/home/${title}",
    comment           =>  $comment,
    groups            =>  $groups,
    password          =>  $password,
    password_max_age  => '180',
    password_min_age  => '0',
    tag               =>  $tags,
    managehome        =>  true,
  }

  group { $title:
    require           =>  User[$title],
    ensure            =>  $ensure,
    gid               =>  $uid,
  }

  file { "/home/${title}":
    ensure            =>  directory,
    owner             =>  root,
    group             =>  root,
    mode              =>  '0770',
    require           =>  [ User[$title], Group[$title] ],
  }

 if ( $keys != "" ) {
    ssh_authorized_key { $title:
      ensure            =>  $ensure,
      type              =>  "ssh-rsa",
      key               =>  "$keys",
      user              =>  "$title",
      require           =>  User["$title"],
      name              =>  "$title",
    }

 }


  }

}

#define pubkey{$user) { 
#    ssh_authorized_key { "${user}@fqdn-${name}": 
#    ensure => present, 
#    key    => $name, 
#    user   => $user, 
#    type   => rsa, 
#  } 
#}

# vim: ts=2:sw=2:expandtab
