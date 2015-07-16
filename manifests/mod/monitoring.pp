# == Class icingaweb2::mod::monitoring
#
class icingaweb2::mod::monitoring (
    $enabled   = false,
    $instances = $::icingaweb2::params::monitoring_instances,
    $security  = "",
) {
    require ::icingaweb2

    validate_bool($enabled)
    validate_hash($instances)
    validate_string($security)

    file { "${::icingaweb2::config_dir}/modules/monitoring":
        ensure => link,
        target => "${::icingaweb2::web_root}/modules/monitoring",
    }

    if $enabled {
        file { "${::icingaweb2::config_dir}/enabledModules/monitoring":
            ensure => link,
            target => "${::icingaweb2::web_root}/modules/monitoring",
        }
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/config.ini":
        ensure => present,
        owner  => "www-data",
        group  => "root",
        mode   => 644,
    }

    ini_setting { "icingaweb2 module monitoring config protected_customvars":
        path    => "${::icingaweb2::web_root}/modules/monitoring/config.ini",
        section => "security",
        setting => 'protected_customvars',
        value   => "\"${security}\"",
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/backends.ini":
        ensure => present,
        owner  => "www-data",
        group  => "root",
        mode   => 644,
    }

    ini_setting { "icingaweb2 module monitoring backend type":
        path    => "${::icingaweb2::web_root}/modules/monitoring/backends.ini",
        section => "icinga",
        setting => 'type',
        value   => "\"ido\"",
    }

    ini_setting { "icingaweb2 module monitoring backend resource":
        path    => "${::icingaweb2::web_root}/modules/monitoring/backends.ini",
        section => "icinga",
        setting => 'resource',
        value   => "\"icinga_ido\"",
    }

    file { "${::icingaweb2::web_root}/modules/monitoring/instances.ini":
        ensure => present,
        owner  => "www-data",
        group  => "root",
        mode   => 644,
    }

    unless empty($instances) {
        create_resources(add_instance, $instances)
    }

    define add_instance (
        $section = $name,
        $transport,
        $path,
        ) {
        ini_setting { "icingaweb2 module monitoring instance ${section} transport":
            path    => "${::icingaweb2::web_root}/modules/monitoring/instances.ini",
            section => $section,
            setting => 'transport',
            value   => "\"${transport}\"",
        }

        ini_setting { "icingaweb2 module monitoring instance ${section} path":
            path    => "${::icingaweb2::web_root}/modules/monitoring/instances.ini",
            section => $section,
            setting => 'path',
            value   => "\"${path}\"",
        }
    }

}
