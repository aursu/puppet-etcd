# @summary ETCD systemd service config
#
# Bolt plan to install ETCD systemd service config
#
# @param targets
#   Nodes to reside ETCD cluster on
#
# @param server_crt
#   Location on the server where certificate is located. This certificate used for SSL/TLS
#   connections to etcd. This certificate will be copied into /etc/kubernetes/pki/etcd/server.crt
#
# @param server_key
#   Location on the server where certificate KEY is located. Key for the certificate `server_crt`.
#   Must be unencrypted. This KEY will be copied into /etc/kubernetes/pki/etcd/server.key
#
# @param peer_crt
#   Location on the server where Peer certificate is located. Certificate used for SSL/TLS
#   connections between peers. This will be used both for listening on the peer address as well as
#   sending requests to other peers. This certificate will be copied
#   into /etc/kubernetes/pki/etcd/peer.crt
#
# @param peer_key
#   Location on the server where Peer certificate KEY is located. Key for the Peer
#   certificate `peer_crt`. Must be unencrypted. This KEY will be copied
#   into /etc/kubernetes/pki/etcd/peer.key
#
# @param ca_crt
#   Supplied CA certificate.
#
# @example
#   include etcd::globals
plan etcd::service (
  TargetSpec $targets,
  Stdlib::Unixpath $server_crt,
  Stdlib::Unixpath $server_key,
  Stdlib::Unixpath $peer_crt,
  Stdlib::Unixpath $peer_key,
  Stdlib::Unixpath $ca_crt,
  Optional[String] $initial_cluster_token = undef,
  Optional[String] $initial_cluster = undef,
) {
  $targets_facts = run_plan(facts, $targets)

  $initial_cluster_value = $initial_cluster ? {
    String => $initial_cluster, # either provided
    default => $targets_facts
    .map |$fcts| { "${fcts['networking']['hostname']}=https://${fcts['networking']['ip']}:2380" }
    .join(',') # or generated based on targets
  }

  get_targets($targets).each |$target| {
    run_plan(facts, $target)

    apply($target) {
      include etcd

      unless $server_crt == '/etc/kubernetes/pki/etcd/server.crt' {
        file { '/etc/kubernetes/pki/etcd/server.crt':
          ensure => file,
          source => "file://${server_crt}",
          mode   => '0600',
          owner  => 'root',
          group  => 'root',
          before => Class['etcd::config'],
        }
      }

      unless $server_key == '/etc/kubernetes/pki/etcd/server.key' {
        file { '/etc/kubernetes/pki/etcd/server.key':
          ensure => file,
          source => "file://${server_key}",
          mode   => '0600',
          owner  => 'root',
          group  => 'root',
          before => Class['etcd::config'],
        }
      }

      unless $peer_crt == '/etc/kubernetes/pki/etcd/peer.crt' {
        file { '/etc/kubernetes/pki/etcd/peer.crt':
          ensure => file,
          source => "file://${peer_crt}",
          mode   => '0600',
          owner  => 'root',
          group  => 'root',
          before => Class['etcd::config'],
        }
      }

      unless $peer_key == '/etc/kubernetes/pki/etcd/peer.key' {
        file { '/etc/kubernetes/pki/etcd/peer.key':
          ensure => file,
          source => "file://${peer_key}",
          mode   => '0600',
          owner  => 'root',
          group  => 'root',
          before => Class['etcd::config'],
        }
      }

      unless $ca_crt == '/etc/kubernetes/pki/etcd/ca.crt' {
        file { '/etc/kubernetes/pki/etcd/ca.crt':
          ensure => file,
          source => "file://${ca_crt}",
          mode   => '0600',
          owner  => 'root',
          group  => 'root',
          before => Class['etcd::config'],
        }
      }

      class { 'etcd::config':
        install_method        => 'wget',
        hostname              => $target.facts['networking']['hostname'],
        ipaddr                => $target.facts['networking']['ip'],
        server_pki            => true,
        peer_pki              => true,
        ca_pki                => true,
        initial_cluster_token => $initial_cluster_token,
        initial_cluster       => $initial_cluster_value,
      }
    }
  }
}
