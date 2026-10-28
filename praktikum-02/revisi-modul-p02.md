---
title: "Revisi Modul Praktikum 2: Membuat Tabel Toko Saku"
subtitle: "Penyesuaian ke waktu efektif 75 menit"
---

# Bagian 1. Ringkasan untuk dosen

## Masalah

Masalahnya sama dengan modul praktikum 3 dan 4. Tabel alur kegiatan (bagian 4) menjadwalkan kegiatan untuk 100 menit penuh, sedangkan waktu efektif di kelas hanya 75 menit (07.15–08.30).

## Perubahan

1. **Langkah A dikerjakan saat absensi** melalui `P02_cek_awal.sql`. Berkas ini mencatat `DATABASE()` dan `VERSION()` untuk lembar kerja, lalu memberi tahu apakah `categories` atau `products` sudah pernah dibuat.
2. **Demo dipecah per langkah**: sekitar 5 menit di awal langkah B, lalu sekitar 3 menit di awal langkah C dan D.
3. **Pemeriksaan oleh dosen diganti pemeriksaan mandiri** melalui `P02_cek_mandiri.sql` (9 butir OK/BELUM beserta tindakan). Berkas ini juga dipakai saat tabel sudah ada atau saat INSERT berhenti di tengah, dua situasi yang di modul lama meminta mahasiswa "memeriksa bersama dosen".
4. **Latihan mandiri nomor 1, 2, 3, 5 dan refleksi dikerjakan di rumah.** Jawaban nomor 1 dan 5 dapat diambil dari Bukti 3 dan berkas SQL. Nomor 4 (`SELECT ... ORDER BY sku`) menjadi tantangan di lab bagi yang selesai lebih dulu.
5. **Waktu cadangan 5 menit** (08.25–08.30).

Praktikum 2 tidak memerlukan berkas pemulihan, karena kondisi awalnya hanya database kosong dari praktikum 1.

## Salah ketik di modul yang perlu diperbaiki

| Lokasi | Tertulis | Seharusnya |
|---|---|---|
| Halaman 4, blok SQL langkah B (CREATE TABLE categories) | `USE pbd_latihan_Ap01;` | `USE pbd_latihan_p01;` |
| Halaman 5, sebelum blok CREATE TABLE products | Teks "AA" di atas blok SQL | Dihapus |

Salah ketik pertama perlu diperbaiki sebelum modul dibagikan. Mahasiswa yang menyalin blok itu tanpa mengganti nama database akan mendapat error `Unknown database 'pbd_latihan_ap01'`.

## Berkas pendukung

- Ketiga paket (P2, P3, P4) sudah diuji berurutan pada MariaDB 10.11.14 dengan perintah persis dari modul: P2 langkah B–C → `P02_cek_mandiri.sql` semua OK → `P03_cek_awal.sql` semua OK → P3 langkah B–D → `P03_cek_mandiri.sql` semua OK → `P04_cek_awal.sql` semua OK → P4 langkah C–D → `P04_cek_mandiri.sql` semua OK.
- Hasil `P03_pulihkan_p2.sql` lolos `P02_cek_mandiri.sql`, dan hasil `P04_pulihkan_p3.sql` lolos `P02_cek_mandiri.sql` serta `P03_cek_mandiri.sql`. Artinya, data hasil pemulihan sama dengan data yang dihasilkan modul.

# Bagian 2. Teks pengganti untuk modul

## Bagian 2. Peralatan dan persiapan

Tambahkan paragraf berikut sebelum paragraf terakhir:

> Dosen membagikan dua berkas SQL pendukung. Ganti nama database pada baris `USE` di bagian atas setiap berkas sebelum menjalankannya.
>
> | Berkas | Kapan dijalankan |
> |---|---|
> | `P02_cek_awal.sql` | Saat masuk lab, sambil menunggu absensi. Berisi langkah A. |
> | `P02_cek_mandiri.sql` | Setelah langkah D. Juga dijalankan jika tabel sudah ada atau INSERT berhenti di tengah. |
>
> Jalankan berkas dengan membuka tab SQL di phpMyAdmin, menempelkan seluruh isi berkas, lalu klik **Go**. Jangan menyalin perintah dari PDF jika berkas SQL tersedia, karena tanda kutip dan baris baru dapat berubah saat disalin.

## Bagian 4. Alur kegiatan: ganti tabel

