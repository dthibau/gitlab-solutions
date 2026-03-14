#!/bin/bash

# Vérification de l'argument
if [ -z "$1" ]; then
    echo "Usage: $0 <tag_ou_sha1>"
    exit 1
fi

TARGET="../multi-module"
VERSION=$1

# 1. Vérifier si on est bien dans un dépôt Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Erreur : Vous devez exécuter ce script à la racine d'un dépôt Git."
    exit 1
fi

# 2. Effectuer le checkout de la version demandée
echo "Passage sur la version : $VERSION..."
git checkout "$VERSION" --quiet
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de trouver le tag ou SHA1 '$VERSION'."
    exit 1
fi

# 3. Création du répertoire de destination s'il n'existe pas
mkdir -p "$TARGET"

# 4. Copie des fichiers (en excluant .git)
echo "Copie des fichiers vers $TARGET..."
# On utilise rsync car c'est le plus efficace pour exclure des dossiers proprement
rsync -av --progress --exclude='.git' ./ "$TARGET/"

echo "---"
echo "Opération terminée avec succès dans $TARGET"
