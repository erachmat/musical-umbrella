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
| 5. Dari ERD ke Tabel | **Modul revisi lengkap:** `praktikum-05/modul/DM099_Praktikum_5_ERD_ke_Tabel.md` (+ `gambar/`), `revisi-modul-p05.docx`, `lembar-dosen-p05.pdf` | `P05_cek_awal.sql`, `P05_pulihkan_p4.sql`, `P05_cek_mandiri.sql` |

Semua berkas siap dibagikan. Mahasiswa hanya perlu mengganti nama database pada baris `USE`.

Semua berkas sudah diuji pada MariaDB 10.11.14 dengan perintah persis dari modul, berurutan dari praktikum 2 sampai 5. Data hasil berkas pemulihan juga lolos cek mandiri praktikum sebelumnya.
