class security {

package { 'telnet-server':
  ensure => 'absent',
}

package { 'rsh-server':
  ensure => 'absent',
}

package { 'rsh':
  ensure => 'absent',
}

package { 'rcp':
  ensure => 'absent',
}

package { 'rlogin':
  ensure => 'absent',
}

package { 'rexec':
  ensure => 'absent',
}

}
