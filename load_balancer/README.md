# Load balancer

Two Nginx servers sit behind an HAProxy load balancer. Run the scripts on Ubuntu,
not on the local Omarchy workstation.

| Role | Hostname | IP |
| --- | --- | --- |
| Web server | 7303-web-01 | 3.10.209.204 |
| Web server | 7303-web-02 | 16.60.159.142 |
| Load balancer | 7303-lb-01 | 13.135.253.118 |

## Deploy from your local terminal

From the repository directory, these commands configure the correct hostname and
run each script on its intended Ubuntu server. SSH may prompt for your key's
passphrase.

```bash
cd /run/media/ismail/Data/Development/alu-system_engineering-devops
ssh -i ~/.ssh/school ubuntu@3.10.209.204 'sudo hostnamectl set-hostname 7303-web-01 && sudo bash -s' < load_balancer/0-custom_http_response_header
ssh -i ~/.ssh/school ubuntu@16.60.159.142 'sudo hostnamectl set-hostname 7303-web-02 && sudo bash -s' < load_balancer/0-custom_http_response_header
ssh -i ~/.ssh/school ubuntu@13.135.253.118 'sudo hostnamectl set-hostname 7303-lb-01 && sudo bash -s' < load_balancer/1-install_load_balancer
```

## Configure the web servers

Copy `0-custom_http_response_header` to both web servers. On web-01, run:

```bash
sudo hostnamectl set-hostname 7303-web-01
sudo bash ~/0-custom_http_response_header
```

On web-02, run:

```bash
sudo hostnamectl set-hostname 7303-web-02
sudo bash ~/0-custom_http_response_header
```

The script installs Nginx, serves the same home page on both machines, preserves
the permanent `/redirect_me` redirect, configures a custom HTTP 404 page, and adds
`X-Served-By` to responses, including errors. Nginx evaluates `$hostname` on each
server. Configuration is checked before the service restarts.

## Configure the load balancer

Copy `1-install_load_balancer` to lb-01, then run:

```bash
sudo hostnamectl set-hostname 7303-lb-01
sudo bash ~/1-install_load_balancer
```

The script installs HAProxy, enables its packaged init script, and configures
roundrobin balancing between the two web IPs with TCP health checks. It validates
the configuration before restarting and waits for both backends to answer.
Manage it with `sudo service haproxy status`,
`start`, `stop`, or `restart`.

Allow inbound TCP port 80 on all three servers in their cloud security groups and
any active host firewall. Allow SSH port 22 from your workstation.

## Verify from your workstation

```bash
curl -sI http://3.10.209.204/
curl -sI http://16.60.159.142/
for request in 1 2 3 4; do
    curl -sI https://www.ismaelnd.tech/ | grep -i '^X-Served-By:'
done
```

The direct requests should report their respective hostnames. With both backends
healthy and no other traffic, HTTPS requests to the live load balancer alternate
between `7303-web-01` and `7303-web-02`. The live balancer redirects HTTP to
HTTPS.
