# Boutique Artisanale — WordPress + WooCommerce sur VPS (Docker)

Stack complète, prête à déployer : WordPress, WooCommerce-ready, HTTPS automatique via Caddy, sauvegardes et déploiement par Git.

## Structure

```
├── docker-compose.yml          # Stack : Caddy + WordPress + MariaDB
├── caddy/Caddyfile             # HTTPS auto (Let's Encrypt) — remplacez le domaine
├── .env.example                # Secrets à copier en .env (jamais commité)
├── wp-content/themes/boutique-enfant/   # Thème enfant (couleurs, marque)
├── scripts/
│   ├── install.sh              # Premier lancement sur le VPS
│   └── backup.sh               # Sauvegarde quotidienne (cron)
└── .github/workflows/deploy.yml         # Déploy auto à chaque push sur main
```

## Déploiement sur le VPS (Ubuntu 24.04)

```bash
# 1. Docker (si pas déjà installé)
curl -fsSL https://get.docker.com | sh

# 2. Cloner le dépôt et configurer
git clone https://github.com/<vous>/boutique-artisanale.git /opt/boutique
cd /opt/boutique
cp .env.example .env        # remplir les mots de passe !
nano .env
nano caddy/Caddyfile        # mettre votre vrai domaine

# 3. Pointer le DNS : enregistrement A domaine -> IP du VPS

# 4. Lancer
./scripts/install.sh
```

Caddy obtient et renouvelle le certificat HTTPS **automatiquement** dès que le DNS pointe.

## Après l'installation (admin, aucune compétence technique)

1. Ouvrir `https://votre-domaine.fr/wp-admin` et finir l'assistant WordPress
2. **Plugins → Ajouter** : installer *WooCommerce* (assistant de config boutique en français) et *WooCommerce Stripe Gateway* (coller les clés API Stripe)
3. **Apparence → Thèmes** : activer *Boutique Artisanale — Enfant Storefront* (il faut aussi Storefront, installé automatiquement avec WooCommerce)
4. **Produits → Ajouter** : titre, description, prix, glisser-déposer les photos
5. **Apparence → Personnaliser → Identité du site** : logo, nom, favicon

## Personnaliser la marque (par l'IA, via Git)

Les couleurs et le style vivent dans `wp-content/themes/boutique-enfant/style.css`
(variables `--boutique-*` en haut du fichier). Modifier → commit → push →
la GitHub Action redéploie en ~30 secondes.

Le **logo**, lui, se charge dans l'admin WordPress (Apparence → Personnaliser) :
c'est du contenu, pas du code.

## Sauvegardes

```bash
# Cron sur le VPS (crontab -e) :
0 3 * * * cd /opt/boutique && ./scripts/backup.sh
```

Garde une copie externe : snapshot VPS chez l'hébergeur + copie du dossier
`/var/backups/boutique` vers un stockage externe (rclone vers S3/Backblaze).

## Checklist sécurité VPS

- [ ] SSH par clé uniquement (`PasswordAuthentication no`)
- [ ] UFW : ouvrir uniquement 22, 80, 443
- [ ] `apt update && apt upgrade` régulier (ou `unattended-upgrades`)
- [ ] Plugin Wordfence côté WordPress
- [ ] Monitoring : UptimeRobot sur `https://votre-domaine.fr`
- [ ] Emails WooCommerce via SMTP externe (plugin WP Mail SMTP + Brevo)
