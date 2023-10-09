# @summary Setup systemd service configuration for ETCD
#
# Setup systemd service configuration for ETCD
#
# @param ca_crt
#   Content of supplied CA certificate in PEM format. A shared cluster CA certificate (ca.crt) for
#   both peer connections and client connections. This certificate will be stored
#   into /etc/kubernetes/pki/etcd/ca.crt
#
# @param ca_key
#   Optionally supplied CA certificate KEY content. This key will be stored
#   into /etc/kubernetes/pki/etcd/ca.key
#
# @param server_crt
#   Content of the certificate in PEM format used both encrypts traffic and authenticates its
#   connections. This certificate will be stored into /etc/kubernetes/pki/etcd/server.crt
#
# @param server_key
#   Content of the certificate KEY. Key for the certificate `server_crt`. Must be unencrypted.
#   This KEY will be stored into /etc/kubernetes/pki/etcd/server.key
#
# @param peer_crt
#   Content of the Peer certificate. Certificate used for SSL/TLS connections between peers.
#   This will be used both for listening on the peer address as well as sending requests to other
#   peers. This certificate will be copied into /etc/kubernetes/pki/etcd/peer.crt
#
# @param peer_key
#   Content of the Peer certificate KEY. Key for the Peer certificate `peer_crt`. Must be
#   unencrypted. This KEY will be copied into /etc/kubernetes/pki/etcd/peer.key
#
# @param ca_pki
#   If set to ture then CA certificate has been already installed by user into
#   /etc/kubernetes/pki/etcd/ca.crt
#
# @param server_pki
#   If set to ture then clients' communication certificate and key have been already installed
#   by user into /etc/kubernetes/pki/etcd/server.crt and /etc/kubernetes/pki/etcd/server.key
#   accordingly
#
# @param peer_pki
#   If set to ture then peers' communication certificate and key have been already installed
#   by user into /etc/kubernetes/pki/etcd/peer.crt and /etc/kubernetes/pki/etcd/peer.key
#   accordingly
#
# @example
#   include etcd::config
class etcd::config (
  String $install_method = $etcd::install_method,
  Boolean $ca_pki = false,
  Optional[String] $ca_key = $etcd::ca_key,
  Optional[String] $ca_crt = $etcd::ca_crt,
  Boolean $server_pki = false,
  Optional[String] $server_crt = $etcd::server_crt,
  Optional[String] $server_key = $etcd::server_key,
  Boolean $peer_pki = false,
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
  include etcd::setup

  $etcd_pki = {
    'ca.crt'     => $ca_crt,
    'ca.key'     => $ca_key,
    'peer.crt'   => $peer_crt,
    'peer.key'   => $peer_key,
    'server.crt' => $server_crt,
    'server.key' => $server_key,
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
