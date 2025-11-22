#!/usr/bin/env bash
#
# install_letsencrypt_ssl.sh
#
# Installs Certbot (Let's Encrypt client) and issues an SSL certificate
# for the VPS hostname. Supports Nginx, Apache, or standalone mode.
#
# Works on:
#   - Ubuntu / Debian
#   - CentOS / RHEL / Rocky / AlmaLinux
#
# Run as: sudo bash install_letsencrypt_ssl.sh
#

set -euo pipefail

# Colors
GREEN="\e[32m"
RESET="\e[0m"

echo -e "${GREEN}=== VM6 Networks – Let's Encrypt SSL Installer ===${RESET}"
echo

# Check root
if [[ $EUID -ne 0 ]]; then
  echo "✘ This script must be run as root. Try: sudo bash $0"
  exit 1
fi

# Detect OS
source /etc/os-release
OS="$ID"

echo "Detected OS: $OS"

# Install certbot depending on OS
install_certbot() {
  case "$OS" in
    ubuntu|debian)
      apt update -y
      apt install -y certbot python3-certbot-nginx python3-certbot-apache
      ;;
    centos|rhel|almalinux|rocky)
      yum install -y epel-release
      yum install -y certbot python3-certbot-nginx python3-certbot-apache
      ;;
    *)
      echo "✘ Unsupported OS: $OS"
      exit 1
      ;;
  esac
}

install_certbot
echo -e "${GREEN}✓ Certbot installed successfully.${RESET}"
echo

# Ask for hostname
read -rp "Enter the VPS hostname (FQDN) to secure with SSL (example: server.vm6.co.uk): " FQDN

if [[ -z "$FQDN" ]]; then
  echo "✘ Hostname cannot be empty."
  exit 1
fi

echo -e "${GREEN}Using hostname: $FQDN${RESET}"
echo

# Ask which mode
echo "Choose SSL mode:"
echo "  1) Nginx"
echo "  2) Apache"
echo "  3) Standalone (no web server)"
read -rp "Enter option [1/2/3]: " MODE

issue_ssl() {
  case "$MODE" in
    1)
      echo -e "${GREEN}Issuing SSL via Certbot (Nginx)...${RESET}"
      certbot --nginx -d "$FQDN"
      ;;
    2)
      echo -e "${GREEN}Issuing SSL via Certbot (Apache)...${RESET}"
      certbot --apache -d "$FQDN"
      ;;
    3)
      echo -e "${GREEN}Stopping web servers for standalone mode...${RESET}"
      systemctl stop nginx 2>/dev/null || true
      systemctl stop apache2 2>/dev/null || true
      systemctl stop httpd 2>/dev/null || true

      certbot certonly --standalone -d "$FQDN"

      echo -e "${GREEN}Restarting web servers...${RESET}"
      systemctl start nginx 2>/dev/null || true
      systemctl start apache2 2>/dev/null || true
      systemctl start httpd 2>/dev/null || true
      ;;
    *)
      echo "✘ Invalid option."
      exit 1
      ;;
  esac
}

issue_ssl

echo
echo -e "${GREEN}✓ SSL certificate issued successfully for $FQDN ${RESET}"
echo

# Enable automatic renewal
echo -e "${GREEN}Enabling automatic SSL renewal...${RESET}"
systemctl enable certbot-renew.timer 2>/dev/null || true
systemctl start certbot-renew.timer 2>/dev/null || true

echo
echo -e "${GREEN}=== SSL Setup Complete ===${RESET}"
echo "Certificate files are stored in:"
echo "  /etc/letsencrypt/live/$FQDN/"
echo
echo "Test automatic renewal:"
echo "  sudo certbot renew --dry-run"
echo
echo -e "${GREEN}Your VPS hostname is now secured with HTTPS!${RESET}"
