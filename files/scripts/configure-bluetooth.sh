#!/usr/bin/env sh
set -e

CONFIG_FILE="/etc/bluetooth/main.conf"

echo "Configuring Bluetooth ControllerMode..."

# Verifica se o arquivo existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Bluetooth config not found. Skipping."
    exit 0
fi

# Se já estiver configurado corretamente, não faz nada
if grep -q "^ControllerMode = bredr" "$CONFIG_FILE"; then
    echo "ControllerMode already set to bredr."
    exit 0
fi

# Remove qualquer linha existente de ControllerMode (comentada ou não)
sed -i '/^#\?ControllerMode *=/d' "$CONFIG_FILE"

# Adiciona a configuração no final do arquivo
echo "ControllerMode = bredr" >> "$CONFIG_FILE"

echo "Bluetooth ControllerMode set to bredr."
