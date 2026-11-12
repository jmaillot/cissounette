# Boutique Cissounette — WordPress + WooCommerce sur VPS (Docker)

Stack complète, prête à déployer : WordPress, WooCommerce-ready, sauvegardes et déploiement par Git.
Le HTTPS est assuré par le **Traefik déjà présent sur le VPS** : la stack rejoint son réseau
Docker et expose des labels de routage (à adapter : domaine, réseau, resolver — placeholders
`domain.tld` / `proxy` / `le` dans `docker-compose.yml`).

## Structure

```
├── docker-compose.yml          # Stack : WordPress + MariaDB, routage par le Traefik du VPS
├── .env.example                # Secrets à copier en .env (jamais commité)
├── wp-content/themes/cissounette/       # Thème enfant d'Astra (couleurs, marque)
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
nano docker-compose.yml     # adapter les placeholders Traefik : domain.tld, réseau proxy, resolver le

# 3. Pointer le DNS : enregistrement A domaine -> IP du VPS

# 4. Lancer
./scripts/install.sh
```

Traefik (déjà présent sur le VPS) route le domaine vers le conteneur WordPress et obtient
le certificat HTTPS automatiquement dès que le DNS pointe.

## Après l'installation (admin, aucune compétence technique)

1. Ouvrir `https://domain.tld/wp-admin` et finir l'assistant WordPress
2. **Plugins → Ajouter** : installer *WooCommerce* (assistant de config boutique en français) et *WooCommerce Stripe Gateway* (coller les clés API Stripe)
3. **Apparence → Thèmes → Ajouter** : installer le thème **Astra**, puis activer *Cissounette* (thème enfant d'Astra, déjà présent dans le dépôt)
4. **Produits → Ajouter** : titre, description, prix, glisser-déposer les photos
5. **Apparence → Personnaliser → Identité du site** : logo, nom, favicon

## Personnaliser la marque (par l'IA, via Git)

Les couleurs et le style vivent dans `wp-content/themes/cissounette/style.css`
(variables `--boutique-*` en haut du fichier). Modifier → commit → push →
la GitHub Action redéploie en ~30 secondes. Le thème parent **Astra** s'installe
depuis l'admin WordPress (gratuit) ; ce thème enfant n'en surcharge que les couleurs.

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
- [ ] Monitoring : UptimeRobot sur `https://domain.tld`
- [ ] Emails WooCommerce via SMTP externe (plugin WP Mail SMTP + Brevo)
