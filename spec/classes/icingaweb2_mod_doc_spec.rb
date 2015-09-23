require 'spec_helper'

describe 'icingaweb2::mod::doc', :type => :class do
    let (:pre_condition) { '$concat_basedir = "/tmp"' }
    let (:facts) { debian_facts }

    let :pre_condition do
        'include ::icingaweb2'
    end

    describe 'without parameters' do
        it { should create_class('icingaweb2::mod::doc') }
        it { should contain_file('/etc/icingaweb2/modules/doc') }
        it { should contain_file('/etc/icingaweb2/enabledModules/doc') }
    end

    describe 'with parameter: enabled' do
        context 'doc plugin is enabled' do
            let (:params) {
                {
                    :enabled => true
                }
            }
        
            it { should contain_file('/etc/icingaweb2/enabledModules/doc').with({
                    'ensure' => 'link',
                    'target' => '/usr/share/icingaweb2/modules/doc'
                })
            }
        end

        context 'doc plugin is disabled' do
            let (:params) {
                {
                    :enabled => false
                }
            }
        
            it { should contain_file('/etc/icingaweb2/enabledModules/doc').with({
                    'ensure' => 'absent',
                })
            }
        end

        context 'fail if value is string' do
            let(:params) { 
                {
                    :enabled => 'asdf1234'
                }
            }

            it { should raise_error(/is not a boolean/) }
        end

        context 'fail if value is array' do
            let(:params) { 
                {
                    :enabled => ['one', 'two', 'three']
                }
            }

            it { should raise_error(/is not a boolean/) }
        end

        context 'fail if value is hash' do
            let(:params) { 
                {
                    :enabled => { keya => 'aaaa', keyb => 'bbbb' }
                }
            }

            pending
            #it { should raise_error(/is not a boolean/) }
        end
    end
end
