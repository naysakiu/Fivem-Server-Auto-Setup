#!/bin/bash

# Specificațiile pentru folderul și arhiva dorite
FIVEM_SERVER_DIR="/root/fivem-server"
ARCHIVE_NAME="fx.tar.xz"

# Mergi la directorul de lucru
cd "$FIVEM_SERVER_DIR" || exit 1

# Șterge folderul fx existent (dacă există)
if [ -d "$FIVEM_SERVER_DIR/fx" ]; then
    rm -rf "$FIVEM_SERVER_DIR/fx"
    echo "Folderul 'fx' a fost șters."
fi

# Descarcă arhiva
read -p "Artifacts Link? (From https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ ): " artifacts
wget "$artifacts"

# Dezarhivează arhiva
tar -xf "$ARCHIVE_NAME"
echo "Arhiva '$ARCHIVE_NAME' a fost dezarhivată."

# Șterge arhiva descărcată (opțional)
# Poți comenta sau elimina următoarea linie dacă dorești să păstrezi arhiva
rm "$ARCHIVE_NAME"
echo "Arhiva '$ARCHIVE_NAME' a fost ștearsă."

echo "Actualizarea artefactelor FiveM a fost finalizată cu succes."
