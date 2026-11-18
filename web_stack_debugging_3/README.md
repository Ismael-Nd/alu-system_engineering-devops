# Web stack debugging #3

The WordPress site returned HTTP 500 because `wp-settings.php` referenced
`class-wp-locale.phpp`, while the file is named `class-wp-locale.php`.
`strace` showed the failed file lookup. The Puppet manifest corrects the typo.
