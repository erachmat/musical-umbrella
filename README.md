# DM099 Perancangan Basis Data: bahan pendukung praktikum

Setiap praktikum memiliki pola yang sama:

1. Jadwal ditulis untuk waktu efektif 75 menit (07.15–08.30), bukan 100 menit.
2. `cek_awal`: pemeriksaan awal yang dijalankan mahasiswa saat absensi.
3. `pulihkan`: memulihkan kondisi akhir praktikum sebelumnya tanpa DROP/DELETE/UPDATE, aman dijalankan ulang.
4. `cek_mandiri`: pemeriksaan akhir OK/BELUM beserta tindakan, menggantikan antrean "minta dosen memeriksa".
5. Pertanyaan konsep dan refleksi dikerjakan di rumah.

| Praktikum | Revisi modul | Berkas SQL |
|---|---|---|
| 2. Membuat Tabel Toko Saku | `praktikum-02/revisi-modul-p02.docx` | `P02_cek_awal.sql`, `P02_cek_mandiri.sql` (tanpa pemulihan: kondisi awal hanya database kosong) |
| 3. DDL, Tipe Data, dan Kunci | `praktikum-03/revisi-modul-p03.docx` | `P03_cek_awal.sql`, `P03_pulihkan_p2.sql`, `P03_cek_mandiri.sql` |
| 4. Constraint dan Foreign Key | `praktikum-04/revisi-modul-p04.docx` + `lembar-dosen-p04.pdf` | `P04_cek_awal.sql`, `P04_pulihkan_p3.sql`, `P04_cek_mandiri.sql` |
| 5. Dari ERD ke Tabel | **Modul revisi lengkap:** `praktikum-05/modul/DM099_Praktikum_5_ERD_ke_Tabel.docx` dan `.md` (+ `gambar/`), `revisi-modul-p05.docx`, `lembar-dosen-p05.pdf` | `P05_cek_awal.sql`, `P05_pulihkan_p4.sql`, `P05_cek_mandiri.sql` |
| 6. Relasi Penjualan dan Detail | **Modul revisi lengkap:** `praktikum-06/modul/DM099_Praktikum_6_Relasi_Penjualan_dan_Detail.docx` dan `.md` (+ `gambar/`), `catatan-revisi-p06.md`, `lembar-dosen-p06.pdf` | `P06_cek_awal.sql`, `P06_pulihkan_p5.sql`, `P06_cek_mandiri.sql` |

Semua berkas siap dibagikan. Mahasiswa hanya perlu mengganti nama database pada baris `USE`.

Semua berkas sudah diuji pada MariaDB 10.11.14 dengan perintah persis dari modul, berurutan dari praktikum 2 sampai 6. Data hasil berkas pemulihan juga lolos cek mandiri praktikum sebelumnya.

## Membuat ulang docx dari modul .md

```bash
cd praktikum-05/modul
NODE_PATH=$(npm root -g) node ../../tools/md2docx.js DM099_Praktikum_5_ERD_ke_Tabel.md DM099_Praktikum_5_ERD_ke_Tabel.docx "DM099 Perancangan Basis Data · Praktikum 5: Dari ERD ke Tabel"
```

## UTS DM099: contoh jawaban

| Berkas | Isi |
|---|---|
| `uts-pbd/Contoh_Jawaban_UTS_PBD_DM099.docx` (dan `contoh-jawaban-uts-pbd.md`) | Contoh jawaban enam soal UTS dengan kasus Toko Saku, usulan rubrik per soal, kesalahan yang sering muncul, dan catatan untuk penyusun soal |
| `uts-pbd/sql/uts_contoh_tokosaku.sql` | SQL lengkap soal 5: enam tabel, data contoh, dan query pemeriksaan (diuji pada MariaDB 10.11.14) |
| `uts-pbd/gambar/gambar-1-erd.png` | ERD Crow's Foot untuk soal 4 |

`tools/md2docx.js` kini juga dapat membuat dokumen tanpa sampul (berkas `.md` tanpa garis `---`), dengan daftar poin dan judul tengah (`%%`, `%%%`).
