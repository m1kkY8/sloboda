# Selfhosted wiki and notes stack

- **[Wiki.js](https://js.wiki/)** – Powerful and extensible wiki engine
- **[Trilium Notes](https://github.com/TriliumNext/Notes)** – Hierarchical note-taking app with synchronization

- All services are managed with `docker compose`

## Requirements

- Domain; i got main on [Name.com](https://www.name.com/)
- VPS or any other kind of public facing server; for this i used linode

## Setting up

First of all we need to create a instance our server of choice and add its public ip to the DNS record

After that we can clone the repo on our machine with docker installed

```bash
git clone https://github.com/m1kkY8/sloboda
```

After that we need to populate our .env file with corresponding data

Example of .env file

```
# Certbot
EMAIL=admin@domain.com
ROOT_DOMAIN=domain.com
WIKI_DOMAIN=wiki.domain.com
NOTES_DOMAIN=notes.domain.com

# Wiki
POSTGRES_DB=wikijs
POSTGRES_PASSWORD=S3cureP@ssw0rd
POSTGRES_USER=wikijs_admin


# Trilium
TRILIUM_DATA_DIR=./trilium-data
```

Now we can just

```bash
docker compose up -d
```
