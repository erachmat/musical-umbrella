-- =====================================================================
-- DM099 Praktikum 6 - P06_cek_awal.sql
-- Langkah A: memeriksa data induk sebelum membuat sales dan sale_items
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
--   jalankan P06_pulihkan_p5.sql, lalu jalankan berkas ini lagi.
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
SELECT 'Tabel categories, products, customers, products_v2 tersedia' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products', 'customers', 'products_v2')) = 4,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan P06_pulihkan_p5.sql' AS tindakan
UNION ALL
SELECT 'Pemeriksaan foreign key aktif (fk_aktif = 1)',
  IF(@@foreign_key_checks = 1, 'OK', 'CEK'),
  'Jika CEK: panggil dosen (uji rujukan tidak akan ditolak)'
UNION ALL
SELECT 'customers dan products: InnoDB, ID INT UNSIGNED PK',
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('customers', 'products') AND ENGINE = 'InnoDB') = 2
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND ((TABLE_NAME = 'customers' AND COLUMN_NAME = 'customer_id')
              OR (TABLE_NAME = 'products'  AND COLUMN_NAME = 'product_id'))
            AND COLUMN_TYPE LIKE 'int%unsigned' AND COLUMN_KEY = 'PRI') = 2,
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen (FK sales/sale_items akan gagal)'
UNION ALL
SELECT 'Tabel sales',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sales'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: lewati CREATE, jalankan P06_cek_mandiri.sql'
UNION ALL
SELECT 'Tabel sale_items',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: lewati CREATE, jalankan P06_cek_mandiri.sql';

-- ---------------------------------------------------------------------
-- 3. STATUS: data induk
--    Jika muncul error "Table ... doesn't exist" di sini, jalankan
--    P06_pulihkan_p5.sql terlebih dahulu.
-- ---------------------------------------------------------------------
SELECT 'Pelanggan ID 1 dan 2 tersedia' AS cek,
  IF((SELECT COUNT(*) FROM customers WHERE customer_id IN (1, 2)) = 2,
     'OK', 'CEK') AS status,
  'Jika CEK: jalankan P06_pulihkan_p5.sql; jika tetap CEK, panggil dosen' AS tindakan
UNION ALL
SELECT 'Produk ID 1, 2, 3 tersedia (harga 5000, 8000, 4000)',
  IF((SELECT COUNT(*) FROM products
      WHERE (product_id = 1 AND unit_price = 5000.00)
         OR (product_id = 2 AND unit_price = 8000.00)
         OR (product_id = 3 AND unit_price = 4000.00)) = 3,
     'OK', 'CEK'),
  'Jika CEK: jalankan P06_pulihkan_p5.sql; jika tetap CEK, panggil dosen'
UNION ALL
SELECT 'Jumlah 3 kategori, 4 produk, 3 pelanggan, 2 products_v2',
  IF((SELECT COUNT(*) FROM categories) = 3
     AND (SELECT COUNT(*) FROM products) = 4
     AND (SELECT COUNT(*) FROM customers) = 3
     AND (SELECT COUNT(*) FROM products_v2) = 2,
     'OK', 'CEK'),
  'Jika CEK: jalankan P06_pulihkan_p5.sql; jika tetap CEK, panggil dosen';

-- ---------------------------------------------------------------------
-- 4. Data induk yang akan dirujuk (lembar kerja)
-- ---------------------------------------------------------------------
SELECT customer_id, full_name FROM customers
ORDER BY customer_id;

SELECT product_id, sku, unit_price FROM products
ORDER BY product_id;
