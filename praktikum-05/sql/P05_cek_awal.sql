-- =====================================================================
-- DM099 Praktikum 5 - P05_cek_awal.sql
-- Langkah A: memeriksa hasil praktikum 4 sebelum membuat products_v2
--
-- KAPAN DIPAKAI
--   Saat masuk lab, sambil menunggu absensi (07.00-07.15).
--   Berkas ini hanya membaca data (SELECT dan SHOW). Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Lihat dua tabel hasil "STATUS". Semua baris harus OK atau INFO.
--   4. Simpan tangkapan layar bagian 1 dan STATUS untuk lembar kerja.
--   5. Setelah itu, gambar ulang ERD (Gambar 1 modul) di kertas: Bukti 1.
--
-- JIKA ADA YANG BUKAN OK
--   Ikuti kolom "tindakan". Jika muncul error "Table ... doesn't exist",
--   jalankan P05_pulihkan_p4.sql, lalu jalankan berkas ini lagi.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Lingkungan praktik (lembar kerja)
-- ---------------------------------------------------------------------
SELECT DATABASE()            AS database_aktif,
       VERSION()             AS versi_server,
       @@sql_mode            AS mode_sql,
       @@foreign_key_checks  AS fk_aktif;

SHOW TABLES;

-- ---------------------------------------------------------------------
-- 2. STATUS: struktur
--    Bagian ini hanya membaca information_schema, sehingga tetap
--    berjalan walaupun tabel belum ada.
-- ---------------------------------------------------------------------
SELECT 'Tabel categories, products, customers tersedia' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products', 'customers')) = 3,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan P05_pulihkan_p4.sql' AS tindakan
UNION ALL
SELECT 'Pemeriksaan foreign key aktif (fk_aktif = 1)',
  IF(@@foreign_key_checks = 1, 'OK', 'CEK'),
  'Jika CEK: panggil dosen (uji 1 tidak akan ditolak)'
UNION ALL
SELECT 'categories memakai InnoDB dan category_id INT UNSIGNED PK',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'categories'
              AND ENGINE = 'InnoDB')
     AND EXISTS(SELECT 1 FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'categories'
                  AND COLUMN_NAME = 'category_id'
                  AND COLUMN_TYPE LIKE 'int%unsigned' AND COLUMN_KEY = 'PRI'),
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen (FK products_v2 akan gagal)'
UNION ALL
SELECT 'Aturan praktikum 4 (FK dan CHECK pada products)',
  IF(EXISTS(SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS
            WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
              AND REFERENCED_TABLE_NAME = 'categories')
     AND EXISTS(SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
                  AND CONSTRAINT_TYPE = 'CHECK'),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan P05_pulihkan_p4.sql, lalu cek lagi'
UNION ALL
SELECT 'Tabel products_v2',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: lewati CREATE, jalankan P05_cek_mandiri.sql';

-- ---------------------------------------------------------------------
-- 3. STATUS: data praktikum 4
--    Jika muncul error "Table ... doesn't exist" di sini, jalankan
--    P05_pulihkan_p4.sql terlebih dahulu.
-- ---------------------------------------------------------------------
SELECT 'Kategori 1 Minuman, 2 Roti, 3 Alat Tulis' AS cek,
  IF((SELECT COUNT(*) FROM categories
      WHERE (category_id = 1 AND category_name = 'Minuman')
         OR (category_id = 2 AND category_name = 'Roti')
         OR (category_id = 3 AND category_name = 'Alat Tulis')) = 3
     AND (SELECT COUNT(*) FROM categories) = 3,
     'OK', 'CEK') AS status,
  'Jika CEK: jalankan P05_pulihkan_p4.sql; jika tetap CEK, panggil dosen' AS tindakan
UNION ALL
SELECT 'Tabel products berisi 4 produk (P01-P04)',
  IF((SELECT COUNT(*) FROM products) = 4
     AND (SELECT COUNT(*) FROM products
          WHERE sku IN ('P01', 'P02', 'P03', 'P04')) = 4,
     'OK', 'CEK'),
  'Jika CEK: jalankan P05_pulihkan_p4.sql; jika tetap CEK, panggil dosen'
UNION ALL
SELECT 'Tabel customers berisi 3 pelanggan',
  IF((SELECT COUNT(*) FROM customers) = 3, 'OK', 'CEK'),
  'Jika CEK: jalankan P05_pulihkan_p4.sql; jika tetap CEK, panggil dosen';

-- ---------------------------------------------------------------------
-- 4. Definisi dan isi categories (dirujuk oleh products_v2)
-- ---------------------------------------------------------------------
SHOW CREATE TABLE categories;

SELECT category_id, category_name
FROM categories ORDER BY category_id;

SELECT COUNT(*) AS jumlah_products FROM products;

SELECT COUNT(*) AS jumlah_customers FROM customers;
