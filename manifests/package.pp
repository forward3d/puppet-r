# package.pp

define r::package (
  $r_path               = '',
  $repo                 = 'https://cran.rstudio.com',
  $source               = 'CRAN',
  Boolean $dependencies = false,
  $environment          = undef,
  $timeout              = 300,
  $configure_args       = undef,
  Boolean $quiet        = true,
  Boolean $force        = false,
) {

    case $::osfamily {
    'Debian', 'RedHat': {

      if $r_path == '' {
        $binary = '/usr/bin/R'
      }
      else
      {
        $binary = $r_path
      }

      $command = $source ? {
        'github' => "${binary} -e \"library(devtools); install_github('${name}', ref='master', quiet=${quiet.bool2str.upcase}, force=${force.bool2str.upcase})\"",
        default  => "${binary} -e \"install.packages('${name}', repos='${repo}', dependencies=${dependencies.bool2str.upcase}, configure.args='${configure_args}', quite=${quiet.bool2str.upcase}, force=${force.bool2str.upcase})\""
      }

      $unless_command = $force ? {
        true  => "/usr/bin/echo FALSE | grep 'TRUE'",
        false => "${binary} -q -e \"'${name.split('/')[-1]}' %in% installed.packages()\" | grep 'TRUE'"
      }

      exec { "install_r_package_${name}":
        command     => $command,
        environment => $environment,
        timeout     => $timeout,
        unless      => $unless_command,
        require     => Class['r']
      }

    }
    'windows': {

      if $r_path == '' {
        $binary = 'r.exe'
      }
      else
      {
        $binary = $r_path
      }

      $deps = $dependencies ? {
        true    => 'TRUE',
        default => 'FALSE'
      }

      exec { "install_r_package_${name}":
        command  => template('r/windows_install_rpackage.ps1.erb'),
        provider => powershell,
        unless   => template('r/windows_rpackage_check.ps1.erb'),
        require  => Class['r']
      }

    }
    default: { fail("Not supported on osfamily ${::osfamily}") }
  }

}
