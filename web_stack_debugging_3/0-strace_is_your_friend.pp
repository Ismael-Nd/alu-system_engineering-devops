# Correct a misspelled WordPress PHP include that causes HTTP 500.
exec { 'fix-wordpress-locale-include':
  command => '/bin/sed -i "s/class-wp-locale.phpp/class-wp-locale.php/" /var/www/html/wp-settings.php',
  onlyif  => '/bin/grep -q "class-wp-locale.phpp" /var/www/html/wp-settings.php',
}
