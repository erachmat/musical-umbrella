-- =====================================================================
-- DM099 Praktikum 4 - P04_cek_mandiri.sql
-- Pemeriksaan akhir mandiri setelah langkah C dan D
--
-- KAPAN DIPAKAI
--   Setelah Uji 1 dan Uji 2 dijalankan (langkah E), sebelum menyimpan
--   berkas. Boleh juga dijalankan setelah langkah C untuk memeriksa
--   aturan saja; baris data akan BELUM sampai langkah D selesai.
--   Berkas ini hanya membaca data. Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Semua baris harus OK. Ikuti kolom "tindakan" untuk baris lain.
--   4. Panggil dosen hanya jika tindakan memintanya.
--   5. Tangkapan layar hasil ini melengkapi Bukti 3.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

SELECT '1. FK products.category_id -> categories' AS cek,
  IF(EXISTS(
       SELECT 1
       FROM information_schema.REFERENTIAL_CONSTRAINTS rc
       JOIN information_schema.KEY_COLUMN_USAGE k
         ON k.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
        AND k.CONSTRAINT_NAME   = rc.CONSTRAINT_NAME
        AND k.TABLE_NAME        = rc.TABLE_NAME
       WHERE rc.CONSTRAINT_SCHEMA     = DATABASE()
         AND rc.TABLE_NAME            = 'products'
         AND rc.REFERENCED_TABLE_NAME = 'categories'
         AND k.COLUMN_NAME            = 'category_id'),
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan ALTER foreign key di langkah C' AS tindakan
UNION ALL
SELECT '2. FK: ON UPDATE CASCADE, ON DELETE RESTRICT',
  CASE
    WHEN NOT EXISTS(
       SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS
       WHERE CONSTRAINT_SCHEMA     = DATABASE()
         AND TABLE_NAME            = 'products'
         AND REFERENCED_TABLE_NAME = 'categories') THEN 'BELUM'
    WHEN EXISTS(
       SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS
       WHERE CONSTRAINT_SCHEMA     = DATABASE()
         AND TABLE_NAME            = 'products'
         AND REFERENCED_TABLE_NAME = 'categories'
         AND UPDATE_RULE = 'CASCADE'
         AND DELETE_RULE = 'RESTRICT') THEN 'OK'
    ELSE 'CEK'
  END,
  'Jika CEK: bandingkan SHOW CREATE TABLE dengan langkah C, lalu panggil dosen'
UNION ALL
SELECT '3. CHECK (unit_price >= 0) terpasang',
  IF(EXISTS(
       SELECT 1
       FROM information_schema.TABLE_CONSTRAINTS tc
       JOIN information_schema.CHECK_CONSTRAINTS cc
         ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
        AND cc.CONSTRAINT_NAME   = tc.CONSTRAINT_NAME
       WHERE tc.TABLE_SCHEMA    = DATABASE()
         AND tc.TABLE_NAME      = 'products'
         AND tc.CONSTRAINT_TYPE = 'CHECK'
         AND cc.CHECK_CLAUSE LIKE '%unit_price%'),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan ALTER CHECK harga di langkah C'
UNION ALL
SELECT '4. Kategori 3 Alat Tulis tersedia',
  IF(EXISTS(SELECT 1 FROM categories
            WHERE category_id = 3 AND category_name = 'Alat Tulis'),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan pemeriksaan dan INSERT di langkah D'
UNION ALL
SELECT '5. Produk 4 P04 Pensil Uji sesuai contoh',
  IF(EXISTS(SELECT 1 FROM products
            WHERE product_id = 4 AND sku = 'P04'
              AND product_name = 'Pensil Uji' AND category_id = 3
              AND unit_price = 3000.00 AND stock_qty = 10),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan langkah D; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '6. Jumlah 3 kategori, 4 produk, 3 pelanggan',
  IF((SELECT COUNT(*) FROM categories) = 3
     AND (SELECT COUNT(*) FROM products) = 4
     AND (SELECT COUNT(*) FROM customers) = 3,
     'OK', 'BELUM'),
  'Harus OK setelah langkah D. Jika tetap BELUM: lihat SELECT di bawah, panggil dosen'
UNION ALL
SELECT '7. Stok P01, P02, P03 tetap 20, 15, 30',
  IF((SELECT COUNT(*) FROM products
      WHERE (sku = 'P01' AND stock_qty = 20)
         OR (sku = 'P02' AND stock_qty = 15)
         OR (sku = 'P03' AND stock_qty = 30)) = 3,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '8. Baris uji ID 98 dan 99 tidak tersimpan',
  IF(NOT EXISTS(SELECT 1 FROM products
                WHERE product_id IN (98, 99) OR sku IN ('P98', 'P99')),
     'OK', 'MASALAH'),
  'Jika MASALAH: aturan tidak bekerja. Jangan hapus baris, panggil dosen';

-- Data akhir sebagai bukti pendukung
SELECT product_id, sku, category_id, unit_price, stock_qty
FROM products ORDER BY product_id;
