#!/usr/bin/env bash
set -e

echo "==> 1. Menghapus Splash Screen Plymouth & Mengembalikan Teks Normal..."
systemctl disable plymouth-quit-early.service 2>/dev/null || true
rm -f /etc/systemd/system/plymouth-quit-early.service
sed -i 's/\bsplash\b//g' /boot/loader/entries/*.conf
sed -i 's/[ \t]\+/ /g' /boot/loader/entries/*.conf

echo "==> 2. Mengatur Timeout Menu Bootloader ke 0 (Skip 3-5 detik)..."
echo "==> 3. Mengatur Ukuran Font Teks Booting Konsisten Kecil (console-mode max)..."
cat << 'EOF' > /boot/loader/loader.conf
default linux-lts.conf
timeout 0
console-mode max
EOF

echo "==> SUKSES! Pengaturan Booting Berhasil Diperbarui."
