# install_letsencrypt_ssl
A Bash script that installs Certbot and automatically issues a Let’s Encrypt SSL certificate for a VPS hostname. Supports Nginx, Apache, and standalone mode on Ubuntu, Debian, CentOS, RHEL, AlmaLinux, and Rocky Linux. Automatically configures renewal via systemd timers.

---------------------------
What it does
---------------------------
This bash script automatically installs a Letsencrypt SSL certifcate on your VPS (once its setup with an A record and reachable). This script was made to run on UK VPS from https://www.vm6.co.uk/uk-vps-hosting however it should work on other KVM VPS environments as well. It will also work on VM6 Networks Dedicated servers found here https://www.vm6.co.uk/dedicated-servers 

✔ Installs Certbot
✔ Detects Debian/Ubuntu/CentOS/RHEL/Rocky/AlmaLinux
✔ Installs required web server plugins (Nginx, Apache or standalone)
✔ Prompts for the hostname (FQDN)
✔ Obtains and auto-renews an SSL cert
✔ Configures automatic renewal through systemd

-------------------------------
How to use
-------------------------------

1. Download the Script

Clone your repository or manually download the script onto your VPS.

git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

Or if downloading directly:

wget https://raw.githubusercontent.com/<your-username>/<your-repo>/main/install_letsencrypt_ssl.sh

2. Make the Script Executable
chmod +x install_letsencrypt_ssl.sh

3. Run the Script as Root

The script must be executed with root privileges:

sudo bash install_letsencrypt_ssl.sh

4. Enter Your VPS Hostname

When prompted, enter the fully qualified domain name (FQDN) of your VPS, for example:

server.vm6.co.uk

This must already point to the server’s IP in DNS.

5. Choose the SSL Installation Mode

Select the option matching your setup:

1) Nginx
2) Apache
3) Standalone (no web server)

The script will:

Install Certbot

Issue an SSL certificate

Configure the web server

Enable automatic certificate renewal

6. Verify the Certificate

After the script finishes, confirm SSL is working by visiting:

https://your-hostname
