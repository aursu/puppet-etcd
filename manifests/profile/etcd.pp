# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::profile::etcd
class etcd::profile::etcd {
  include etcd
  include etcd::packages
  include etcd::config
  include etcd::service

  Class['etcd::packages']
  -> Class['etcd::config']
  ~> Class['etcd::service']

  # TODO: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/
}
