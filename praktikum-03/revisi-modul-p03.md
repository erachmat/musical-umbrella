---
title: "Revisi Modul Praktikum 3: DDL, Tipe Data, dan Kunci"
subtitle: "Penyesuaian ke waktu efektif 75 menit"
---

# Bagian 1. Ringkasan untuk dosen

## Masalah

Masalahnya sama dengan modul praktikum 4. Tabel alur kegiatan (bagian 4) menjadwalkan kegiatan untuk 100 menit penuh, sedangkan waktu efektif di kelas hanya 75 menit (07.15–08.30). Langkah A–E (55 menit), demo (15 menit), dan latihan mandiri (15 menit) totalnya 85 menit, ditambah 10 menit persiapan yang biasanya tidak sempat dilakukan saat absensi.

## Perubahan

1. **Langkah A dikerjakan saat absensi** melalui `P03_cek_awal.sql`. Bukti 1 sudah selesai sebelum 07.15. Berkas ini juga langsung memberi tahu apakah `customers` atau indeks unik `sku` sudah ada, sehingga mahasiswa tahu bagian mana yang perlu dilewati (Gambar 4 modul).
2. **Demo dipecah per langkah**: sekitar 5 menit di awal langkah B, lalu sekitar 3 menit di awal langkah C dan D.
3. **Pemeriksaan oleh dosen diganti pemeriksaan mandiri** melalui `P03_cek_mandiri.sql` (8 butir OK/BELUM beserta tindakan).
4. **Pemulihan praktikum 2 tanpa antre** melalui `P03_pulihkan_p2.sql`. Berkas ini hanya membuat `categories` dan `products` beserta datanya. `customers` dan indeks unik `sku` tidak dibuat, karena keduanya adalah pekerjaan praktikum 3.
5. **Latihan mandiri nomor 1, 2, 3, 5 dan refleksi dikerjakan di rumah.** Nomor 4 (`SELECT ... IS NULL`) menjadi tantangan di lab bagi yang selesai lebih dulu.
6. **Waktu cadangan 5 menit** (08.25–08.30).

## Hal yang perlu dosen sesuaikan sebelum membagikan berkas

- Di `P03_pulihkan_p2.sql`, panjang `category_name`, nama produk, dan harga P01–P03 berasal dari praktikum 2 dan masih berupa contoh. Baris yang perlu disesuaikan ditandai `SESUAIKAN P2`. Struktur `products` sudah mengikuti Gambar 1 modul praktikum 3.
- Ketiga berkas sudah diuji pada MariaDB 10.11.14. Alur lengkap juga sudah diuji: pulihkan P2 → langkah B–D praktikum 3 → `P04_cek_awal.sql` semua OK.

# Bagian 2. Teks pengganti untuk modul

## Bagian 2. Peralatan dan persiapan

Ganti paragraf terakhir ("Jika database atau data praktikum 2 belum tersedia...") dengan:

> Dosen membagikan tiga berkas SQL pendukung. Ganti nama database pada baris `USE` di bagian atas setiap berkas sebelum menjalankannya.
>
> | Berkas | Kapan dijalankan |
> |---|---|
> | `P03_cek_awal.sql` | Saat masuk lab, sambil menunggu absensi. Berisi langkah A. |
> | `P03_pulihkan_p2.sql` | Hanya jika cek awal menunjukkan tabel atau data praktikum 2 belum lengkap. |
> | `P03_cek_mandiri.sql` | Setelah langkah D, untuk memeriksa hasil sendiri sebelum menyimpan. |
>
> Jalankan berkas dengan membuka tab SQL di phpMyAdmin, menempelkan seluruh isi berkas, lalu klik **Go**. Jangan menyalin perintah dari PDF jika berkas SQL tersedia, karena tanda kutip dan baris baru dapat berubah saat disalin. Jika izin `CREATE` atau `ALTER` ditolak, panggil dosen.

## Bagian 4. Alur kegiatan: ganti tabel

