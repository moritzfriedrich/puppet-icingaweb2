class icingaweb2::database {
  require ::icingaweb2

  validate_re($::icingaweb2::web_db, '^(mysql|pgsql)$', "Database type ${::icingaweb2::web_db} is not supported!")

  if $::icingaweb2::web_db_schema {
    $web_db_schema = $::icingaweb2::web_db_schema
  }
  else {
    $web_db_schema = $::icingaweb2::web_db ? {
      'mysql' => "${::icingaweb2::web_root}/etc/schema/${::icingaweb2::params::web_db_schema_mysql}",
      'pgsql' => "${::icingaweb2::web_root}/etc/schema/${::icingaweb2::params::web_db_schema_pgsql}",
      default => undef,
    }
  }
  validate_absolute_path($web_db_schema)

  if $::icingaweb2::web_db == 'mysql' {

    exec { 'mysql_schema_load':
      user    => 'root',
      path    => $::path,
      command => "mysql -h '${::icingaweb2::web_db_host}' -u '${::icingaweb2::web_db_user}' -p'${::icingaweb2::web_db_pass}' '${::icingaweb2::web_db_name}' < '${web_db_schema}' && touch ${::icingaweb2::config_dir}/mysql_schema_loaded.txt",
      creates => "${::icingaweb2::config_dir}/mysql_schema_loaded.txt",
    }
  }
  elsif $::icingaweb2::web_db == 'pgsql' {

    if $::icingaweb2::web_db_port {
      $port = "-p ${::icingaweb2::web_db_port}"
    } else {
      $port = undef
    }

    exec { 'postgres_schema_load':
      user        => 'root',
      path        => $::path,
      environment => [
        "PGPASSWORD=${::icinga2::web_db_pass}",
      ],
      command     => "psql -U '${::icingaweb2::web_db_user}' -h '${::icingaweb2::web_db_host}' ${port} -d '${::icingaweb2::web_db_name}' < '${web_db_schema}' && touch ${::icingaweb2::config_dir}/postgres_schema_loaded.txt",
      creates     => "${::icingaweb2::config_dir}/postgres_schema_loaded.txt",
    }
  }
}
