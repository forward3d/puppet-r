# Puppet R module

This module gives you the ability to install R, but also R packages.

## Usage

To install R you need to include the class...

    class { 'r': }

Then define any packages you want to be installed...

    r::package { 'ggplot2': }
    r::package { 'reshape': }
