class ciscat {
file {'/etc/ciscat':
    ensure  => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
    owner   => 'root',
    group   => 'root',
    mode    => '0750', # this mode will also apply to files from the source directory
    source  => 'puppet:///modules/ciscat/ciscat', # puppet will automatically set +x for directories
}
file { '/etc/ciscat/CIS-CAT.jar':
    mode     => '0750',
    require  =>  File['/etc/ciscat'],
}
file { '/etc/ciscat/CIS-CAT.sh':
    mode     => '0750',
    require  =>  File['/etc/ciscat/CIS-CAT.jar'],
}

file { '/etc/ciscat/results':
    mode     => '0770',
    ensure   => "directory",
}

case $operatingsystem {

    CentOS: {
      $ciscatpack = 'ciscat-1.0-1.noarch.rpm'
      $ccprovider   = 'rpm'
      case $operatingsystemmajrelease {
        '7':  {$ccbenchmark = 'CIS_CentOS_Linux_7_Benchmark_v1.1.0-xccdf.xml'}
        '6':  {$ccbenchmark = 'CIS_CentOS_Linux_6_Benchmark_v1.1.0-xccdf.xml'}
        default: { fail("no ciscat configuration for CentOS Version ${operatingsystemmajrelease}") }
      }
    }

    RedHat: {
      $ciscatpack = 'ciscat-1.0-1.noarch.rpm'
      $ccprovider   = 'rpm'

      case $operatingsystemmajrelease {
        '7': {$ccbenchmark = 'CIS_Red_Hat_Enterprise_Linux_7_Benchmark_v1.1.0-xccdf.xml'}
        '6': {$ccbenchmark = 'CIS_Red_Hat_Enterprise_Linux_6_Benchmark_v1.1.0-xccdf.xml'}
        '5': {$ccbenchmark = 'CIS_Red_Hat_Enterprise_Linux_5_Benchmark_v1.1.0-xccdf.xml'}
        '4': {$ccbenchmark = 'CIS_Red_Hat_Enterprise_Linux_4_Benchmark_v1.1.0-xccdf.xml'}
        default: { fail("no ciscat configuration for Redhat Version ${operatingsystemmajrelease}") }
      }
    }


    default : { fail("no ciscat configuration for ${operatingsystem}") }
  }


  # every sunday at 10am run a scan and report back
  cron { 'weeklyCisCat' :
    command => "/etc/ciscat/CIS-CAT.sh -r /etc/ciscat/results -rn ${hostname} -b /etc/ciscat/benchmarks/${ccbenchmark} -a /dev/null 2>&1",
    user    => root,
    weekday => 7,
    hour    => 10,
    minute  => fqdn_rand(59),
  }
  exec {'install-java':
   command    => '/usr/bin/yum install java-1.8.0-openjdk-headless -y',
   unless     => 'rpm -qa | grep java-1.*.*-openjdk >/dev/null 2>&1 || { exit 1; }',
   path       => "/usr/local/bin/:/bin/",
  }

 filebucket { 'main':
  path   => false,                # This is required for remote filebuckets.
  server => 'nope', # Optional; defaults to the configured puppet master.
 }

}
