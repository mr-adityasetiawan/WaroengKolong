# Requirement MVP Waroeng Kolong App

## Prinsip produk

- 1 aplikasi dulu, tampilan berubah sesuai role login.
- Customer fokus ke order cepat.
- POS fokus ke antrean order dan status masakan.
- Admin fokus ke menu, staf, dan laporan sederhana.
- Build Android dilakukan oleh GitHub Actions supaya VPS tidak terbebani.

## Role dan fitur

### Customer

- Melihat kategori menu.
- Melihat harga nyata, bukan placeholder.
- Menambahkan item ke keranjang.
- Mengisi atas nama dan nomor HP.
- Memilih mode `Ambil di stan` atau `Makan di tempat`.
- Submit order dan menerima kode order.
- Melihat status order.

### POS Staff

- Melihat semua order aktif.
- Membuka detail order.
- Mengecek catatan item.
- Mengubah status order.
- Menandai order siap diambil atau selesai.

### Admin

- Mengaktifkan/nonaktifkan menu tersedia.
- Melihat daftar staf awal.
- Melihat ringkasan omzet/order.

## Status order

- `baru`: order baru masuk.
- `dibayar`: pembayaran sudah dikonfirmasi.
- `diproses`: order sedang dibuat.
- `siap_diambil`: order siap diserahkan.
- `selesai`: order selesai.
- `batal`: order dibatalkan.

## Tahap berikutnya

1. Sambungkan Flutter ke backend API.
2. Tambahkan database SQLite/Postgres di backend.
3. Tambahkan auth real untuk customer/staff/admin.
4. Tambahkan QRIS manual/upload bukti bayar.
5. Tambahkan notifikasi status order.
6. Siapkan release APK/AAB signing di GitHub Actions.
