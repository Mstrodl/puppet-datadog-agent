# Class: datadog_agent::source
#
# This class contains the DataDog agent installation mechanism for source installs
#

class datadog_agent::source(
  Integer $agent_major_version = $datadog_agent::params::default_agent_major_version,
  String $agent_version = $datadog_agent::params::agent_version,
  String $datadog_site = $datadog_agent::params::datadog_site,
  String $api_key = $datadog_agent::api_key,
  String $hostname = $datadog_agent::host,
  Array  $tags = $datadog_agent::tags,
  String $tags_join = join($tags,','),
) inherits datadog_agent::params {
  # Fake package that depends on our exec. Dumb solution
  package { $datadog_agent::params::package_name:
    command  => "/bin/echo",
    # provider => "ports",
    require  => Exec['installer'],
  }
  exec { 'installer':
    environment => [
      "DD_AGENT_MAJOR_VERSION=${agent_major_version}",
      "DD_SITE=${datadog_site}",
      "DD_API_KEY=${api_key}",
      "DD_TAGS=${tags_join}",
    ],
    notify      => Package[$datadog_agent::params::package_name],
    provider    => "shell",
    command     =>
      'bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"',
  }
}
