# Web stack debugging #4

Nginx was started with a limit of 15 open files from `/etc/default/nginx`.
Concurrent requests exhausted that limit and produced HTTP errors. The Puppet
manifest raises the limit to 4096 and restarts Nginx when it changes.
