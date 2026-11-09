# Configure the system-wide SSH client to use the school key without passwords.
file_line { 'Turn off passwd auth':
  ensure   => present,
  path     => '/etc/ssh/ssh_config',
  line     => '    PasswordAuthentication no',
  match    => '^\s*#?\s*PasswordAuthentication\s+',
  multiple => true,
}

file_line { 'Declare identity file':
  ensure   => present,
  path     => '/etc/ssh/ssh_config',
  line     => '    IdentityFile ~/.ssh/school',
  match    => '^\s*#?\s*IdentityFile\s+',
  multiple => true,
}
