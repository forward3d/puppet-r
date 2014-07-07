class r {

  case $osfamily {
    'Debian': {
      package {"r-base": ensure => installed}
    }
    'RedHat': {
      package {"R-core": ensure => installed}
    }
    default: { fail("Not supported on osfamily $osfamily") }
  }

}

