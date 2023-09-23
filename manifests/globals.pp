# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include etcd::globals
class etcd::globals (
  String $version = $etcd::params::version,
) inherits etcd::params {
  $archive_directory = "etcd-v${version}-linux-amd64"
  $archive = "${archive_directory}.tar.gz"

  # https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz
  $source = "https://github.com/etcd-io/etcd/releases/download/v${version}/${archive}"
}
