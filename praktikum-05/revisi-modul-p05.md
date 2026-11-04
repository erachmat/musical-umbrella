---
title: "Revisi Modul Praktikum 5: Dari ERD ke Tabel"
subtitle: "Penyesuaian ke waktu efektif 75 menit dan keselarasan dengan praktikum 2–4"
---

# Bagian 1. Ringkasan untuk dosen

## Hasil uji SQL

Seluruh SQL di modul sudah dijalankan pada MariaDB 10.11.14 di atas kondisi akhir praktikum 4. Semua berjalan sesuai teks modul:

- `products_v2` berhasil dibuat, dan dua produk latihan berhasil ditambahkan.
- Uji 1 ditolak oleh `fk_products_v2_category` (error 1452), Uji 2 oleh `uq_products_v2_sku` (error 1062), dan Uji 3 oleh `ck_products_v2_price` (error 4025).
- JOIN di langkah E menghasilkan 101 L01 Minuman dan 102 L02 Alat Tulis.

Revisi ini tidak mengubah SQL di modul. Yang diubah adalah jadwal, beberapa penjelasan, dan keselarasan dengan modul sebelumnya.

## Perubahan

1. **Jadwal disesuaikan ke 75 menit efektif.** Tabel 2 lama berjumlah 100 menit tanpa potongan untuk absensi dan penutup.
2. **Pemeriksaan awal dan gambar ERD dikerjakan saat absensi.** Mahasiswa menjalankan `P05_cek_awal.sql`, lalu menggambar ulang Gambar 1 di kertas. Menggambar ERD tidak memerlukan komputer, sehingga cocok dikerjakan sambil menunggu absensi.
3. **Pemeriksaan oleh dosen diganti pemeriksaan mandiri** melalui `P05_cek_mandiri.sql` (10 butir OK/BELUM beserta tindakan).
4. **Pemulihan praktikum 4 tanpa antre** melalui `P05_pulihkan_p4.sql`. Berkas ini memulihkan tabel, data, indeks unik `sku`, foreign key, dan CHECK dari praktikum 2–4. `products_v2` tidak dibuat, karena itu pekerjaan praktikum 5.
5. **Latihan mandiri nomor 1, 2, 3, 5 dan refleksi dikerjakan di rumah.** Nomor 4 menjadi tantangan di lab bagi yang selesai lebih dulu.
6. **Tiga penjelasan teknis ditambahkan** (lihat Bagian 2): baris `USE`, indeks tambahan untuk foreign key, dan alasan FK tanpa `ON UPDATE`/`ON DELETE`.

## Keputusan yang perlu dosen tetapkan

**ERD individu atau kelompok?** Langkah A.7 menyebut "ERD buatan Anda", sedangkan bagian 10 menyebut "ERD dan laporan dapat dikerjakan dalam kelompok". Revisi ini memakai pilihan berikut, yang dapat diganti:

> ERD digambar **per mahasiswa** saat absensi dan menjadi Bukti 1 masing-masing. Laporan mengikuti arahan dosen (individu atau kelompok 3–4 orang).

Jika ERD dikerjakan berkelompok, ganti kalimat pada langkah A.7 di Bagian 2 menjadi: "Bukti 1 berupa satu ERD per kelompok. Setiap anggota tetap menyalin ERD tersebut ke laporannya."

## Keselarasan dengan praktikum 2–4

| Hal | Praktikum 2–4 | Praktikum 5 sekarang | Saran |
|---|---|---|---|
| Sapaan | "kamu" | "Anda" | Find & Replace: `Anda` → `kamu`, lalu periksa awal kalimat menjadi `Kamu` |
| Nama berkas | `DM099_P04_kodepraktik.sql`, `_uji.sql`, `_laporan.pdf` | `P05_normal.sql`, `P05_uji_penolakan.sql` | Pakai pola lama (lihat teks pengganti bagian 10) |
| Baris `USE` | Ada di setiap blok SQL | Tidak ada | Tambahkan catatan (lihat teks pengganti bagian 6) |
| Lembar kerja | Ada baris kode praktik/komputer, alamat phpMyAdmin, akses lokal/LAN | Tidak ada | Tambahkan tiga baris (lihat teks pengganti bagian 8) |
| Judul bagian | Alur kegiatan, Aturan kerja, Penanganan kendala umum, Hasil yang dikumpulkan, Daftar pemeriksaan sebelum selesai, Istilah penting, Referensi resmi | Pembagian waktu, Ketentuan kerja, Masalah yang sering muncul, Berkas yang dikumpulkan, Pemeriksaan sebelum mengumpulkan, Glosarium, Referensi | Opsional, ganti agar seragam |
| Daftar pemeriksaan | Kotak ☐ | Titik | Ganti titik dengan ☐ |
| Sampul | "Praktikum • Pertemuan 4" | "PERTEMUAN PRAKTIKUM 5" | Opsional |

