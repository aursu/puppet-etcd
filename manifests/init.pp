# Class: etcd
# ===========================
#
# A module to manage a etcd store https://etcd.io/
#
# Parameters
# ----------
# [*etcd_version*]
#   The version of etcd that you would like to use.
#   Defaults to 3.2.18
#
# [*etcd_archive*]
#  The name of the etcd archive
#  Defaults to etcd-v${etcd_version}-linux-amd64.tar.gz
#
# [*etcd_source*]
#  The URL to download the etcd archive
#  Defaults to https://github.com/coreos/etcd/releases/download/v${etcd_version}/${etcd_archive}
#
# [*etcd_install_method*]
#  The method on how to install etcd. Can be either wget (using etcd_source) or package (using $etcd_package_name)
#  Defaults to wget
#
# [*etcd_package_name*]
#  The system package name for installing etcd
#  Defaults to etcd-server
#
# [*etcd_hostname*]
#   The name of the etcd instance.
#   An example with hiera would be kubernetes::etcd_hostname: "%{::fqdn}"
#   Defaults to hostname
#
# [*etcd_ip*]
#   The ip address that you want etcd to use for communications.
#   An example with hiera would be kubernetes::etcd_ip: "%{networking.ip}"
#   Or to pin explicitly to a specific interface kubernetes::etcd_ip: "%{::ipaddress_enp0s8}"
#   Defaults to undef
#
# [*etcd_peers*]
#   This will tell etcd how the list of peers to connect to into the cluster.
#   An example with hiera would be kubernetes::etcd_peers:
#                                  - 172.17.10.101
#                                  - 172.17.10.102
#                                  - 172.17.10.103
#   Defaults to undef
#
# [*etcd_initial_cluster*]
#    This will tell etcd how many nodes will be in the cluster and is passed as a string.
#   An example with hiera would be kubernetes::etcd_initial_cluster: etcd-kube-master=http://172.17.10.101:2380,etcd-kube-replica-master-01=http://172.17.10.210:2380,etcd-kube-replica-master-02=http://172.17.10.220:2380
#   Defaults to undef
#
# [*etcd_initial_cluster_state*]
#     This will tell etcd the initial state of the cluster. Useful for adding a node to the cluster. Allowed values are
#   "new" or "existing"
#   Defaults to "new"
#
# [*etcd_ca_key*]
#   This is the ca certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcd_ca_crt*]
#   This is the ca certificate data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdclient_key*]
#   This is the client certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdclient_crt*]
#   This is the client certificate data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdserver_key*]
#   This is the server certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdserver_crt*]
#   This is the server certificate data for the etcd cluster . This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdpeer_crt*]
#   This is the peer certificate data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*etcdpeer_key*]
#   This is the peer certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
class etcd (
  Optional[String]
          $etcd_version               = '3.3.18',
  Optional[String]
          $etcd_hostname              = $facts['hostname'],
  Optional[String]
          $etcd_ip                    = undef,
  Optional[Array]
          $etcd_peers                 = undef,
  Optional[String]
          $etcd_initial_cluster       = undef,
  Optional[Enum['new', 'existing']]
          $etcd_initial_cluster_state = 'new',
  String  $etcd_ca_key                = undef,
  String  $etcd_ca_crt                = undef,
  String  $etcdclient_key             = undef,
  String  $etcdclient_crt             = undef,
  Optional[String]
          $etcdserver_crt             = undef,
  Optional[String]
          $etcdserver_key             = undef,
  Optional[String]
          $etcdpeer_crt               = undef,
  Optional[String]
          $etcdpeer_key               = undef,
  String  $etcd_archive               = "etcd-v${etcd_version}-linux-amd64.tar.gz",
  String  $etcd_package_name          = 'etcd-server',
  String  $etcd_source                = "https://github.com/coreos/etcd/releases/download/v${etcd_version}/${etcd_archive}",
  String  $etcd_install_method        = 'wget',
)
{
  include etcd::packages
  include etcd::config
  include etcd::service

  Class['etcd::packages']
    -> Class['etcd::config']
    -> Class['etcd::service']
}
