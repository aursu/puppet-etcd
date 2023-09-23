# @summary Class etcd packages
#
# @example
#   include etcd::packages
class etcd::packages (
  String $install_method = $etcd::install_method,
  String $package_name = $etcd::package_name,
) inherits etcd::globals {
  $version = $etcd::globals::version
  $archive_directory = $etcd::globals::archive_directory
  $archive = $etcd::globals::archive
  $source = $etcd::globals::source

  if $install_method == 'wget' {
    archive { $archive:
      path            => "/tmp/${archive}",
      source          => $source,
      extract         => true,
      extract_command => "tar zxf %s --strip-components=1 -C /usr/local/bin/ ${archive_directory}/etcd ${archive_directory}/etcdctl ${archive_directory}/etcdutl", # lint:ignore:140chars
      extract_path    => '/usr/local/bin',
      cleanup         => true,
      creates         => ['/usr/local/bin/etcd', '/usr/local/bin/etcdctl', '/usr/local/bin/etcdutl'],
    }
  } else {
    package { $package_name:
      ensure => $version,
    }
  }
}