Teks pengganti di Bagian 2 sudah ditulis dengan sapaan "kamu".

## Tampilan

Halaman 4 dan 7 (versi PDF dari docx) setengah kosong karena ada pemisah halaman sebelum judul bagian B dan sebelum lanjutan langkah D. Hapus pemisah halaman tersebut jika ingin modul lebih ringkas.

# Bagian 2. Teks pengganti untuk modul

## Bagian 2. Peralatan dan persiapan

Ganti paragraf terakhir ("Data awal yang digunakan adalah... selesaikan bersama dosen sebelum melanjutkan.") dengan:

> Data awal yang digunakan adalah tiga kategori, yaitu 1 Minuman, 2 Roti, dan 3 Alat Tulis. Tabel `products` berisi empat produk dan `customers` berisi tiga pelanggan sintetis.
>
> Dosen membagikan tiga berkas SQL pendukung. Ganti nama database pada baris `USE` di bagian atas setiap berkas sebelum menjalankannya.
>
> | Berkas | Kapan dijalankan |
> |---|---|
> | `P05_cek_awal.sql` | Saat masuk lab, sambil menunggu absensi. Berisi pemeriksaan langkah A. |
> | `P05_pulihkan_p4.sql` | Hanya jika cek awal menunjukkan tabel, data, atau aturan praktikum 4 belum lengkap. |
> | `P05_cek_mandiri.sql` | Setelah langkah D, untuk memeriksa hasil sendiri sebelum menyimpan. |
>
> Jalankan berkas dengan membuka tab SQL di phpMyAdmin, menempelkan seluruh isi berkas, lalu klik **Go**.

## Bagian 4. Pembagian waktu: ganti Tabel 2

> Tabel 2. Kegiatan praktikum selama 100 menit (contoh untuk kelas pukul 07.00).
>
> | Menit | Jam | Kegiatan | Hasil yang dituju |
> |---|---|---|---|
> | 0–15 | 07.00–07.15 | Absensi. Jalankan `P05_cek_awal.sql`, lalu gambar ulang ERD di kertas (langkah A). | Lingkungan tercatat. Bukti 1 (ERD) selesai. |
> | 15–20 | 07.15–07.20 | Dosen menjelaskan notasi Crow's Foot dan cara memetakan ERD menjadi tabel. | Hubungan dibaca dari kedua arah. |
> | 20–40 | 07.20–07.40 | Langkah B: demo dosen 5 menit, lalu praktik 15 menit. | `products_v2` dibuat. |
> | 40–55 | 07.40–07.55 | Langkah C: periksa struktur, tambahkan dua produk latihan. | Bukti 2 tersimpan. |
> | 55–75 | 07.55–08.15 | Langkah D: demo dosen 3 menit, lalu tiga uji terpisah dan pemeriksaan akhir. | Bukti 3 tersimpan. |
> | 75–85 | 08.15–08.25 | Langkah E: jalankan JOIN dan `P05_cek_mandiri.sql`, simpan dua berkas SQL. | Semua baris cek mandiri OK. |
> | 85–90 | 08.25–08.30 | Waktu cadangan. Yang sudah selesai mengerjakan latihan mandiri nomor 4. | Mahasiswa yang tertinggal menyelesaikan langkah E. |
> | 90–100 | 08.30–08.40 | Pengumuman laporan dan tugas, simpan berkas, matikan komputer, rapikan meja. | Berkas SQL tersimpan. |
>
> Latihan mandiri nomor 1, 2, 3, 5, lembar kerja, dan refleksi dikerjakan dalam laporan di rumah.

## Bagian 6. Langkah A: ganti nomor 2, 3, dan 7

> 2. Jalankan `P05_cek_awal.sql` sebelum membuat tabel. Blok berikut adalah isi utama berkas tersebut.
>
> *(blok SQL lama tetap)*
>
> 3. Lihat dua tabel hasil **STATUS**. Semua baris harus OK. Baris `products_v2` bernilai **INFO** jika tabel tersebut sudah pernah dibuat; lewati CREATE di langkah B dan jalankan `P05_cek_mandiri.sql`. Untuk nilai lain, ikuti kolom **tindakan**. Jika muncul error `Table ... doesn't exist`, jalankan `P05_pulihkan_p4.sql`, lalu jalankan cek awal sekali lagi.
>
> 7. **Bukti 1.** Simpan ERD buatan kamu beserta dua kalimat penjelasan hubungan. Foto gambar tangan boleh digunakan selama tulisan dan garisnya terbaca. Gambar ERD dapat dikerjakan di kertas sambil menunggu absensi selesai.

