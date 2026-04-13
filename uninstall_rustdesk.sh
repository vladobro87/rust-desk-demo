#!/bin/bash

echo "=== RustDesk FULL UNINSTALL START ==="

# Проверка sudo
if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

# Остановка сервисов
echo "[1/6] Stopping services..."
$SUDO systemctl stop rustdesksignal.service 2>/dev/null
$SUDO systemctl stop rustdeskrelay.service 2>/dev/null
$SUDO systemctl stop gohttpserver.service 2>/dev/null

# Отключение автозапуска
echo "[2/6] Disabling services..."
$SUDO systemctl disable rustdesksignal.service 2>/dev/null
$SUDO systemctl disable rustdeskrelay.service 2>/dev/null
$SUDO systemctl disable gohttpserver.service 2>/dev/null

# Удаление systemd сервисов
echo "[3/6] Removing systemd service files..."
$SUDO rm -f /etc/systemd/system/rustdesksignal.service
$SUDO rm -f /etc/systemd/system/rustdeskrelay.service
$SUDO rm -f /etc/systemd/system/gohttpserver.service

# Перезагрузка systemd
$SUDO systemctl daemon-reload

# Удаление файлов RustDesk
echo "[4/6] Removing RustDesk files..."
$SUDO rm -rf /opt/rustdesk

# Удаление HTTP сервера
echo "[5/6] Removing Go HTTP server..."
$SUDO rm -rf /opt/gohttp

# Удаление логов
echo "[6/6] Cleaning logs..."
$SUDO rm -rf /var/log/rustdesk
$SUDO rm -rf /var/log/gohttp

echo "=== Core removal complete ==="

# ОПЦИОНАЛЬНО: удалить пакеты (осторожно!)
read -p "Remove installed packages (curl, wget, unzip, tar, dnsutils)? [y/N]: " remove_pkgs

if [[ "$remove_pkgs" == "y" || "$remove_pkgs" == "Y" ]]; then
    echo "Removing packages..."
    $SUDO apt-get remove --purge -y curl wget unzip tar dnsutils
    $SUDO apt-get autoremove -y
fi

echo "=== DONE ==="
