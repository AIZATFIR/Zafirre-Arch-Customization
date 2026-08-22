#!/usr/bin/env bash
set -e

echo "==> 1. Memasang Plymouth..."
pacman -S --noconfirm --needed plymouth

echo "==> 2. Mengonfigurasi HOOKS di /etc/mkinitcpio.conf..."
if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    sed -i 's/HOOKS=(\([^)]*\))/HOOKS=(\1 plymouth)/' /etc/mkinitcpio.conf
    # Clean double spaces
    sed -i 's/  */ /g' /etc/mkinitcpio.conf
fi

echo "==> 3. Memperbarui initramfs (mkinitcpio -P)..."
mkinitcpio -P

echo "==> 4. Membuat service Plymouth Quit Early (3 Detik)..."
cat << 'EOF' > /etc/systemd/system/plymouth-quit-early.service
[Unit]
Description=Quit Plymouth Early to Show Arch Boot Log Text
After=plymouth-start.service
Before=multi-user.target

[Service]
Type=oneshot
ExecStartPre=/usr/bin/sleep 3
ExecStart=/usr/bin/plymouth quit

[Install]
WantedBy=sysinit.target
EOF

echo "==> 5. Mengaktifkan service plymouth-quit-early..."
systemctl enable plymouth-quit-early.service

echo "==> 6. Meng-update opsi Bootloader (/boot/loader/entries/*.conf)..."
sed -i -e 's/\bquiet\b//g' -e 's/\bloglevel=[0-9]\b//g' -e 's/options /options splash systemd.show_status=true /g' /boot/loader/entries/*.conf
# Clean double spaces in options
sed -i 's/[ \t]\+/ /g' /boot/loader/entries/*.conf

echo "==> SUKSES! Pengaturan Plymouth + Logtext Arch Linux selesai dipasang."
echo "Jalankan 'sudo reboot' untuk menguji hasilnya!"