## Bagian 6. Tambahkan catatan `USE` sebelum langkah A

> Blok SQL pada modul ini tidak diawali `USE`. Pilih database latihan pada panel kiri phpMyAdmin sebelum membuka tab SQL. Jika muncul error `No database selected` (kode 1046), tambahkan baris berikut di awal blok, dengan nama database kamu:
>
> `USE pbd_latihan_p01;`
>
> Tulis baris `USE` di awal berkas `.sql` yang kamu simpan agar berkas dapat dijalankan kembali pada pertemuan berikutnya.

## Bagian 6. Langkah B: tambahkan setelah paragraf "Tabel menggunakan InnoDB..."

> Foreign key pada latihan ini tidak menulis `ON UPDATE` atau `ON DELETE`. Tanpa kedua klausa tersebut, InnoDB menolak penghapusan kategori yang masih dipakai produk dan menolak perubahan ID-nya. MariaDB menampilkan tindakan bawaan ini sebagai `RESTRICT`, sedangkan MySQL menampilkannya sebagai `NO ACTION`; pada InnoDB keduanya bekerja sama. Pada praktikum 4, tindakan `ON UPDATE CASCADE` ditulis secara eksplisit.

*(Jika dosen ingin FK di praktikum 5 sama dengan praktikum 4, tambahkan `ON UPDATE CASCADE ON DELETE RESTRICT` setelah `REFERENCES categories(category_id)` dan hapus paragraf di atas. `P05_cek_mandiri.sql` menerima kedua bentuk.)*

## Bagian 6. Langkah C: tambahkan setelah paragraf "DESCRIBE menampilkan kolom..."

> Pada kolom `category_id`, DESCRIBE menampilkan `MUL` di kolom Key, dan SHOW INDEX menampilkan indeks ketiga bernama `fk_products_v2_category` dengan `Non_unique` = 1. Indeks ini dibuat otomatis oleh InnoDB agar foreign key dapat diperiksa dengan cepat. Indeks tersebut tidak membuat `category_id` unik: banyak produk tetap boleh memakai kategori yang sama.

## Bagian 6. Langkah E: tambahkan di akhir

> Jalankan `P05_cek_mandiri.sql`. Semua sepuluh baris harus bernilai OK. Jika ada baris BELUM, kerjakan langkah yang disebut pada kolom tindakan. Panggil dosen hanya jika kolom tindakan memintanya. Tangkapan layar hasil cek mandiri melengkapi Bukti 3.

## Instruksi "minta dosen memeriksa": ganti dengan rujukan ke berkas

| Lokasi | Kalimat lama | Kalimat baru |
|---|---|---|
| Bagian 2, paragraf terakhir | Jika hasil praktikum 4 belum lengkap, selesaikan bersama dosen sebelum melanjutkan. | *(sudah diganti oleh teks pengganti bagian 2)* |
| Langkah A.3 | Jika hasilnya berbeda, minta dosen memeriksa sebelum melanjutkan. | *(sudah diganti oleh teks pengganti A.3)* |
| Langkah C, sebelum Bukti 2 | Jika hanya satu baris yang tersedia, ada baris tambahan, atau nilainya berbeda, minta dosen memeriksa sebelum menambah data. | *(tetap: kasus ini memang perlu dosen; baris 7–8 cek mandiri membantu melihatnya)* |
| Langkah D, sebelum uji | Jika berbeda, minta dosen memeriksa sebelum menjalankan uji. | *(tetap)* |
| Bagian 9, "Kategori 3 belum ada" | Periksa hasil praktikum 4 bersama dosen. Jangan membuat kategori pengganti tanpa memeriksa data awal. | Jalankan `P05_pulihkan_p4.sql`, lalu `P05_cek_awal.sql`. Jangan membuat kategori pengganti dengan INSERT sendiri. |
| Bagian 9, "Tabel sudah tersedia" | Baca SHOW CREATE TABLE dan isi tabel. | Jalankan `P05_cek_mandiri.sql`. Panggil dosen jika baris 2–6 bernilai CEK. |
| Bagian 9, "Gambar tidak sesuai tabel" | Cocokkan dengan aturan katalog bersama dosen sebelum mengubah struktur. | *(tetap)* |

