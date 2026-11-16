# Firewall

`0-block_all_incoming_traffic_but` installs UFW on web-01 and permits inbound
TCP ports 22 (SSH), 80 (HTTP), and 443 (HTTPS). All other incoming traffic is
denied. The script enables the SSH rule before activating UFW so remote access
remains available.

Run the script as root on web-01 and verify with `ufw status verbose`.
