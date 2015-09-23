require 'spec_helper'

describe 'icingaweb2::mod::monitoring', :type => :class do
    let (:pre_condition) { '$concat_basedir = "/tmp"' }
    let (:facts) { debian_facts }

    let :pre_condition do
        'include ::icingaweb2'
    end

    describe 'without parameters' do
        it { should create_class('icingaweb2::mod::monitoring') }
        it { should contain_file('/etc/icingaweb2/modules/monitoring') }
        it { should contain_file('/etc/icingaweb2/enabledModules/monitoring') }
    end

    describe 'with parameter: enabled' do
        context 'monitoring plugin is enabled' do
            let (:params) {
                {
                    :enabled => true
                }
            }
        
            it { should contain_file('/etc/icingaweb2/enabledModules/monitoring').with({
                    'ensure' => 'link',
                    'target' => '/usr/share/icingaweb2/modules/monitoring'
                })
            }
        end

        context 'monitoring plugin is disabled' do
            let (:params) {
                {
                    :enabled => false
                }
            }
        
            it { should contain_file('/etc/icingaweb2/enabledModules/monitoring').with({
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

    describe 'with parameter: instances' do
        context 'add several ini settings for instances' do
            let(:params) { 
                {
                    :instances => { 'icinga' => { 'transport' => 'local', 'path' => '/var/run/icinga2/cmd/icinga2.cmd' } }
                }
            }

            it { should contain_ini_setting('icingaweb2 module monitoring instance icinga transport').with({
                    'path'    => "/usr/share/icingaweb2/modules/monitoring/instances.ini",
                    'section' => /icinga/,
                    'setting' => /transport/,
                    'value'   => /"local"/,
                })
            }

            it { should contain_ini_setting('icingaweb2 module monitoring instance icinga path').with({
                    'path'    => "/usr/share/icingaweb2/modules/monitoring/instances.ini",
                    'section' => /icinga/,
                    'setting' => /path/,
                    'value'   => "\"/var/run/icinga2/cmd/icinga2.cmd\"",
                })
            }

        end

        context 'fail if value is string' do
            let(:params) { 
                {
                    :instances => 'asdf1234'
                }
            }

            it { should raise_error(/is not a Hash/) }
        end

        context 'fail if value is array' do
            let(:params) { 
                {
                    :instances => ['one', 'two', 'three']
                }
            }

            it { should raise_error(/is not a Hash/) }
        end

        context 'fail if value is boolean' do
            let(:params) { 
                {
                    :instances => true
                }
            }

            it { should raise_error(/is not a Hash/) }
        end
    end

    describe 'with parameter: security' do
        context 'with security is string' do
            let (:params) {
                {
                    :security => 'asdf1234'
                }
            }

            it { should contain_ini_setting('icingaweb2 module monitoring config protected_customvars').with({
                    'path'    => "/usr/share/icingaweb2/modules/monitoring/config.ini",
                    'section' => /security/,
                    'setting' => /protected_customvars/,
                    'value'   => /"asdf1234"/,
                })
            }
        end

        context 'fail if value is boolean' do
            let(:params) { 
                {
                    :security => true
                }
            }

            it { should raise_error(/is not a string/) }
        end

        context 'fail if value is array' do
            let(:params) { 
                {
                    :security => ['one', 'two', 'three']
                }
            }

            it { should raise_error(/is not a string/) }
        end

        context 'fail if value is hash' do
            let(:params) { 
                {
                    :security => { keya => 'aaaa', keyb => 'bbbb' }
                }
            }

            pending
            #it { should raise_error(/is not a string/) }
        end
    end

end
