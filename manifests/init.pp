# init.pp

class r (
  $ensure = installed,
  $devel  = absent,
) {

  case $::osfamily {
    'Debian': {
      package { 'r-base': ensure => $ensure }
    }
    'RedHat': {
      package { 'R': ensure => $devel } ->
      package { 'R-core': ensure => $ensure }
    }
    'windows': {
      # Choco package does not install static version and does not add R to PATH
      exec { 'Install R Windows':
        command  => template('r/windows_install_r.ps1.erb'),
        provider => powershell,
        unless   => "if(Test-Path \"\${Env:ProgramFiles}\\R\\R-*\\bin\\R.exe\"){exit 0}else{exit 1}",
      }
    }
    default: { fail("Not supported on osfamily ${::osfamily}") }
  }

}