## Bagian 7. Latihan mandiri: ganti kalimat pembuka

> Latihan nomor 4 dikerjakan di lab jika langkah E sudah selesai dan semua baris `P05_cek_mandiri.sql` bernilai OK. Jika waktu di lab tidak cukup, nomor 4 boleh dikerjakan di rumah selama database latihan masih dapat diakses, atau ditulis sebagai rancangan query tanpa hasil eksekusi.
>
> Nomor 1, 2, 3, dan 5 dijawab dalam laporan yang dikerjakan di rumah.

## Bagian 8. Lembar kerja: tambahkan tiga baris di awal Tabel 3

> | Pemeriksaan | Hasil dan bukti kamu |
> |---|---|
> | Kode praktik dan kode komputer | Tulis kode praktik dari dosen dan nomor komputer lab yang digunakan. |
> | Alamat phpMyAdmin | Catat alamat yang dibuka di browser. |
> | Akses lokal atau server bersama | Jelaskan apakah server berada di komputer sendiri atau dipakai melalui LAN. |

Tambahkan kalimat berikut sebelum subjudul Refleksi:

> Lembar kerja dan refleksi dikerjakan di rumah sebagai bagian dari laporan.

## Bagian 10. Berkas yang dikumpulkan: ganti daftar

> 1. `DM099_P05_kodepraktik.sql` berisi pembuatan tabel, pemeriksaan, dan pengisian data valid. Awali dengan `USE` dan tambahkan komentar agar urutan pemakaiannya jelas.
> 2. `DM099_P05_kodepraktik_uji.sql` berisi tiga INSERT untuk uji penolakan. Beri komentar agar setiap INSERT dijalankan secara terpisah.
> 3. `DM099_P05_kodepraktik_laporan.pdf` atau format dari dosen, berisi ERD, Bukti 1 sampai 3, lembar kerja, lima jawaban latihan, tiga refleksi, dan catatan kendala.
>
> Dua berkas SQL disimpan di lokasi yang ditentukan dosen sebelum komputer lab dimatikan. Laporan dikumpulkan paling lambat pada batas waktu yang diumumkan dosen di akhir sesi.

## Bagian 11. Pemeriksaan sebelum mengumpulkan: tambahkan butir

> ☐ Semua baris `P05_cek_mandiri.sql` bernilai OK, dan tangkapan layarnya ada di Bukti 3.

# Bagian 3. Panduan sesi untuk dosen

## Sebelum hari praktikum

- Tetapkan ERD individu atau kelompok (Bagian 1).
- Letakkan ketiga berkas SQL di folder bersama lab, LMS, atau flashdisk.
- Siapkan kertas kosong untuk mahasiswa yang tidak membawa kertas.

## Tampilan di proyektor pada setiap tahap

| Jam | Teks di proyektor |
|---|---|
| 07.00 | **Sudah absen? Jalankan `P05_cek_awal.sql`, lalu gambar ulang ERD (Gambar 1) di kertas = Bukti 1.** |
| 07.15 | **STATUS harus OK. Ada yang BELUM/CEK → jalankan `P05_pulihkan_p4.sql`.** |
| 07.20 | **Sekarang: Langkah B (CREATE products_v2). Target selesai 07.40.** |
| 07.40 | **Sekarang: Langkah C (struktur + 2 produk latihan). Target selesai 07.55.** |
| 07.55 | **Sekarang: Langkah D. Tiga uji, dijalankan satu per satu. Target selesai 08.15.** |
| 08.15 | **Sekarang: Langkah E. JOIN + `P05_cek_mandiri.sql`, simpan dua berkas SQL.** |
| 08.25 | **Sudah semua OK? Kerjakan latihan nomor 4. Belum? Selesaikan langkah E.** |
| 08.30 | **Simpan berkas. Pengumuman laporan dan tugas.** |

## Selama praktik

- Penjelasan 07.15–07.20 sebaiknya memakai ERD yang digambar mahasiswa: minta satu mahasiswa membaca hubungan dari kedua arah.
- Demo langkah B sebaiknya menunjuk setiap baris CREATE dan mengaitkannya dengan simbol PK, UQ, dan FK pada ERD.
- Pertanyaan yang paling mungkin muncul di langkah C adalah `MUL` dan indeks ketiga pada `category_id`. Penjelasannya sudah ada di teks pengganti langkah C.
- Arahkan pertanyaan rutin ke hasil cek mandiri dulu: "Baris mana yang belum OK? Apa tindakannya?"
