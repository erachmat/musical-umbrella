---
title: "Revisi Modul Praktikum 4: Constraint dan Foreign Key"
subtitle: "Penyesuaian ke waktu efektif 75 menit"
---

# Bagian 1. Ringkasan untuk dosen

## Masalah

Modul saat ini menjadwalkan kegiatan dalam 100 menit penuh. Waktu yang benar-benar tersedia di kelas lebih pendek:

| Komponen | Modul lama | Kenyataan di kelas |
|---|---|---|
| Pembukaan (absensi, menyiapkan komputer) | 10 menit | 15 menit (07.00–07.15) |
| Penutup (pengumuman, simpan, matikan komputer) | 5 menit | 10 menit (08.30–08.40) |
| Materi dan praktik | 85 menit | **75 menit** |

Selain itu, pemeriksaan database (menit 0–10) di modul lama biasanya tidak sempat dilakukan selama absensi. Jadi sekitar 95 menit isi harus masuk ke 75 menit. Modul lama juga memuat sekitar sepuluh instruksi "minta dosen memeriksa", yang membuat mahasiswa antre ke dosen saat praktik.

## Perubahan

1. **Langkah A dan B dikerjakan saat absensi.** Keduanya digabung menjadi satu berkas, `P04_cek_awal.sql`, yang dijalankan mahasiswa begitu komputer siap. Bukti 1 sudah selesai sebelum 07.15.
2. **Demo dipecah per langkah.** Demo 15 menit di awal diganti dengan demo singkat sekitar 5 menit di awal langkah C dan langkah D, masing-masing langsung diikuti praktik.
3. **Pemeriksaan oleh dosen diganti pemeriksaan mandiri.** `P04_cek_mandiri.sql` menampilkan daftar OK/BELUM beserta tindakannya. Mahasiswa memanggil dosen hanya jika kolom tindakan memintanya.
4. **Pemulihan praktikum 3 tanpa antre.** Mahasiswa yang tabel atau data praktikum 3-nya belum lengkap menjalankan `P04_pulihkan_p3.sql`. Berkas ini tidak menghapus atau mengubah data yang sudah ada.
5. **Pertanyaan yang tidak butuh komputer lab dipindah ke rumah.** Latihan mandiri nomor 1, 2, 3, 5 dan tiga pertanyaan refleksi dikerjakan dalam laporan di rumah. Latihan nomor 4 tetap di lab sebagai tantangan bagi yang selesai lebih dulu.
6. **Ada waktu cadangan 5 menit** (08.25–08.30) untuk mahasiswa yang tertinggal.

## Hal yang perlu dosen sesuaikan sebelum membagikan berkas

- Pada `P04_pulihkan_p3.sql`, sesuaikan nama produk, harga, panjang `VARCHAR`, tipe `stock_qty`, dan data pelanggan dengan **modul praktikum 3**. Nilai yang ada sekarang disusun dari isi modul praktikum 4 saja (kategori 1 Minuman dan 2 Roti, produk P01–P03 dengan stok 20, 15, 30, tiga pelanggan `example.com`).
- Jika lab memakai nama database berbeda untuk setiap mahasiswa, mahasiswa cukup mengganti satu baris `USE` di bagian atas setiap berkas.
- Ketiga berkas sudah diuji pada MariaDB 10.11.14 (versi yang sama dengan gambar di modul). Query memakai `information_schema` yang juga tersedia di MariaDB 10.4 (XAMPP) dan MySQL 8.0.16 ke atas.

# Bagian 2. Teks pengganti untuk modul

Teks di bawah dapat ditempel langsung ke modul. Nomor bagian mengikuti modul lama.

## Bagian 2. Peralatan dan persiapan: tambahkan paragraf berikut

> Dosen membagikan tiga berkas SQL pendukung. Ganti nama database pada baris `USE` di bagian atas setiap berkas sebelum menjalankannya.
>
> | Berkas | Kapan dijalankan |
> |---|---|
> | `P04_cek_awal.sql` | Saat masuk lab, sambil menunggu absensi. Berisi langkah A dan B. |
> | `P04_pulihkan_p3.sql` | Hanya jika cek awal menunjukkan tabel atau data praktikum 3 belum lengkap. |
> | `P04_cek_mandiri.sql` | Setelah langkah D, untuk memeriksa hasil sendiri sebelum menyimpan. |
>
> Jalankan berkas dengan membuka tab SQL di phpMyAdmin, menempelkan seluruh isi berkas, lalu klik **Go**. Jangan menyalin perintah dari PDF jika berkas SQL tersedia, karena tanda kutip dan baris baru dapat berubah saat disalin.

## Bagian 4. Alur kegiatan: ganti Tabel 2 dan paragraf di bawahnya

