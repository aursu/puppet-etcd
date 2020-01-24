# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::config
class etcd::config (
  String  $etcd_install_method        = $etcd::etcd_install_method,
  String  $etcd_ca_key                = $etcd::etcd_ca_key,
  String  $etcd_ca_crt                = $etcd::etcd_ca_crt,
  String  $etcdclient_key             = $etcd::etcdclient_key,
  String  $etcdclient_crt             = $etcd::etcdclient_crt,
  String  $etcdserver_crt             = $etcd::etcdserver_crt,
  String  $etcdserver_key             = $etcd::etcdserver_key,
  String  $etcdpeer_crt               = $etcd::etcdpeer_crt,
  String  $etcdpeer_key               = $etcd::etcdpeer_key,
  String  $etcd_hostname              = $etcd::etcd_hostname,
  String  $etcd_ip                    = $etcd::etcd_ip,
  String  $etcd_initial_cluster       = $etcd::etcd_initial_cluster,
  String  $etcd_initial_cluster_state = $etcd::etcd_initial_cluster_state,
  String  $etcd_version               = $etcd::etcd_version,
)
{
  $kube_dirs = ['/etc/kubernetes', '/etc/kubernetes/pki', '/etc/kubernetes/pki/etcd']
  $etcd = ['ca.crt', 'ca.key', 'client.crt', 'client.key', 'peer.crt', 'peer.key', 'server.crt', 'server.key']

  $kube_dirs.each | String $dir |  {
    file  { $dir :
      ensure  => directory,
      mode    => '0600',
      recurse => true,
    }
  }

  $etcd.each | String $etcd_files | {
    file { "/etc/kubernetes/pki/etcd/${etcd_files}":
      ensure  => present,
      content => template("etcd/${etcd_files}.erb"),
      mode    => '0600',
    }
  }

  if $etcd_install_method == 'wget' {
    file { '/etc/systemd/system/etcd.service':
      ensure  => present,
      content => template('etcd/etcd.service.erb'),
    }
  } else {
    file { '/etc/default/etcd':
      ensure  => present,
      content => template('etcd/etcd.erb'),
    }
  }
}
