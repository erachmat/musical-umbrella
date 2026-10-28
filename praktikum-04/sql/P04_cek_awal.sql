-- =====================================================================
-- DM099 Praktikum 4 - P04_cek_awal.sql
-- Gabungan langkah A dan B: memeriksa hasil praktikum 3 sebelum ALTER
--
-- KAPAN DIPAKAI
--   Saat masuk lab, sambil menunggu absensi (07.00-07.15).
--   Berkas ini hanya membaca data (SELECT dan SHOW). Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Lihat tabel hasil "STATUS". Semua baris harus OK.
--   4. Ambil tangkapan layar untuk Bukti 1: bagian 1, STATUS, dan bagian 4.
--
-- JIKA ADA YANG BUKAN OK
--   Ikuti kolom "tindakan". Jika muncul error "Table ... doesn't exist",
--   jalankan P04_pulihkan_p3.sql, lalu jalankan berkas ini lagi.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Lingkungan praktik (Bukti 1)
-- ---------------------------------------------------------------------
SELECT DATABASE()  AS database_aktif,
       VERSION()   AS versi_server,
       @@sql_mode  AS mode_sql;

-- ---------------------------------------------------------------------
-- 2. STATUS: tabel praktikum 3
--    Bagian ini hanya membaca information_schema, sehingga tetap
--    berjalan walaupun tabel belum ada.
-- ---------------------------------------------------------------------
SELECT 'Tabel categories, products, customers tersedia' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products', 'customers')) = 3,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan P04_pulihkan_p3.sql' AS tindakan
UNION ALL
SELECT 'categories dan products memakai InnoDB',
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products')
        AND ENGINE = 'InnoDB') = 2,
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen (FK butuh InnoDB)'
UNION ALL
SELECT 'Tipe category_id sama dan UNSIGNED di kedua tabel',
  IF((SELECT COUNT(DISTINCT COLUMN_TYPE) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products')
        AND COLUMN_NAME = 'category_id') = 1
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME IN ('categories', 'products')
            AND COLUMN_NAME = 'category_id'
            AND COLUMN_TYPE LIKE '%unsigned%') = 2,
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen (FK akan gagal)'
UNION ALL
SELECT 'unit_price bertipe DECIMAL(12,2) NOT NULL',
  IF(EXISTS(SELECT 1 FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'products'
              AND COLUMN_NAME = 'unit_price'
              AND COLUMN_TYPE = 'decimal(12,2)'
              AND IS_NULLABLE = 'NO'),
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen'
UNION ALL
SELECT 'sku memiliki indeks unik (langkah C praktikum 3)',
  IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS s
            WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'products'
              AND s.NON_UNIQUE = 0 AND s.COLUMN_NAME = 'sku'
              AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                              WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                                AND s2.TABLE_NAME   = s.TABLE_NAME
                                AND s2.INDEX_NAME   = s.INDEX_NAME
                                AND s2.COLUMN_NAME <> 'sku')),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan P04_pulihkan_p3.sql, lalu cek lagi'
UNION ALL
SELECT 'Struktur customers sesuai praktikum 3',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'
        AND ((COLUMN_NAME = 'customer_id' AND COLUMN_TYPE LIKE 'int%unsigned'
              AND IS_NULLABLE = 'NO' AND COLUMN_KEY = 'PRI')
          OR (COLUMN_NAME = 'full_name' AND COLUMN_TYPE = 'varchar(100)'
              AND IS_NULLABLE = 'NO')
          OR (COLUMN_NAME = 'email' AND COLUMN_TYPE = 'varchar(160)'
              AND IS_NULLABLE = 'YES')
          OR (COLUMN_NAME = 'created_at' AND COLUMN_TYPE = 'date'
              AND IS_NULLABLE = 'NO'))) = 4,
     'OK', 'CEK'),
  'Jika CEK dan baris pertama OK: panggil dosen';

-- ---------------------------------------------------------------------
-- 3. STATUS: data praktikum 3
--    Jika muncul error "Table ... doesn't exist" di sini, jalankan
--    P04_pulihkan_p3.sql terlebih dahulu.
-- ---------------------------------------------------------------------
SELECT 'Kategori 1 Minuman dan 2 Roti tersedia' AS cek,
  IF((SELECT COUNT(*) FROM categories
      WHERE (category_id = 1 AND category_name = 'Minuman')
         OR (category_id = 2 AND category_name = 'Roti')) = 2,
     'OK', 'CEK') AS status,
  'Jika CEK: jalankan P04_pulihkan_p3.sql, lalu cek lagi' AS tindakan
UNION ALL
SELECT 'Produk P01, P02, P03 dengan stok 20, 15, 30',
  IF((SELECT COUNT(*) FROM products
      WHERE (sku = 'P01' AND stock_qty = 20)
         OR (sku = 'P02' AND stock_qty = 15)
         OR (sku = 'P03' AND stock_qty = 30)) = 3,
     'OK', 'CEK'),
  'Jika CEK: jalankan P04_pulihkan_p3.sql, lalu cek lagi'
UNION ALL
SELECT 'Tabel customers berisi 3 pelanggan',
  IF((SELECT COUNT(*) FROM customers) = 3, 'OK', 'CEK'),
  'Jika CEK: jalankan P04_pulihkan_p3.sql, lalu cek lagi'
UNION ALL
SELECT 'Tidak ada produk dengan kategori tidak tersedia',
  IF(NOT EXISTS(SELECT 1 FROM products p
                WHERE p.category_id NOT IN (SELECT category_id FROM categories)),
     'OK', 'MASALAH'),
  'Jika MASALAH: jangan ALTER, panggil dosen'
UNION ALL
SELECT 'Tidak ada produk dengan harga negatif',
  IF(NOT EXISTS(SELECT 1 FROM products WHERE unit_price < 0),
     'OK', 'MASALAH'),
  'Jika MASALAH: jangan ALTER, panggil dosen';

-- ---------------------------------------------------------------------
-- 4. Data awal dan constraint yang sudah ada (Bukti 1)
-- ---------------------------------------------------------------------
SELECT category_id, category_name
FROM categories ORDER BY category_id;

SELECT product_id, sku, category_id, unit_price, stock_qty
FROM products ORDER BY product_id;

SELECT customer_id, full_name, email, created_at
FROM customers ORDER BY customer_id;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'products';

SHOW CREATE TABLE products;
