# Raise Nginx's open-file limit so it can serve concurrent requests.
exec { 'raise-nginx-open-file-limit':
  command => '/bin/sed -i "s/-n 15/-n 4096/" /etc/default/nginx',
  onlyif  => '/bin/grep -q "ULIMIT=.*-n 15" /etc/default/nginx',
  notify  => Exec['restart-nginx-after-limit-change'],
}

exec { 'restart-nginx-after-limit-change':
  command     => '/usr/sbin/service nginx restart',
  refreshonly => true,
}