> | Menit | Jam | Kegiatan | Hasil yang dituju |
> |---|---|---|---|
> | 0–15 | 07.00–07.15 | Absensi. Setelah komputer siap, jalankan `P03_cek_awal.sql` (langkah A). | Bukti 1 tersimpan. STATUS bernilai OK atau INFO. |
> | 15–20 | 07.15–07.20 | Dosen menjelaskan kebutuhan Toko Saku dan tipe data pada bagian 3. | Memahami kolom dan kunci yang akan dibuat. |
> | 20–40 | 07.20–07.40 | Langkah B: demo dosen 5 menit, lalu praktik 15 menit. | Tabel `customers` dibuat. Bukti 2 tersimpan. |
> | 40–55 | 07.40–07.55 | Langkah C: demo dosen 3 menit, lalu praktik 12 menit. | `sku` unik. Bukti 3 tersimpan. |
> | 55–70 | 07.55–08.10 | Langkah D: demo dosen 3 menit, lalu praktik 12 menit. | Tiga pelanggan tersimpan, uji SKU ganda ditolak. |
> | 70–85 | 08.10–08.25 | Langkah E: jalankan `P03_cek_mandiri.sql`, simpan dua berkas SQL. | Semua baris cek mandiri OK. Bukti 4 lengkap. |
> | 85–90 | 08.25–08.30 | Waktu cadangan. Yang sudah selesai mengerjakan latihan mandiri nomor 4. | Mahasiswa yang tertinggal menyelesaikan langkah E. |
> | 90–100 | 08.30–08.40 | Pengumuman laporan dan tugas, simpan berkas, matikan komputer, rapikan meja. | Berkas SQL tersimpan di lokasi yang ditentukan dosen. |
>
> Langkah A dikerjakan saat absensi melalui `P03_cek_awal.sql`. Langkah B sampai E dikerjakan pada menit 20 sampai 85. Latihan mandiri nomor 1, 2, 3, 5 dan pertanyaan refleksi dikerjakan dalam laporan di rumah.

## Bagian 6. Langkah kerja: ubah judul langkah

| Judul lama | Judul baru |
|---|---|
| A. Memeriksa hasil praktikum 2: 10 menit | A. Memeriksa hasil praktikum 2: saat absensi |
| B. Membuat tabel customers: 15 menit | B. Membuat tabel customers: 20 menit |
| C. Menetapkan SKU unik: 10 menit | C. Menetapkan SKU unik: 15 menit |
| D. Mengisi pelanggan dan menguji kunci: 10 menit | D. Mengisi pelanggan dan menguji kunci: 15 menit |
| E. Memeriksa dan menyimpan hasil: 10 menit | E. Memeriksa dan menyimpan hasil: 15 menit |

Tambahkan paragraf berikut di awal langkah A:

> Langkah A sudah tersedia dalam berkas `P03_cek_awal.sql`. Jalankan berkas tersebut segera setelah komputer siap. Blok perintah di langkah A tetap ditampilkan agar kamu dapat membaca isinya.
>
> Lihat dua tabel hasil **STATUS**. Baris bernilai OK berarti sesuai. Baris bernilai **INFO** berarti bagian itu sudah pernah dikerjakan: `customers` sudah ada (periksa di langkah B, jangan buat ulang) atau indeks unik `sku` sudah ada (lewati ALTER di langkah C). Untuk nilai lain, ikuti kolom **tindakan**. Jika muncul error `Table ... doesn't exist`, jalankan `P03_pulihkan_p2.sql`, lalu jalankan cek awal sekali lagi.

Tambahkan paragraf berikut di awal langkah E, sebelum blok pemeriksaan akhir:

> Jalankan `P03_cek_mandiri.sql`. Semua delapan baris harus bernilai OK. Jika ada baris BELUM, kerjakan langkah yang disebut pada kolom tindakan. Panggil dosen hanya jika kolom tindakan memintanya. Tangkapan layar hasil cek mandiri melengkapi Bukti 4.

## Instruksi "minta dosen memeriksa": ganti dengan rujukan ke berkas

| Lokasi di modul lama | Kalimat lama | Kalimat baru |
|---|---|---|
| Langkah A.5 | Jika hasilnya berbeda, minta dosen memeriksa. | Jika hasilnya berbeda, ikuti kolom tindakan pada hasil `P03_cek_awal.sql`. |
| Langkah B | Jika tabel sudah ada, periksa struktur dan isinya bersama dosen. | Jika tabel sudah ada, jalankan `P03_cek_mandiri.sql`. Baris 2 dan 3 harus OK. Jika CEK, panggil dosen. |
| Langkah C, butir pertama | Jika pemeriksaan duplikasi menampilkan baris, jangan jalankan ALTER. Minta dosen memeriksa data tersebut. | *(tetap: kasus ini memang perlu dosen)* |
| Langkah D, sebelum INSERT | Jika data baru terisi sebagian atau berbeda, minta dosen memeriksa. | *(tetap)* |
| Langkah D, sebelum uji | Jika ID 99 ditemukan, minta dosen memeriksa sebelum meneruskan uji. | *(tetap; cek awal sudah menandainya sebagai MASALAH)* |
| Bagian 9, baris "customers sudah ada" | Jika struktur atau isinya berbeda, minta dosen memeriksa. | Jalankan `P03_cek_mandiri.sql`. Jika baris 2 atau 5 bukan OK, panggil dosen. |
| Bagian 9, baris "products atau customers tidak ditemukan" | Minta bantuan dosen jika data lama belum tersedia. | Jika `products` belum tersedia, jalankan `P03_pulihkan_p2.sql`. Jika `customers` belum tersedia, kerjakan langkah B. |

