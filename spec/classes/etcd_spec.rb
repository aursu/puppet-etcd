require 'spec_helper'

describe 'etcd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(stype: 'openstack') }

      it { is_expected.to compile }
    end
  end
end
