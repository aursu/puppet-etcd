# @summary Puppet class that controls the etcd service
#
# @example
#   include etcd::service
class etcd::service {
  service { 'etcd':
    ensure => running,
    enable => true,
  }
}
