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
  String $tags_quote_wrap = "\"${tags_join}\"",
) inherits datadog_agent::params {
  exec { 'installer':
    command     =>
      'bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"',
    environment => [
      "DD_AGENT_MAJOR_VERSION='${agent_major_version}'",
      "DD_SITE='${datadog_site}'",
      "DD_API_KEY='${api_key}'",
      "DD_TAGS=${tags_quote_wrap}",
    ],
    notify      => Package[$datadog_agent::params::package_name],
  }
}
