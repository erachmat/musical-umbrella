# Catatan revisi modul Praktikum 6: Relasi Penjualan dan Detail

Modul hasil revisi: `modul/DM099_Praktikum_6_Relasi_Penjualan_dan_Detail.docx` (dan versi `.md` beserta folder `gambar/`).

## Kesalahan yang diperbaiki

| Masalah di modul lama | Akibat | Perbaikan |
|---|---|---|
| Langkah A memanggil `customer_name`, padahal kolom `customers` sejak praktikum 3 bernama `full_name` | `ERROR 1054 Unknown column 'customer_name'` di langkah pertama | Query diganti `full_name` |
| Gambar 1 (ERD) menulis atribut `customer_name` | ERD tidak cocok dengan tabel | Gambar diperbaiki menjadi `full_name` dengan font dan posisi yang sama |
| Setiap baris SQL di PDF mengandung karakter tak terlihat (zero-width space, U+200B) | Salinan dari PDF ditolak dengan `ERROR 1064` | Berkas `.sql` disediakan, modul revisi bersih dari karakter tersebut, dan ada peringatan di bagian 2 dan tabel kendala |
| Kelima INSERT uji berada dalam satu blok | phpMyAdmin berhenti pada error pertama; uji 2–5 tidak berjalan | Dipecah menjadi lima blok Uji 1–5 |
| Judul halaman 2 "Relasi dan Entitas Asosiasi" berbeda dari sampul "Relasi Penjualan dan Detail" | Membingungkan | Disamakan dengan sampul |
| Blok SQL langkah A diletakkan setelah butir 5, padahal butir 2 menyebut "blok SQL di bawah" | Urutan membingungkan | Blok dipindah tepat setelah butir 2 |

Seluruh 13 blok SQL modul revisi sudah dijalankan berurutan pada MariaDB 10.11.14 di atas kondisi akhir praktikum 5: semua berhasil, dan kelima uji ditolak oleh constraint yang tepat (1452 `fk_sale_items_sale`, 1452 `fk_sale_items_product`, 1062 `PRIMARY`, 4025 `ck_sale_items_qty`, 4025 `ck_sale_items_price`).

## Penyesuaian yang sama dengan praktikum 5

- Jadwal 75 menit efektif; cek awal dan gambar ERD dikerjakan saat absensi.
- Tabel berkas pendukung, catatan `USE`, butir ketentuan kerja 6, dan rujukan cek mandiri.
- Latihan 1, 2, 3, 5, lembar kerja, dan refleksi dikerjakan di rumah; nomor 4 di lab.
- Sapaan "kamu", keterangan Tabel 1–6, baris identitas pada lembar kerja, daftar pemeriksaan dengan ☐.
- ERD individu; nama berkas tetap `P06_normal.sql` dan `P06_uji_penolakan.sql`.

## Keputusan yang diambil

- **Database milik sendiri** (dikonfirmasi dosen). Modul lama mengizinkan "alokasi kelompok". Jika beberapa mahasiswa memakai satu database, mahasiswa kedua dan seterusnya akan mendapati tabel sudah ada dan INSERT 601/602 ditolak sebagai duplikat, sehingga Bukti 2 dan 3 tidak dapat dibuat sendiri.
- **Penjelasan indeks** ditambahkan di langkah C: dua kolom bertanda `PRI` pada `sale_items`, indeks otomatis `fk_sale_items_product`, dan `MUL` pada `sales.customer_id`.
- **Pemeriksaan jumlah tabel lama** yang sebelumnya hanya disebut dalam teks ("Gunakan COUNT(*)") kini dimasukkan ke blok SQL pemeriksaan langkah D.

## Tidak diubah

- Gambar 2 (tangkapan layar demo phpMyAdmin) dan referensi MySQL Workbench dipertahankan sesuai modul asli, walaupun bagian 2 menyebut Workbench tidak diperlukan. Keduanya dapat dihapus jika ingin modul lebih ringkas.
