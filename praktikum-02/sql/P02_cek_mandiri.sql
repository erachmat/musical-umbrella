-- =====================================================================
-- DM099 Praktikum 2 - P02_cek_mandiri.sql
-- Pemeriksaan akhir mandiri setelah langkah B, C, dan D
--
-- KAPAN DIPAKAI
--   - Di langkah E, sebelum menyimpan berkas SQL.
--   - Jika cek awal menunjukkan tabel sudah ada (INFO), untuk melihat
--     bagian mana yang sudah selesai dan mana yang perlu dikerjakan.
--   - Jika INSERT berhenti di tengah, untuk melihat baris mana yang
--     sudah tersimpan.
--   Berkas ini hanya membaca data. Aman dijalankan ulang.
--   Jika muncul error "Table ... doesn't exist", kerjakan langkah B
--   terlebih dahulu.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Semua baris harus OK. Ikuti kolom "tindakan" untuk baris lain.
--   4. Panggil dosen hanya jika tindakan memintanya.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

SELECT '1. Tabel categories dan products tersedia (InnoDB)' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('categories', 'products')
        AND ENGINE = 'InnoDB') = 2,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan CREATE TABLE di langkah B' AS tindakan
UNION ALL
SELECT '2. Kolom categories sesuai Gambar 1, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'categories'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'category_id'   AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'category_name' AND COLUMN_TYPE = 'varchar(60)'))) = 2
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'categories') = 2,
     'OK', 'CEK'),
  'Jika CEK: bandingkan DESCRIBE categories dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '3. Kolom products sesuai Gambar 1, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'product_id'   AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'sku'          AND COLUMN_TYPE = 'varchar(20)')
          OR (COLUMN_NAME = 'product_name' AND COLUMN_TYPE = 'varchar(100)')
          OR (COLUMN_NAME = 'category_id'  AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'unit_price'   AND COLUMN_TYPE = 'decimal(12,2)')
          OR (COLUMN_NAME = 'stock_qty'    AND COLUMN_TYPE LIKE 'int%unsigned'))) = 6
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products') = 6,
     'OK', 'CEK'),
  'Jika CEK: bandingkan DESCRIBE products dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '4. PRIMARY KEY: categories.category_id dan products.product_id',
  IF((SELECT COUNT(*) FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND INDEX_NAME = 'PRIMARY'
        AND ((TABLE_NAME = 'categories' AND COLUMN_NAME = 'category_id')
          OR (TABLE_NAME = 'products'   AND COLUMN_NAME = 'product_id'))) = 2
     AND (SELECT COUNT(*) FROM information_schema.STATISTICS
          WHERE TABLE_SCHEMA = DATABASE() AND INDEX_NAME = 'PRIMARY'
            AND TABLE_NAME IN ('categories', 'products')) = 2,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '5. Kategori 1 Minuman dan 2 Roti, tidak ada baris lain',
  IF((SELECT COUNT(*) FROM categories
      WHERE (category_id = 1 AND category_name = 'Minuman')
         OR (category_id = 2 AND category_name = 'Roti')) = 2
     AND (SELECT COUNT(*) FROM categories) = 2,
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT categories di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '6. P01 Teh Botol: kategori 1, harga 5000.00, stok 20',
  IF(EXISTS(SELECT 1 FROM products
            WHERE product_id = 1 AND sku = 'P01' AND product_name = 'Teh Botol'
              AND category_id = 1 AND unit_price = 5000.00 AND stock_qty = 20),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT products di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '7. P02 Roti Cokelat: kategori 2, harga 8000.00, stok 15',
  IF(EXISTS(SELECT 1 FROM products
            WHERE product_id = 2 AND sku = 'P02' AND product_name = 'Roti Cokelat'
              AND category_id = 2 AND unit_price = 8000.00 AND stock_qty = 15),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT products di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '8. P03 Air Mineral: kategori 1, harga 4000.00, stok 30',
  IF(EXISTS(SELECT 1 FROM products
            WHERE product_id = 3 AND sku = 'P03' AND product_name = 'Air Mineral'
              AND category_id = 1 AND unit_price = 4000.00 AND stock_qty = 30),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT products di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '9. Tabel products berisi tepat 3 baris',
  CASE
    WHEN (SELECT COUNT(*) FROM products) = 3 THEN 'OK'
    WHEN (SELECT COUNT(*) FROM products) < 3 THEN 'BELUM'
    ELSE 'CEK'
  END,
  'BELUM: lihat baris 6-8. CEK (lebih dari 3): panggil dosen, jangan hapus sendiri';
