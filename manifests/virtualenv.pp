# == Define: python::virtualenv
#
# Creates Python virtualenv.
#
# === Parameters
#
# [*requirements*]
#  Path to pip requirements.txt file. Default: none
#
# [*owner*]
#  The owner of the virtualenv being manipulated. Default: root
#
# [*group*]
#  The group relating to the virtualenv being manipulated. Default: root
#
# === Examples
#
# python::virtualenv { '/var/www/project1':
#   requirements => '/var/www/project1/requirements.txt',
# }
#
# === Authors
#
# Stuart Butler
#
define python::virtualenv (
  $requirements = false,
  $owner        = 'root',
  $group        = 'root'
) {

  $venv_dir = $name
  $pip_env  = "${venv_dir}/bin/pip"

  exec { "virtualenv-$-{venv_dir}":
    command => "mkdir -p ${venv_dir} && virtualenv ${venv_dir}",
    user    => $owner,
    creates => "${venv_dir}/bin/activate",
    path    => [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    cwd     => "/tmp",
  }
  ->
  exec { "python-requirements-${name}":
    command     => "${pip_env} --log-file ${venv_dir}/pip.log install -r ${requirements}",
    user        => $owner
  }
}
