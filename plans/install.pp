# @summary Install ETCD daemon
#
# Install ETCD daemon binary
#
# @param targets
#   Nodes on which ETCD packages should be installed
#
plan etcd::install (
  TargetSpec $targets,
  String $version = '3.5.9',
) {
  run_plan(facts, $targets)

  return apply($targets) {
    class { 'etcd::globals':
      version => $version,
    }
    include etcd
    include etcd::packages
  }
}
