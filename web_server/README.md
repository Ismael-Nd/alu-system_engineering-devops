# Web server

Bash automation for Ubuntu 16.04 LTS. Run configuration scripts as root.
Each installer works independently on a fresh machine and can be run again.
Nginx configuration is checked before restarting with `service nginx restart`.

| File | Purpose |
| --- | --- |
| `0-transfer_file` | Copy a file to a user's home directory using an SSH key. |
| `1-install_nginx_web_server` | Install Nginx, listen on port 80, and serve `Holberton School`. |
| `2-setup_a_domain_name` | Must contain your registered root domain only; pending domain details. |
| `3-redirection` | Install the homepage and a 301 redirect from `/redirect_me`, including its trailing slash variant. |
| `4-not_found_page_404` | Install the homepage, redirect, and custom HTTP 404 response. |
| `5-design_a_beautiful_404_page.html` | Original, responsive Museum of Missing Pages illustration with the required French text. |

## Deploy

From this directory, transfer the final installer and illustration:

```bash
./0-transfer_file 4-not_found_page_404 3.10.209.204 ubuntu ~/.ssh/school
./0-transfer_file 5-design_a_beautiful_404_page.html 3.10.209.204 ubuntu ~/.ssh/school
ssh -i ~/.ssh/school ubuntu@3.10.209.204 'sudo bash ~/4-not_found_page_404'
```

Use the private key authorized on your server. Task 4 installs the illustration
as the custom error page and at `/5-design_a_beautiful_404_page.html` when the
HTML file is alongside the script. Without it, the script creates a minimal
404 page containing `Ceci n'est pas une page`. Missing URLs still return 404.
The task 1 and 3 installers replace the default site with their own task's
configuration, so run task 4 last when deploying the complete project.

Verify externally:

```bash
curl -i http://3.10.209.204/
curl -I http://3.10.209.204/redirect_me
curl -I http://3.10.209.204/redirect_me/
curl -i http://3.10.209.204/missing-page
```

The expected statuses are 200, 301, 301, and 404. The homepage must contain
`Holberton School`; the missing page must contain `Ceci n'est pas une page`.
Task 5 submission URL: http://3.10.209.204/5-design_a_beautiful_404_page.html

## Domain task (requires your registered domain)

Register the root domain using the project's .TECH benefit and verify that
its registrar is `Dotserve Inc` as required by the assignment. Create an A
record for `@` pointing to `3.10.209.204` in your DNS provider's dashboard.
Create `2-setup_a_domain_name` containing only that domain plus a final newline
(no scheme, path, or `www`). Do not submit an invented example domain.

Check `dig +short YOUR_DOMAIN A` after DNS propagation, and put your domain
in the school profile's **Project website url** field.

## Validation

```bash
bash -n 0-transfer_file 1-install_nginx_web_server 3-redirection 4-not_found_page_404
shellcheck 0-transfer_file 1-install_nginx_web_server 3-redirection 4-not_found_page_404
```

The installer writes `/etc/nginx/sites-available/default`, enables that site,
and serves files from `/var/www/html`. It targets the project's fresh Ubuntu
