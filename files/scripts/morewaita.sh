#!/usr/bin/env bash
set -e

ICON_DIR="/usr/share/icons"

MOREWAITADIR="$ICON_DIR/MoreWaita"
ADWAITACOLORSDIR="$ICON_DIR"

if [ ! -d "$MOREWAITADIR" ]; then
    echo "Error: MoreWaita not found in $ICON_DIR"
    exit 1
fi

echo "Detecting Adwaita variants..."
adwaita_variants=()

for variant in "$ICON_DIR"/Adwaita-*; do
    if [ -d "$variant" ]; then
        variant_name=$(basename "$variant")
        adwaita_variants+=("$variant_name")
        echo "Found: $variant_name"
    fi
done

if [ ${#adwaita_variants[@]} -eq 0 ]; then
    echo "No Adwaita variants found."
    exit 0
fi

for variant in "${adwaita_variants[@]}"; do
    variant_path="$ICON_DIR/$variant"

    theme_file="$variant_path/index.theme"

    if [ -f "$theme_file" ]; then
        echo "Patching $theme_file"

        sed -i '/^Inherits=/d' "$theme_file"
        sed -i '/\[Icon Theme\]/a Inherits=MoreWaita,Adwaita,AdwaitaLegacy,hicolor' "$theme_file"
    fi

    mkdir -p "$variant_path/scalable/mimes"

    if [ -d "$MOREWAITADIR/scalable/mimetypes" ]; then
        cp -n "$MOREWAITADIR/scalable/mimetypes/"* \
              "$variant_path/scalable/mimetypes/" 2>/dev/null || true
    fi
done

echo "Updating icon caches..."

for variant in "${adwaita_variants[@]}"; do
    gtk-update-icon-cache -f "$ICON_DIR/$variant" || true
done

gtk-update-icon-cache -f "$MOREWAITADIR" || true

echo "Icon patch completed."
