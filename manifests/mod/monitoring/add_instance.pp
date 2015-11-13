define icingaweb2::mod::monitoring::add_instance (
    $transport,
    $path,
    $section = $name,
    ) {
    ini_setting { "icingaweb2 module monitoring instance ${section} transport":
        path    => "${::icingaweb2::web_root}/modules/monitoring/commandtransports.ini",
        section => $section,
        setting => 'transport',
        value   => "\"${transport}\"",
    }

    ini_setting { "icingaweb2 module monitoring instance ${section} path":
        path    => "${::icingaweb2::web_root}/modules/monitoring/commandtransports.ini",
        section => $section,
        setting => 'path',
        value   => "\"${path}\"",
    }
}
