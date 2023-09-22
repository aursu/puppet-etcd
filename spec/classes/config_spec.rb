require 'spec_helper'

describe 'etcd::config' do
  let(:pre_condition) { 'include etcd' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(
          stype: 'openstack',
          networking: os_facts[:networking].merge('hostname' => 'controller'),
        )
      end

      kube_dirs = ['/etc/kubernetes', '/etc/kubernetes/pki', '/etc/kubernetes/pki/etcd']
      etcd = ['ca.crt', 'ca.key', 'peer.crt', 'peer.key', 'server.crt', 'server.key']

      it { is_expected.to compile }

      kube_dirs.each do |d|
        it {
          is_expected.to contain_file(d.to_s)
            .with_ensure('directory')
        }
      end

      etcd.each do |f|
        it { is_expected.not_to contain_file("/etc/kubernetes/pki/etcd/#{f}") }
      end

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{^ExecStart=/usr/local/bin/etcd --name=controller})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{--listen-client-urls=http://127.0.0.1:2379,http://10.0.0.11:2379})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{--listen-peer-urls=http://10.0.0.11:2380})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{--initial-cluster=controller=http://10.0.0.11:2380})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{--initial-cluster-token=my-etcd-token})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .with_content(%r{--initial-cluster-state=new})
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/etcd.service')
          .without_content(%r{--client-cert-auth=true})
      }
    end
  end
end