> | Menit | Jam | Kegiatan | Hasil yang dituju |
> |---|---|---|---|
> | 0–15 | 07.00–07.15 | Absensi. Setelah komputer siap, jalankan `P02_cek_awal.sql` (langkah A). | Nama database dan versi server tercatat. |
> | 15–20 | 07.15–07.20 | Dosen menjelaskan dua tabel Toko Saku (Gambar 1 dan bagian 3). | Kegunaan setiap tabel dan kolom diketahui. |
> | 20–40 | 07.20–07.40 | Langkah B: demo dosen 5 menit, lalu praktik 15 menit. | Dua tabel dibuat. Bukti 1 tersimpan. |
> | 40–55 | 07.40–07.55 | Langkah C: demo dosen 3 menit, lalu praktik 12 menit. | Dua kategori dan tiga produk tersimpan. Bukti 2 tersimpan. |
> | 55–70 | 07.55–08.10 | Langkah D: demo dosen 3 menit, lalu praktik 12 menit. | Bukti 3 dan Bukti 4 tersimpan. |
> | 70–85 | 08.10–08.25 | Langkah E: jalankan `P02_cek_mandiri.sql`, simpan berkas SQL. | Semua baris cek mandiri OK. Berkas `.sql` tersimpan. |
> | 85–90 | 08.25–08.30 | Waktu cadangan. Yang sudah selesai mengerjakan latihan mandiri nomor 4. | Mahasiswa yang tertinggal menyelesaikan langkah E. |
> | 90–100 | 08.30–08.40 | Pengumuman laporan dan tugas, simpan berkas, matikan komputer, rapikan meja. | Berkas SQL tersimpan di lokasi yang ditentukan dosen. |
>
> Langkah A dikerjakan saat absensi melalui `P02_cek_awal.sql`. Langkah B sampai E dikerjakan pada menit 20 sampai 85. Latihan mandiri nomor 1, 2, 3, 5 dan pertanyaan refleksi dikerjakan dalam laporan di rumah.

## Bagian 6. Langkah kerja: ubah judul langkah

| Judul lama | Judul baru |
|---|---|
| A. Memilih database dan membaca rancangan: 10 menit | A. Memilih database dan membaca rancangan: saat absensi |
| B. Membuat dua tabel: 15 menit | B. Membuat dua tabel: 20 menit |
| C. Memasukkan data sintetis: 10 menit | C. Memasukkan data sintetis: 15 menit |
| D. Memeriksa struktur dan isi: 10 menit | D. Memeriksa struktur dan isi: 15 menit |
| E. Menyimpan SQL dan menjelaskan hasil: 10 menit | E. Menyimpan SQL dan menjelaskan hasil: 15 menit |

Ganti langkah A nomor 5 dengan:

> 5. Jalankan `P02_cek_awal.sql` pada tab SQL. Blok berikut adalah isi utama berkas tersebut. Periksa `database_aktif` dan lihat tabel hasil **STATUS**. Jika `categories` dan `products` bernilai OK, berarti kedua tabel belum ada, dan kamu dapat lanjut ke langkah B. Jika bernilai **INFO**, berarti tabel sudah pernah dibuat. Jalankan `P02_cek_mandiri.sql` untuk melihat bagian mana yang sudah selesai, lalu lewati perintah yang barisnya sudah OK.

Tambahkan paragraf berikut di awal langkah E:

> Jalankan `P02_cek_mandiri.sql`. Semua sembilan baris harus bernilai OK. Jika ada baris BELUM, kerjakan langkah yang disebut pada kolom tindakan. Panggil dosen hanya jika kolom tindakan memintanya.

## Instruksi "minta dosen memeriksa": ganti dengan rujukan ke berkas

| Lokasi di modul lama | Kalimat lama | Kalimat baru |
|---|---|---|
| Bagian 5, aturan 3 | Jika menemukan tabel lama, minta dosen memeriksanya sebelum melanjutkan. | Jika menemukan tabel lama, jalankan `P02_cek_mandiri.sql` sebelum melanjutkan. |
| Langkah A.5 | Jika categories atau products sudah ada, minta dosen memeriksa tabel tersebut sebelum langkah B. | *(sudah tercakup dalam teks pengganti langkah A.5 di atas)* |
| Langkah B, setelah CREATE products | Jika muncul peringatan bahwa tabel sudah ada, periksa bersama dosen. | Jika muncul peringatan bahwa tabel sudah ada, jalankan `P02_cek_mandiri.sql`. Jika baris 2, 3, atau 4 bernilai CEK, panggil dosen. |
| Langkah C, setelah INSERT products | Jika proses berhenti di tengah, lihat isi kedua tabel bersama dosen sebelum melanjutkan. | Jika proses berhenti di tengah, jalankan `P02_cek_mandiri.sql`. Baris 5 sampai 9 menunjukkan data yang sudah dan belum tersimpan. |
| Bagian 9, baris "Tabel sudah ada" | Lihat struktur dan data bersama dosen. | Jalankan `P02_cek_mandiri.sql`. Panggil dosen jika baris 2, 3, atau 4 bernilai CEK. |
| Bagian 9, baris "Kolom atau jumlah nilai tidak sesuai" | Jika struktur berbeda dari contoh, minta dosen memeriksanya. | *(tetap)* |

