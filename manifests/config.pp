# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::config
class etcd::config (
  String  $etcd_install_method        = $etcd::etcd_install_method,
  Optional[String]
          $etcd_ca_key                = $etcd::etcd_ca_key,
  Optional[String]
          $etcd_ca_crt                = $etcd::etcd_ca_crt,
  Optional[String]
          $etcdserver_crt             = $etcd::etcdserver_crt,
  Optional[String]
          $etcdserver_key             = $etcd::etcdserver_key,
  Optional[String]
          $etcdpeer_crt               = $etcd::etcdpeer_crt,
  Optional[String]
          $etcdpeer_key               = $etcd::etcdpeer_key,
  String  $etcd_hostname              = $etcd::etcd_hostname,
  String  $etcd_ip                    = $etcd::etcd_ip,
  String  $etcd_initial_cluster       = $etcd::etcd_initial_cluster,
  String  $etcd_initial_cluster_state = $etcd::etcd_initial_cluster_state,
  String  $etcd_initial_cluster_token = $etcd::etcd_initial_cluster_token,
  String  $etcd_version               = $etcd::etcd_version,
)
{
  include systemd::systemctl::daemon_reload

  $kube_dirs = ['/etc/kubernetes', '/etc/kubernetes/pki', '/etc/kubernetes/pki/etcd']

  $etcd = {
    'ca.crt'     => $etcd_ca_crt,
    'ca.key'     => $etcd_ca_key,
    'peer.crt'   => $etcdpeer_crt,
    'peer.key'   => $etcdpeer_key,
    'server.crt' => $etcdserver_crt,
    'server.key' => $etcdserver_key
  }

  $kube_dirs.each | String $dir |  {
    file  { $dir :
      ensure  => directory,
      mode    => '0600',
      recurse => true,
    }
  }

  $etcd.each | String $etcd_files, $content_string | {
    if $content_string {
      file { "/etc/kubernetes/pki/etcd/${etcd_files}":
        ensure  => present,
        content => template("etcd/${etcd_files}.erb"),
        mode    => '0600',
      }
    }
  }

  if $etcd_install_method == 'wget' {
    file { '/etc/systemd/system/etcd.service':
      ensure  => present,
      content => template('etcd/etcd.service.erb'),
      notify  => Class['systemd::systemctl::daemon_reload'],
    }
  } else {
    file { '/etc/default/etcd':
      ensure  => present,
      content => template('etcd/etcd.erb'),
    }
  }
}
