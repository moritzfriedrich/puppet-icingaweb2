# == Class icingaweb2::mod::doc
#
class icingaweb2::mod::doc (
    $enabled    = false,
) {
    require ::icingaweb2

    validate_bool($enabled)

    file { "${::icingaweb2::config_dir}/modules/doc":
        ensure => link,
        target => "${::icingaweb2::web_root}/modules/doc"
    }

    if $enabled {
        file { "${::icingaweb2::config_dir}/enabledModules/doc":
            ensure => link,
            target => "${::icingaweb2::web_root}/modules/doc"
        }
    }
}