## Bagian 7. Latihan mandiri: ganti kalimat pembuka

> Latihan nomor 4 dikerjakan di lab jika langkah E sudah selesai dan semua baris `P02_cek_mandiri.sql` bernilai OK. Jika waktu di lab tidak cukup, nomor 4 boleh dikerjakan di rumah selama database latihan masih dapat diakses, atau ditulis sebagai rancangan query tanpa hasil eksekusi.
>
> Nomor 1, 2, 3, dan 5 dijawab dalam laporan yang dikerjakan di rumah. Gunakan tangkapan layar Bukti 3 untuk nomor 1 dan berkas SQL untuk nomor 5. Jangan menambah atau mengubah data contoh. Dosen dapat meminta kamu menjelaskan jawaban tersebut pada pertemuan berikutnya.

## Bagian 8. Lembar kerja mahasiswa: tambahkan kalimat sebelum pertanyaan refleksi

> Pertanyaan refleksi dijawab di rumah sebagai bagian dari laporan.

## Bagian 10. Hasil yang dikumpulkan: ganti kalimat pembuka

> Berkas SQL (nomor 1) disimpan di lokasi yang ditentukan dosen sebelum komputer lab dimatikan. Laporan (nomor 2) dikumpulkan paling lambat pada batas waktu yang diumumkan dosen di akhir sesi.

## Bagian 11. Daftar pemeriksaan: tambahkan butir

> ☐ Semua baris `P02_cek_mandiri.sql` bernilai OK.

# Bagian 3. Panduan sesi untuk dosen

## Sebelum hari praktikum

- Perbaiki dua salah ketik pada Bagian 1.
- Letakkan kedua berkas SQL di folder bersama lab, LMS, atau flashdisk.
- Opsional: rekam layar 5–8 menit saat dosen mengerjakan langkah B sampai D, lalu unggah ke LMS.

## Tampilan di proyektor pada setiap tahap

| Jam | Teks di proyektor |
|---|---|
| 07.00 | **Sudah absen? Buka phpMyAdmin → tab SQL → jalankan `P02_cek_awal.sql`. Catat DATABASE() dan VERSION().** |
| 07.15 | **Tabel sudah ada (INFO)? Jalankan `P02_cek_mandiri.sql` dulu.** |
| 07.20 | **Sekarang: Langkah B (CREATE TABLE). Target selesai 07.40.** |
| 07.40 | **Sekarang: Langkah C (INSERT). Kategori dulu, baru produk. Target selesai 07.55.** |
| 07.55 | **Sekarang: Langkah D (DESCRIBE dan SELECT). Target selesai 08.10.** |
| 08.10 | **Sekarang: Langkah E. Jalankan `P02_cek_mandiri.sql`, simpan berkas .sql.** |
| 08.25 | **Sudah semua OK? Kerjakan latihan nomor 4. Belum? Selesaikan langkah E.** |
| 08.30 | **Simpan berkas. Pengumuman laporan dan tugas.** |

## Selama praktik

- Pada setiap pergantian langkah, minta mahasiswa yang belum selesai mengangkat tangan sebentar. Jika lebih dari sepertiga kelas belum selesai, tambahkan 3–5 menit dari waktu cadangan.
- Arahkan pertanyaan rutin ke hasil cek mandiri dulu: "Baris mana yang belum OK? Apa tindakannya?"
- P2 adalah pertemuan pertama mahasiswa menulis `CREATE TABLE` dan `INSERT`, sehingga kesalahan sintaks (koma, kutip) paling banyak muncul di langkah B dan C. Demo 5 menit di awal langkah B sebaiknya memperlihatkan satu error 1064 dan cara membacanya.
