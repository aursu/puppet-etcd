# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::systemctl::daemon_reload
class etcd::systemctl::daemon_reload {
  exec { 'systemd-reload-4ac90e0':
    command     => 'systemctl daemon-reload',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
