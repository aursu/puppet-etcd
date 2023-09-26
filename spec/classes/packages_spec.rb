require 'spec_helper'

describe 'etcd::packages' do
  let(:pre_condition) do
    <<-PRECOND
    include etcd
    class { 'etcd::globals':
      version => '3.5.9',
    }
    PRECOND
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(stype: 'openstack') }

      it { is_expected.to compile }

      it {
        is_expected.to contain_archive('etcd-v3.5.9-linux-amd64.tar.gz')
          .with(
            path: '/tmp/etcd-v3.5.9-linux-amd64.tar.gz',
            source: 'https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz',
            extract_command: 'tar zxf %s --strip-components=1 -C /usr/local/bin/ etcd-v3.5.9-linux-amd64/etcd etcd-v3.5.9-linux-amd64/etcdctl etcd-v3.5.9-linux-amd64/etcdutl',
          )
      }
    end
  end
end
