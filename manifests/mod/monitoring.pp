# == Class icingaweb2::mod::monitoring
#
class icingaweb2::mod::monitoring (
    $enabled   = true,
    $instances = $::icingaweb2::params::monitoring_instances,
    $security  = '',
) {
    require ::icingaweb2

    validate_bool($enabled)
    validate_hash($instances)
    validate_string($security)

    $monitoring_ensure = $enabled ? {
        false => 'absent',
        true  => 'link',
    }

    file { "${::icingaweb2::config_dir}/modules/monitoring":
        ensure => 'link',
        target => "${::icingaweb2::web_root}/modules/monitoring",
    }
    
    file { "${::icingaweb2::config_dir}/enabledModules/monitoring":
        ensure => $monitoring_ensure,
        target => "${::icingaweb2::web_root}/modules/monitoring",
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/config.ini":
        ensure => present,
        owner  => 'www-data',
        group  => 'root',
        mode   => '0644',
    }

    ini_setting { 'icingaweb2 module monitoring config protected_customvars':
        path    => "${::icingaweb2::web_root}/modules/monitoring/config.ini",
        section => 'security',
        setting => 'protected_customvars',
        value   => "\"${security}\"",
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/backends.ini":
        ensure => present,
        owner  => 'www-data',
        group  => 'root',
        mode   => '0644',
    }

    ini_setting { 'icingaweb2 module monitoring backend type':
        path    => "${::icingaweb2::web_root}/modules/monitoring/backends.ini",
        section => 'icinga',
        setting => 'type',
        value   => "\"ido\"",
    }

    ini_setting { 'icingaweb2 module monitoring backend resource':
        path    => "${::icingaweb2::web_root}/modules/monitoring/backends.ini",
        section => 'icinga',
        setting => 'resource',
        value   => "\"icinga_ido\"",
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/instances.ini":
        ensure => present,
        owner  => 'www-data',
        group  => 'root',
        mode   => '0644',
    }

    unless empty($instances) {
        create_resources('icingaweb2::mod::monitoring::add_instance', $instances)
    }

}