## Bagian 7. Latihan mandiri: ganti kalimat pembuka

> Latihan nomor 4 dikerjakan di lab jika langkah E sudah selesai dan semua baris `P03_cek_mandiri.sql` bernilai OK. Jika waktu di lab tidak cukup, nomor 4 boleh dikerjakan di rumah selama database latihan masih dapat diakses, atau ditulis sebagai rancangan query tanpa hasil eksekusi.
>
> Nomor 1, 2, 3, dan 5 dijawab dalam laporan yang dikerjakan di rumah, masing-masing 2–4 kalimat. Dosen dapat meminta kamu menjelaskan jawaban tersebut pada pertemuan berikutnya. Pertahankan data contoh untuk pertemuan berikutnya.

## Bagian 8. Lembar kerja mahasiswa: tambahkan kalimat sebelum pertanyaan refleksi

> Pertanyaan refleksi dijawab di rumah sebagai bagian dari laporan.

## Bagian 10. Hasil yang dikumpulkan: ganti kalimat pembuka

> Dua berkas SQL (nomor 1) disimpan di lokasi yang ditentukan dosen sebelum komputer lab dimatikan. Laporan (nomor 2) dikumpulkan paling lambat pada batas waktu yang diumumkan dosen di akhir sesi.

## Bagian 11. Daftar pemeriksaan: tambahkan butir

> ☐ Semua baris `P03_cek_mandiri.sql` bernilai OK, dan tangkapan layarnya ada di Bukti 4.

# Bagian 3. Panduan sesi untuk dosen

## Sebelum hari praktikum

- Sesuaikan baris bertanda `SESUAIKAN P2` di `P03_pulihkan_p2.sql`, lalu letakkan ketiga berkas SQL di folder bersama lab, LMS, atau flashdisk.
- Opsional: rekam layar 5–8 menit saat dosen mengerjakan langkah B sampai D, lalu unggah ke LMS.

## Tampilan di proyektor pada setiap tahap

| Jam | Teks di proyektor |
|---|---|
| 07.00 | **Sudah absen? Buka phpMyAdmin → tab SQL → jalankan `P03_cek_awal.sql`. Screenshot = Bukti 1.** |
| 07.15 | **STATUS harus OK atau INFO. Ada error tabel tidak ada → jalankan `P03_pulihkan_p2.sql`.** |
| 07.20 | **Sekarang: Langkah B (customers). Target selesai 07.40.** |
| 07.40 | **Sekarang: Langkah C (SKU unik). Cek duplikasi dulu. Target selesai 07.55.** |
| 07.55 | **Sekarang: Langkah D. INSERT uji dijalankan terpisah. Target selesai 08.10.** |
| 08.10 | **Sekarang: Langkah E. Jalankan `P03_cek_mandiri.sql`, simpan dua berkas SQL.** |
| 08.25 | **Sudah semua OK? Kerjakan latihan nomor 4. Belum? Selesaikan langkah E.** |
| 08.30 | **Simpan berkas. Pengumuman laporan dan tugas.** |

## Selama praktik

- Pada setiap pergantian langkah, minta mahasiswa yang belum selesai mengangkat tangan sebentar. Jika lebih dari sepertiga kelas belum selesai, tambahkan 3–5 menit dari waktu cadangan.
- Arahkan pertanyaan rutin ke hasil cek mandiri dulu: "Baris mana yang belum OK? Apa tindakannya?"
- Kesalahan yang paling mungkin muncul di P3 adalah email Bima ditulis `'NULL'` atau `''`. Baris 6 cek mandiri menangkap kesalahan ini, dan sekaligus menjadi bahan bagus untuk latihan mandiri nomor 3.
