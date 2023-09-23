# Class: etcd
# ===========================
#
# A module to manage a etcd store https://etcd.io/
#
# Parameters
# ----------
# [*install_method*]
#   The method on how to install etcd. Can be either wget (using etcd_source) or package (using $package_name)
#   Defaults to wget
#
# [*package_name*]
#   The system package name for installing etcd
#   Defaults to etcd-server
#
# [*hostname*]
#   The name of the etcd instance.
#   An example with hiera would be kubernetes::etcd_hostname: "%{::fqdn}"
#   Defaults to hostname
#
# [*ipaddr*]
#   The ip address that you want etcd to use for communications.
#   An example with hiera would be kubernetes::etcd_ip: "%{networking.ip}"
#   Or to pin explicitly to a specific interface kubernetes::etcd_ip: "%{::ipaddress_enp0s8}"
#   Defaults to undef
#
# [*initial_cluster*]
#   This will tell etcd how many nodes will be in the cluster and is passed as a string.
#   An example with hiera would be kubernetes::etcd_initial_cluster: etcd-kube-master=http://172.17.10.101:2380,etcd-kube-replica-master-01=http://172.17.10.210:2380,etcd-kube-replica-master-02=http://172.17.10.220:2380
#   Defaults to undef
#
# [*initial_cluster_state*]
#   This will tell etcd the initial state of the cluster. Useful for adding a node to the cluster. Allowed values are
#   "new" or "existing"
#   Defaults to "new"
#
# [*initial_cluster_token*]
#   Initial cluster token for the etcd cluster during bootstrap.
#   Defaults to "my-etcd-token"
#
# [*ca_key*]
#   This is the ca certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*ca_crt*]
#   This is the ca certificate data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*server_key*]
#   This is the server certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*server_crt*]
#   This is the server certificate data for the etcd cluster . This must be passed as string not as a file.
#   Defaults to undef
#
# [*peer_crt*]
#   This is the peer certificate data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
# [*peer_key*]
#   This is the peer certificate key data for the etcd cluster. This must be passed as string not as a file.
#   Defaults to undef
#
class etcd (
  String $initial_cluster_token = 'my-etcd-token',
  Enum['new', 'existing'] $initial_cluster_state = 'new',
  String $hostname = $facts['networking']['hostname'],
  Optional[String] $ipaddr = undef,
  Optional[String] $initial_cluster = undef,
  Optional[String] $ca_key = undef,
  Optional[String] $ca_crt = undef,
  Optional[String] $server_crt = undef,
  Optional[String] $server_key = undef,
  Optional[String] $peer_crt = undef,
  Optional[String] $peer_key = undef,
  String $install_method = 'wget',
  Boolean $listen_metrics_urls = false,
  Integer $snapshot_count = 0,
  String $package_name = $etcd::params::package_name,
) inherits etcd::params {}
