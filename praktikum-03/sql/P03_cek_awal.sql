-- =====================================================================
-- DM099 Praktikum 3 - P03_cek_awal.sql
-- Langkah A: memeriksa hasil praktikum 2 sebelum CREATE dan ALTER
--
-- KAPAN DIPAKAI
--   Saat masuk lab, sambil menunggu absensi (07.00-07.15).
--   Berkas ini hanya membaca data (SELECT, SHOW, DESCRIBE).
--   Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Lihat dua tabel hasil "STATUS". Semua baris harus OK atau INFO.
--   4. Ambil tangkapan layar untuk Bukti 1: bagian 1, STATUS, dan bagian 4.
--
-- JIKA ADA YANG BUKAN OK
--   Ikuti kolom "tindakan". Jika muncul error "Table ... doesn't exist",
--   jalankan P03_pulihkan_p2.sql, lalu jalankan berkas ini lagi.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Lingkungan praktik (Bukti 1)
-- ---------------------------------------------------------------------
SELECT DATABASE()  AS database_aktif,
       VERSION()   AS versi_server,
       @@sql_mode  AS mode_sql;

SHOW TABLES;

-- ---------------------------------------------------------------------
-- 2. STATUS: struktur praktikum 2
--    Bagian ini hanya membaca information_schema, sehingga tetap
--    berjalan walaupun tabel belum ada.
-- ---------------------------------------------------------------------
SELECT 'Tabel categories dan products tersedia' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products')) = 2,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan P03_pulihkan_p2.sql' AS tindakan
UNION ALL
SELECT 'Kolom products sesuai Gambar 1, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'product_id'   AND COLUMN_TYPE LIKE 'int%unsigned' AND COLUMN_KEY = 'PRI')
          OR (COLUMN_NAME = 'sku'          AND COLUMN_TYPE = 'varchar(20)')
          OR (COLUMN_NAME = 'product_name' AND COLUMN_TYPE = 'varchar(100)')
          OR (COLUMN_NAME = 'category_id'  AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'unit_price'   AND COLUMN_TYPE = 'decimal(12,2)')
          OR (COLUMN_NAME = 'stock_qty'    AND COLUMN_TYPE LIKE 'int%unsigned'))) = 6,
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen'
UNION ALL
SELECT 'Tabel customers',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: periksa di langkah B, jangan CREATE ulang'
UNION ALL
SELECT 'Indeks unik sku',
  IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS s
            WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'products'
              AND s.NON_UNIQUE = 0 AND s.COLUMN_NAME = 'sku'
              AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                              WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                                AND s2.TABLE_NAME   = s.TABLE_NAME
                                AND s2.INDEX_NAME   = s.INDEX_NAME
                                AND s2.COLUMN_NAME <> 'sku')),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: lewati ALTER di langkah C';

-- ---------------------------------------------------------------------
-- 3. STATUS: data praktikum 2
--    Jika muncul error "Table ... doesn't exist" di sini, jalankan
--    P03_pulihkan_p2.sql terlebih dahulu.
-- ---------------------------------------------------------------------
SELECT 'Kategori 1 Minuman dan 2 Roti tersedia' AS cek,
  IF((SELECT COUNT(*) FROM categories
      WHERE (category_id = 1 AND category_name = 'Minuman')
         OR (category_id = 2 AND category_name = 'Roti')) = 2,
     'OK', 'CEK') AS status,
  'Jika CEK: jalankan P03_pulihkan_p2.sql, lalu cek lagi' AS tindakan
UNION ALL
SELECT 'Produk P01, P02, P03 dengan stok 20, 15, 30',
  IF((SELECT COUNT(*) FROM products
      WHERE (sku = 'P01' AND stock_qty = 20)
         OR (sku = 'P02' AND stock_qty = 15)
         OR (sku = 'P03' AND stock_qty = 30)) = 3,
     'OK', 'CEK'),
  'Jika CEK: jalankan P03_pulihkan_p2.sql, lalu cek lagi'
UNION ALL
SELECT 'Tidak ada SKU ganda',
  IF(NOT EXISTS(SELECT sku FROM products GROUP BY sku HAVING COUNT(*) > 1),
     'OK', 'MASALAH'),
  'Jika MASALAH: jangan ALTER di langkah C, panggil dosen'
UNION ALL
SELECT 'ID produk 99 belum dipakai (untuk uji langkah D)',
  IF(NOT EXISTS(SELECT 1 FROM products WHERE product_id = 99),
     'OK', 'MASALAH'),
  'Jika MASALAH: panggil dosen sebelum langkah D';

-- ---------------------------------------------------------------------
-- 4. Struktur dan data awal (Bukti 1)
-- ---------------------------------------------------------------------
DESCRIBE products;

SHOW INDEX FROM products;

SELECT category_id, category_name
FROM categories ORDER BY category_id;

SELECT product_id, sku, stock_qty
FROM products ORDER BY product_id;
