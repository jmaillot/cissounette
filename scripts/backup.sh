#!/usr/bin/env bash
# Sauvegarde complète : base de données + fichiers (uploads, plugins, thèmes).
# À exécuter quotidiennement via cron sur le VPS :
#   0 3 * * * /opt/boutique/scripts/backup.sh >> /var/log/boutique-backup.log 2>&1
set -euo pipefail
cd "$(dirname "$0")/.."

BACKUP_DIR="${BACKUP_DIR:-/var/backups/boutique}"
KEEP_DAYS="${KEEP_DAYS:-14}"
STAMP=$(date +%Y-%m-%d_%H%M)
DEST="$BACKUP_DIR/$STAMP"
mkdir -p "$DEST"

# 1. Base de données
docker compose exec -T db mariadb-dump -u"${DB_USER:-wordpress}" \
  -p"${DB_PASSWORD:?DB_PASSWORD manquant}" "${DB_NAME:-wordpress}" \
  | gzip > "$DEST/db.sql.gz"

# 2. Contenu WordPress (uploads, thème, plugins)
docker compose exec -T wordpress tar czf - -C /var/www/html wp-content \
  > "$DEST/wp-content.tar.gz"

# 3. Rétention
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +"$KEEP_DAYS" -exec rm -rf {} +

echo "[$(date)] Sauvegarde OK : $DEST"
