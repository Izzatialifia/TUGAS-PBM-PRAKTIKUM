# PBM App 2026 - Tugas Praktikum Pemrograman Berbasis Mobile

Aplikasi Flutter untuk Tugas Praktikum PBM 2026.

## Fitur
- Login dengan NIM & Password
- Katalog Produk (Draft)
- Tambah & Hapus Produk
- Submit Tugas ke server

## Cara Menjalankan

### 1. Clone Repository
```bash
git clone https://github.com/USERNAME/pbm-app-2026.git
cd pbm-app-2026
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Jalankan Aplikasi
```bash
flutter run
```

## Struktur Project
```
lib/
├── main.dart               # Entry point + Splash Screen
├── models/
│   ├── user_model.dart     # Model untuk data user
│   └── product_model.dart  # Model untuk data produk
├── services/
│   ├── auth_service.dart   # Service untuk autentikasi
│   └── product_service.dart # Service untuk manajemen produk
└── screens/
    ├── login_screen.dart      # Halaman login
    ├── home_screen.dart       # Halaman katalog produk
    ├── add_product_screen.dart # Halaman tambah produk
    └── submit_screen.dart     # Halaman submit tugas
```

## Dependencies
- `http` - HTTP requests
- `flutter_secure_storage` - Menyimpan token dengan aman
- `google_fonts` - Typography

## API
Base URL: `https://task.itprojects.web.id`

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | /api/auth/login | Login |
| GET | /api/products | Ambil semua produk |
| POST | /api/products | Tambah produk |
| DELETE | /api/products/:id | Hapus produk |
| POST | /api/products/submit | Submit tugas |
