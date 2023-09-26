# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::config
class etcd::config (
  String $install_method = $etcd::install_method,
  Optional[String] $ca_key = $etcd::ca_key,
  Optional[String] $ca_crt = $etcd::ca_crt,
  Optional[String] $server_crt = $etcd::server_crt,
  Optional[String] $server_key = $etcd::server_key,
  Optional[String] $peer_crt = $etcd::peer_crt,
  Optional[String] $peer_key = $etcd::peer_key,
  String $hostname = $etcd::hostname,
  String $ipaddr = $etcd::ipaddr,
  String $initial_cluster = $etcd::initial_cluster,
  String $initial_cluster_state = $etcd::initial_cluster_state,
  String $initial_cluster_token = $etcd::initial_cluster_token,
  Boolean $listen_metrics_urls = $etcd::listen_metrics_urls,
  Integer $snapshot_count = $etcd::snapshot_count,
) inherits etcd::globals {
  include bsys::systemctl::daemon_reload

  $version = $etcd::globals::version

  $kube_dirs = ['/etc/kubernetes', '/etc/kubernetes/pki', '/etc/kubernetes/pki/etcd']

  $etcd_pki = {
    'ca.crt'     => $ca_crt,
    'ca.key'     => $ca_key,
    'peer.crt'   => $peer_crt,
    'peer.key'   => $peer_key,
    'server.crt' => $server_crt,
    'server.key' => $server_key,
  }

  $kube_dirs.each | String $dir | {
    file { $dir :
      ensure  => directory,
      mode    => '0600',
      recurse => true,
    }
  }

  $etcd_pki.each |String $pki_file, $content_string| {
    if $content_string {
      file { "/etc/kubernetes/pki/etcd/${pki_file}":
        ensure  => file,
        content => template("etcd/${pki_file}.erb"),
        mode    => '0600',
      }
    }
  }

  if $install_method == 'wget' {
    file { '/etc/systemd/system/etcd.service':
      ensure  => file,
      content => template('etcd/etcd.service.erb'),
      notify  => Class['bsys::systemctl::daemon_reload'],
    }
  } else {
    file { '/etc/default/etcd':
      ensure  => file,
      content => template('etcd/etcd.erb'),
    }
  }
}
