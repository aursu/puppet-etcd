# @summary Directories setup
#
# ETCD directories setup
#
# @example
#   include etcd::setup
class etcd::setup {
  $kube_dirs = ['/etc/kubernetes', '/etc/kubernetes/pki', '/etc/kubernetes/pki/etcd']

  $kube_dirs.each | String $dir | {
    file { $dir :
      ensure => directory,
      mode   => '0700',
    }
  }

  file { '/var/lib/etcd':
    ensure => directory,
    mode   => '0700',
  }
}
