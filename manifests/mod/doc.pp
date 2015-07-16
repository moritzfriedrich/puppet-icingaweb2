# == Class icingaweb2::mod::doc
#
class icingaweb2::mod::doc (
    $enabled    = true,
) {
    require ::icingaweb2

    validate_bool($enabled)

    $doc_ensure = $enabled ? {
        false => "absent",
        true  => "link",
    }

    file { "${::icingaweb2::config_dir}/modules/doc":
        ensure => link,
        target => "${::icingaweb2::web_root}/modules/doc"
    }

    file { "${::icingaweb2::config_dir}/enabledModules/doc":
        ensure => $doc_ensure,
        target => "${::icingaweb2::web_root}/modules/doc"
    }
}