> Tabel 2. Alur kegiatan selama 100 menit (contoh untuk kelas pukul 07.00).
>
> | Menit | Jam | Kegiatan | Hasil yang dituju |
> |---|---|---|---|
> | 0–15 | 07.00–07.15 | Absensi. Setelah komputer siap, jalankan `P04_cek_awal.sql` (langkah A dan B). | Bukti 1 tersimpan. Semua baris STATUS bernilai OK. |
> | 15–20 | 07.15–07.20 | Penjelasan tujuan, foreign key, dan `CHECK` oleh dosen. | Memahami dua aturan yang akan ditambahkan. |
> | 20–40 | 07.20–07.40 | Langkah C: demo dosen 5 menit, lalu praktik 15 menit. | Foreign key dan `CHECK` terpasang. Bukti 2 tersimpan. |
> | 40–70 | 07.40–08.10 | Langkah D: demo dosen 5 menit, lalu praktik 25 menit. | Data valid bertambah, dua uji ditolak. |
> | 70–85 | 08.10–08.25 | Langkah E: jalankan `P04_cek_mandiri.sql`, simpan dua berkas SQL. | Semua baris cek mandiri OK. Bukti 3 lengkap. |
> | 85–90 | 08.25–08.30 | Waktu cadangan. Yang sudah selesai mengerjakan latihan mandiri nomor 4. | Mahasiswa yang tertinggal menyelesaikan langkah E. |
> | 90–100 | 08.30–08.40 | Pengumuman laporan dan tugas, simpan berkas, matikan komputer, rapikan meja. | Berkas SQL tersimpan di lokasi yang ditentukan dosen. |
>
> Langkah A dan B dikerjakan saat absensi melalui `P04_cek_awal.sql`. Langkah C sampai E dikerjakan pada menit 20 sampai 85. Latihan mandiri nomor 1, 2, 3, 5 dan pertanyaan refleksi dikerjakan dalam laporan di rumah.

## Bagian 6. Langkah kerja: ubah judul langkah

| Judul lama | Judul baru |
|---|---|
| A. Memeriksa hasil praktikum 3: 10 menit | A. Memeriksa hasil praktikum 3: saat absensi |
| B. Memeriksa data dan constraint: 10 menit | B. Memeriksa data dan constraint: saat absensi |
| C. Menambahkan aturan integritas: 10 menit | C. Menambahkan aturan integritas: 20 menit |
| D. Mengisi data valid dan menguji aturan: 15 menit | D. Mengisi data valid dan menguji aturan: 30 menit |
| E. Memeriksa dan menyimpan hasil: 10 menit | E. Memeriksa dan menyimpan hasil: 15 menit |

Tambahkan paragraf berikut di awal langkah A:

> Langkah A dan B sudah tersedia dalam berkas `P04_cek_awal.sql`. Jalankan berkas tersebut segera setelah komputer siap. Blok perintah di langkah A dan B tetap ditampilkan agar kamu dapat membaca isinya.
>
> Lihat tabel hasil **STATUS**. Jika semua baris bernilai OK, lanjutkan ke langkah C saat dosen memulai demo. Jika ada baris yang bukan OK, ikuti kolom **tindakan**. Jika muncul error `Table ... doesn't exist`, jalankan `P04_pulihkan_p3.sql`, lalu jalankan cek awal sekali lagi.

Tambahkan paragraf berikut di awal langkah E, sebelum blok pemeriksaan akhir:

> Jalankan `P04_cek_mandiri.sql`. Semua delapan baris harus bernilai OK. Jika ada baris BELUM, kerjakan langkah yang disebut pada kolom tindakan. Panggil dosen hanya jika kolom tindakan memintanya. Tangkapan layar hasil cek mandiri melengkapi Bukti 3.

## Instruksi "minta dosen memeriksa": ganti dengan rujukan ke berkas

| Lokasi di modul lama | Kalimat lama | Kalimat baru |
|---|---|---|
| Langkah A.5 | Jika hasil berbeda, minta dosen memeriksa sebelum mengubah tabel. | Jika hasil berbeda, ikuti kolom tindakan pada hasil `P04_cek_awal.sql`. |
| Langkah B | Jika dua query pertama menemukan baris bermasalah, minta dosen meninjau datanya sebelum menjalankan ALTER. | Jika STATUS menunjukkan MASALAH, jangan jalankan ALTER. Panggil dosen. *(tetap: kasus ini memang perlu dosen)* |
| Bagian 2, paragraf terakhir | Jika tabel hasil praktikum 3 belum tersedia ..., minta dosen memeriksa sebelum melanjutkan. | Jika tabel hasil praktikum 3 belum tersedia, jalankan `P04_pulihkan_p3.sql`. Jika izin `ALTER` ditolak, panggil dosen. |
| Langkah D, sebelum INSERT | Jika baru sebagian atau nilainya berbeda, minta dosen memeriksa. | *(tetap: kasus ini memang perlu dosen)* |
| Langkah D, sebelum uji | Jika ada baris yang tampil, minta dosen memeriksa. | *(tetap)* |

