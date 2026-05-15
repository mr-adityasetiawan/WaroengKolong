# Waroeng Kolong App MVP

## Tujuan

Aplikasi Android Waroeng Kolong dibuat untuk mempercepat order pelanggan dan operasional POS di stan.

## Role dalam 1 aplikasi

- **Customer**: pilih menu, masuk keranjang, submit order, dapat kode order seperti `WK-002` dan atas nama.
- **POS Staff**: melihat order masuk, memproses pembayaran manual/QRIS, update status order.
- **Admin/Owner**: kelola ketersediaan menu, user staf, dan ringkasan penjualan.

## Alur MVP

1. Pelanggan memilih menu.
2. Pelanggan mengisi atas nama dan nomor HP.
3. Pelanggan submit order.
4. App membuat kode order.
5. Pelanggan datang ke stan dan menyebut kode + atas nama.
6. POS staff mencari order dan mengubah status:
   - `Baru`
   - `Dibayar`
   - `Diproses`
   - `Siap Diambil`
   - `Selesai`
   - `Batal`

## Struktur repo

```text
mobile/                 Flutter Android app
backend/                Minimal Node.js API MVP
.github/workflows/      GitHub Actions build APK
docs/                   Dokumen requirement dan API
```

## Build Android via GitHub Actions

Workflow `.github/workflows/android-ci.yml` akan menjalankan:

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- upload artifact `waroengkolong-debug-apk`

Debug APK dipakai dulu agar CI bisa langsung menghasilkan file instalasi untuk testing internal tanpa perlu keystore. Untuk release/Play Store, nanti tambahkan signing secret GitHub.

## Backend lokal

```bash
cd backend
npm test
npm start
```

Health check:

```bash
curl http://localhost:8080/api/health
```

Endpoint awal:

- `GET /api/health`
- `GET /api/menu`
- `GET /api/orders`
- `POST /api/orders`
- `PATCH /api/orders/:idOrCode/status`
