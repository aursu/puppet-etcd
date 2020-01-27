require 'spec_helper'

describe 'etcd::packages' do
  let(:pre_condition) { 'include etcd' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(stype: 'openstack') }

      it { is_expected.to compile }
    end
  end
end
