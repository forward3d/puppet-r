define r::package($r_path = '/usr/bin/R', $repo = 'http://cran.rstudio.com', $dependencies = false) {

  $command = $dependencies ? {
    true    => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = TRUE)\"",
    default => "${r_path} -e \"install.packages('${name}', repos='${repo}', dependencies = FALSE)\""
  }

  exec { "install_r_package_${name}":
    command => $command,
    unless  => "${r_path} -q -e '\"${name}\" %in% installed.packages()' | grep 'TRUE'",
    require => Class['r']
  }

}
