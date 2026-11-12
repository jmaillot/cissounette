#!/usr/bin/env bash
# Première installation sur le VPS :
#   git clone <votre-repo> /opt/boutique && cd /opt/boutique
#   cp .env.example .env   # puis remplir les mots de passe
#   ./scripts/install.sh
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "ERREUR : créez d'abord .env (cp .env.example .env) et remplissez les mots de passe."
  exit 1
fi

mkdir -p wp-content/themes/cissounette

docker compose up -d
echo ""
echo "✅ Stack démarrée."
echo "   Site      : http://$(hostname -I | awk '{print $1}') (accessible via Traefik une fois le domaine/labels configurés)"
echo "   Admin WP  : /wp-admin"
echo ""
echo "Ensuite, dans WordPress :"
echo "  1. Terminer l'assistant d'installation (langue, admin, mot de passe)"
echo "  2. Installer WooCommerce + le plugin WooCommerce Stripe Gateway"
echo "  3. Installer le thème Astra (Apparence > Thèmes > Ajouter > « Astra »), puis activer le thème enfant 'Cissounette'"