Instruksi yang ditandai *tetap* menyangkut data yang tidak sesuai harapan. Kasus seperti ini jarang terjadi sehingga tidak menimbulkan antrean.

## Bagian 7. Latihan mandiri: ganti kalimat pembuka

> Latihan nomor 4 dikerjakan di lab jika langkah E sudah selesai dan semua baris `P04_cek_mandiri.sql` bernilai OK. Jika waktu di lab tidak cukup, nomor 4 boleh dikerjakan di rumah selama database latihan masih dapat diakses, atau ditulis sebagai rancangan query tanpa hasil eksekusi.
>
> Nomor 1, 2, 3, dan 5 dijawab dalam laporan yang dikerjakan di rumah. Dosen dapat meminta kamu menjelaskan jawaban tersebut pada pertemuan berikutnya.

## Bagian 8. Lembar kerja mahasiswa: tambahkan kalimat sebelum pertanyaan refleksi

> Pertanyaan refleksi dijawab di rumah sebagai bagian dari laporan.

## Bagian 10. Hasil yang dikumpulkan: ganti kalimat pembuka

> Dua berkas SQL (nomor 1 dan 2) disimpan di lokasi yang ditentukan dosen sebelum komputer lab dimatikan. Laporan (nomor 3) dikumpulkan paling lambat pada batas waktu yang diumumkan dosen di akhir sesi.

## Bagian 11. Daftar pemeriksaan: tambahkan butir

> ☐ Semua baris `P04_cek_mandiri.sql` bernilai OK, dan tangkapan layarnya ada di Bukti 3.

# Bagian 3. Panduan sesi untuk dosen

## Sebelum hari praktikum

- Sesuaikan isi `P04_pulihkan_p3.sql` dengan praktikum 3, lalu letakkan ketiga berkas SQL di folder bersama lab, LMS, atau flashdisk.
- Opsional, tetapi sangat membantu: rekam layar 5–8 menit saat dosen mengerjakan langkah C dan D, lalu unggah ke LMS. Mahasiswa yang tertinggal dapat memutar ulang tanpa menghentikan kelas.

## Tampilan di proyektor pada setiap tahap

Tampilkan satu instruksi besar beserta target jamnya. Mahasiswa yang tertinggal tahu posisi kelas tanpa bertanya.

| Jam | Teks di proyektor |
|---|---|
| 07.00 | **Sudah absen? Buka phpMyAdmin → tab SQL → jalankan `P04_cek_awal.sql`. Screenshot = Bukti 1.** |
| 07.15 | **Semua STATUS harus OK. Ada error tabel tidak ada → jalankan `P04_pulihkan_p3.sql`.** |
| 07.20 | **Sekarang: Langkah C. Target selesai 07.40.** |
| 07.40 | **Sekarang: Langkah D. Target selesai 08.10. Uji 1 dan Uji 2 dijalankan terpisah.** |
| 08.10 | **Sekarang: Langkah E. Jalankan `P04_cek_mandiri.sql`, simpan dua berkas SQL.** |
| 08.25 | **Sudah semua OK? Kerjakan latihan nomor 4. Belum? Selesaikan langkah E.** |
| 08.30 | **Simpan berkas. Pengumuman laporan dan tugas.** |

## Selama praktik

- Pada setiap pergantian langkah, minta mahasiswa yang belum selesai mengangkat tangan sebentar. Jika lebih dari sepertiga kelas belum selesai, tambahkan 3–5 menit dari waktu cadangan.
- Arahkan pertanyaan rutin ke hasil cek mandiri dulu: "Baris mana yang belum OK? Apa tindakannya?"
- Mahasiswa yang selesai lebih dulu boleh membantu teman satu pasangan kerja, sesuai aturan di modul: setiap mahasiswa tetap menjalankan SQL sendiri.

## Untuk pertemuan berikutnya

Pola yang sama dapat dipakai untuk modul lain:

1. Jadwal ditulis untuk 75 menit efektif, bukan 100.
2. Pemeriksaan awal dalam satu berkas, dijalankan saat absensi.
3. Satu berkas pemulihan kondisi pertemuan sebelumnya.
4. Satu berkas cek mandiri OK/BELUM di akhir.
5. Pertanyaan konsep dan refleksi dikerjakan di rumah.
