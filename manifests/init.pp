# == Class: python
#
# Installs and manages python, pip and virtualenv.
#
# I used this as a starting point: 
# https://github.com/stankevich/puppet-python
#
# === Parameters
#
# [*dev*]
#  Install python-dev. Default: false
#
# === Examples
#
# class { 'python':
#   dev        => true
# }
#
# === Authors
#
# Stuart Butler
#
class python (
  $dev  = false,
) {

  # Module compatibility check
  $compatible = [ 'Debian', 'Ubuntu', 'CentOS', 'RedHat' ]
  if ! ($::operatingsystem in $compatible) {
    fail("Module is not compatible with ${::operatingsystem}")
  }

  include python::install
}
