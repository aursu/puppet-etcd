# @summary Class etcd packages
#
# @example
#   include etcd::packages
class etcd::packages (
  String $etcd_archive        = $etcd::etcd_archive,
  String $etcd_version        = $etcd::etcd_version,
  String $etcd_source         = $etcd::etcd_source,
  String $etcd_package_name   = $etcd::etcd_package_name,
  String $etcd_install_method = $etcd::etcd_install_method,
)
{
  if $etcd_install_method == 'wget' {
    archive { $etcd_archive:
      path            => "/${etcd_archive}",
      source          => $etcd_source,
      extract         => true,
      extract_command => 'tar xfz %s --strip-components=1 -C /usr/local/bin/',
      extract_path    => '/usr/local/bin',
      cleanup         => true,
      creates         => ['/usr/local/bin/etcd', '/usr/local/bin/etcdctl']
    }
  } else {
    package { $etcd_package_name:
      ensure => $etcd_version,
    }
  }
}
