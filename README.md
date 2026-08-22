# 🌌 Zafirre Arch Customization

> **Complete, Personalized Arch Linux + Hyprland Desktop Environment & Workflows**  
> Custom-crafted for high productivity, aesthetic perfection, AI agent integration, and seamless 1-click system restoration.

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/WM-Hyprland%20v0.56+-blue?logo=hyprland)](https://hyprland.org)
[![Shell](https://img.shields.io/badge/Shell-Fish%204.8-green?logo=fish)](https://fishshell.com)
[![Terminal](https://img.shields.io/badge/Terminal-Kitty-orange?logo=kitty)](https://sw.kovidgoyal.net/kitty/)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

---

## 📖 Apa Itu Zafirre Arch Customization?

**Zafirre Arch Customization** adalah repositori dotfiles & sistem kustomisasi Arch Linux + Hyprland yang dirancang secara menyeluruh dan personal. Repositori ini secara **otomatis memasang Hyprland**, Waybar, Kitty, Fish shell, seluruh dependensi, dan kustomisasi visual dari awal pada instalasi Arch Linux baru.

---

## 🎨 Arsitektur & Fitur Utama (System Overview)

| Komponen | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Window Manager** | **Hyprland** (Wayland) | Tile management dengan animasi smooth, rounded corners, & efek blur kaca. |
| **Status Bar** | **Waybar** | Top bar kustom dengan modul dynamic workspace, media, & notifikasi. |
| **Terminal** | **Kitty** | Terminal GPU-accelerated dengan pintasan opacity (`Ctrl+Shift+1` Dove / `Ctrl+Shift+0` Blur). |
| **Shell** | **Fish Shell** | Interactive shell dengan `animfetch --play` autostart & fungsi `agys` AI picker. |
| **Notifikasi** | **SwayNC / Hyprland Native** | Notifikasi toast native Hyprland & SwayNC control center. |
| **Launcher** | **Rofi / Wofi** | App launcher & clipboard manager (`cliphist`) bergaya modern. |
| **Color System** | **Matugen** | Generator skema warna otomatis berbasis wallpaper. |
| **Wallpapers** | **Custom Collection** | Disimpan di `./wallpapers/` dan otomatis di-restore ke `~/Downloads/Wallpaper/`. |

---

## 🤖 Fitur Spesial & Custom Helper Scripts (`~/.local/bin/`)

### 1. `agys` (Interactive AI Session Picker)
- **Fungsi:** Mengindeks seluruh riwayat sesi percakapan AI dari **AGY CLI**, **Antigravity IDE**, dan **Desktop App**.
- **Fitur Cerdas:** Menampilkan Tanggal + [ID] + Judul Topik Percakapan, serta **otomatis berpindah (`cd`) ke folder proyek asal** sebelum menjalankan AGY CLI!
- **Cara Pakai:**
  ```fish
  agys
  ```

### 2. `fix-bootloader.sh` (Instant & Crisp Boot)
- **Fungsi:** Mengatur `systemd-boot` ke `timeout 0` (booting instan tanpa nunggu menu) dan mengaktifkan `console-mode max` agar ukuran font booting **langsung kecil & konsisten sejak detik pertama**.
- **Cara Pakai:**
  ```bash
  sudo ~/.local/bin/fix-bootloader.sh
  ```

### 3. `setup-boot-plymouth.sh` (Splash Screen + Auto-Logtext)
- **Fungsi:** Mengkonfigurasi Plymouth splash screen di 3 detik awal booting lalu otomatis berpindah ke tampilan logtext status Arch Linux (`[ OK ] Started ...`).
- **Cara Pakai:**
  ```bash
  sudo ~/.local/bin/setup-boot-plymouth.sh
  ```

---

## ⌨️ Shortcut Keyboard Penting (Kitty & Hyprland)

### Terminal Kitty Opacity Controls:
- **`Ctrl + Shift + 1`** ➔ **100% Solid / Full Dove (Opaque)** *(Sangat nyaman untuk membaca kode/teks panjang)*
- **`Ctrl + Shift + 0`** ➔ Reset ke **0.7 (Blur / Transparan Standar)**
- **`Ctrl + Shift + U`** ➔ Menambah ketebalan opacity (+0.1)
- **`Ctrl + Shift + D`** ➔ Menambah transparansi (-0.1)

---

## 🚀 Panduan Instalasi 1-Click (Restore di Computer/Device Baru)

Jika kamu berpindah device atau menginstal ulang Arch Linux minimalis dari awal, jalankan 3 langkah ini. Installer akan **otomatis mengunduh & menginstall Hyprland, Waybar, Kitty, Fish, yay, seluruh paket AUR, wallpaper, dan konfigurasi**:

```bash
# 1. Clone repositori ke home directory
git clone https://github.com/AIZATFIR/Zafirre-Arch-Customization.git ~/dotfiles

# 2. Masuk ke direktori dotfiles
cd ~/dotfiles

# 3. Jalankan auto-installer
./install.sh
```

---

## 📁 Struktur Direktori Repositori

```text
Zafirre-Arch-Customization/
├── .config/                  # Seluruh konfigurasi aplikasi (~/.config)
│   ├── hypr/                 # Hyprland bindings, rules, monitors, animations
│   ├── waybar/               # Waybar layout & styles
│   ├── kitty/                # Kitty terminal config & custom opacity shortcuts
│   ├── fish/                 # Fish config.fish & agys function
│   ├── swaync/               # SwayNC notification styling
│   ├── rofi/                 # Rofi launchers & theme
│   ├── ml4w/                 # ML4W dotfiles settings
│   ├── animfetch/            # Animfetch config & ASCII art
│   ├── fastfetch/            # Fastfetch config
│   ├── matugen/              # Matugen color template generators
│   └── ...                   # GTK-3, GTK-4, Qt6ct, Wlogout, Waypaper
├── .local/
│   └── bin/                  # Custom bash/python helper scripts
├── wallpapers/               # Koleksi wallpaper lengkap (~/Downloads/Wallpaper)
├── pkglist.txt               # Paket resmi pacman (Hyprland, Waybar, Kitty, dll)
├── aurpkglist.txt            # Paket AUR (yay, animfetch, waypaper, wlogout, dll)
├── install.sh                # Script installer otomatis 1-click
├── README.md                 # Dokumentasi lengkap repositori
└── .gitignore                # Filter keamanan data sensitif & log
```

---

