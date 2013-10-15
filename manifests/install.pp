class python::install {

  $python = 'python'

  $pythondev = $::operatingsystem ? {
    /(?i:RedHat|CentOS|Fedora)/ => "${python}-devel",
    /(?i:Debian|Ubuntu)/        => "${python}-dev"
  }

  package { $python: ensure => present }

  $dev_ensure = $python::dev ? {
    true    => present,
    default => absent,
  }

  $pip_ensure = $python::pip ? {
    true    => present,
    default => absent,
  }

  package { $pythondev: ensure => $dev_ensure }
  package { 'python-pip': ensure => $pip_ensure }

  python::execute_remote { 'install_ez_setup':
    uri   =>  'https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py'
  }
  ->
  python::execute_remote { 'install_pip':
    uri   =>  'https://raw.github.com/pypa/pip/master/contrib/get-pip.py'
  }
  ->
  python::pip { 'upgrade-setuptools':
    package => 'setuptools'
  }
  ->
  python::pip { 'install-virtualenv':
    package => 'virtualenv'
  }

}

define python::execute_remote (
  $uri         = false,
  $owner       = 'root',
  $local_dir   = '/tmp/'
) {

  $filename = inline_template('<%= File.basename(uri) %>')

  exec { "get-remote-${filename}":
    command => "wget -P ${local_dir} ${uri}",
    user    => $owner,
    path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
    cwd     => "${local_dir}"
  }
  ->
  exec { "execute-remote-${filename}":
    command => "python ${local_dir}${filename}",
    user    => $owner,
    path    => [ '/bin', '/usr/bin', '/usr/sbin' ],
    cwd     => "${local_dir}"
  }
}

define python::pip (
  $package    = '',
  $owner      = 'root'
) {

  exec { "pip-install-${package}":
    command => "pip install --upgrade ${package}",
    path    => [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ]
  }
}