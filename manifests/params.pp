# @summary Define module parameters
#
# Define module parameters
#
# @example
#   include etcd::params
class etcd::params {
  $version = '3.5.9'
  $package_name = 'etcd-server'
}
