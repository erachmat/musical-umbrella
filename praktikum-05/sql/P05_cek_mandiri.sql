-- =====================================================================
-- DM099 Praktikum 5 - P05_cek_mandiri.sql
-- Pemeriksaan akhir mandiri setelah langkah B, C, dan D
--
-- KAPAN DIPAKAI
--   - Di langkah E, sebelum menyimpan berkas SQL.
--   - Jika cek awal menunjukkan products_v2 sudah ada (INFO), untuk
--     melihat bagian mana yang sudah selesai.
--   Boleh dijalankan setelah langkah B; baris data akan BELUM sampai
--   langkah C selesai. Jika muncul error "Table ... products_v2 doesn't
--   exist", kerjakan langkah B terlebih dahulu.
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

SELECT '1. products_v2 tersedia dan memakai InnoDB' AS cek,
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2'
              AND ENGINE = 'InnoDB'),
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan CREATE TABLE di langkah B' AS tindakan
UNION ALL
SELECT '2. Lima kolom sesuai Tabel 2, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'product_id'   AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'sku'          AND COLUMN_TYPE = 'varchar(20)')
          OR (COLUMN_NAME = 'product_name' AND COLUMN_TYPE = 'varchar(100)')
          OR (COLUMN_NAME = 'category_id'  AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'unit_price'   AND COLUMN_TYPE = 'decimal(12,2)'))) = 5
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2') = 5,
     'OK', 'CEK'),
  'Jika CEK: bandingkan SHOW CREATE TABLE dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '3. PRIMARY KEY pada product_id',
  IF((SELECT COUNT(*) FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2'
        AND INDEX_NAME = 'PRIMARY') = 1
     AND EXISTS(SELECT 1 FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products_v2'
                  AND INDEX_NAME = 'PRIMARY' AND COLUMN_NAME = 'product_id'),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '4. UNIQUE hanya berisi sku',
  IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS s
            WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'products_v2'
              AND s.NON_UNIQUE = 0 AND s.COLUMN_NAME = 'sku'
              AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                              WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                                AND s2.TABLE_NAME   = s.TABLE_NAME
                                AND s2.INDEX_NAME   = s.INDEX_NAME
                                AND s2.COLUMN_NAME <> 'sku')),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '5. FOREIGN KEY category_id -> categories',
  IF(EXISTS(
       SELECT 1
       FROM information_schema.REFERENTIAL_CONSTRAINTS rc
       JOIN information_schema.KEY_COLUMN_USAGE k
         ON k.CONSTRAINT_SCHEMA = rc.CONSTRAINT_SCHEMA
        AND k.CONSTRAINT_NAME   = rc.CONSTRAINT_NAME
        AND k.TABLE_NAME        = rc.TABLE_NAME
       WHERE rc.CONSTRAINT_SCHEMA     = DATABASE()
         AND rc.TABLE_NAME            = 'products_v2'
         AND rc.REFERENCED_TABLE_NAME = 'categories'
         AND k.COLUMN_NAME            = 'category_id'),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '6. CHECK (unit_price >= 0)',
  IF(EXISTS(
       SELECT 1
       FROM information_schema.TABLE_CONSTRAINTS tc
       JOIN information_schema.CHECK_CONSTRAINTS cc
         ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
        AND cc.CONSTRAINT_NAME   = tc.CONSTRAINT_NAME
       WHERE tc.TABLE_SCHEMA    = DATABASE()
         AND tc.TABLE_NAME      = 'products_v2'
         AND tc.CONSTRAINT_TYPE = 'CHECK'
         AND cc.CHECK_CLAUSE LIKE '%unit_price%'),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '7. Produk 101 L01 Teh Latihan dan 102 L02 Pensil Latihan',
  IF((SELECT COUNT(*) FROM products_v2
      WHERE (product_id = 101 AND sku = 'L01' AND product_name = 'Teh Latihan'
             AND category_id = 1 AND unit_price = 5000.00)
         OR (product_id = 102 AND sku = 'L02' AND product_name = 'Pensil Latihan'
             AND category_id = 3 AND unit_price = 3000.00)) = 2,
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '8. products_v2 berisi tepat 2 baris',
  CASE
    WHEN (SELECT COUNT(*) FROM products_v2) = 2 THEN 'OK'
    WHEN (SELECT COUNT(*) FROM products_v2) < 2 THEN 'BELUM'
    ELSE 'CEK'
  END,
  'BELUM: lihat baris 7. CEK (lebih dari 2): lihat baris 9, panggil dosen'
UNION ALL
SELECT '9. Baris uji ID 191, 192, 193 tidak tersimpan',
  IF(NOT EXISTS(SELECT 1 FROM products_v2
                WHERE product_id IN (191, 192, 193) OR sku IN ('L91', 'L93')),
     'OK', 'MASALAH'),
  'Jika MASALAH: aturan tidak bekerja. Jangan hapus baris, panggil dosen'
UNION ALL
SELECT '10. Data lama tetap: 3 kategori, 4 produk, 3 pelanggan',
  IF((SELECT COUNT(*) FROM categories) = 3
     AND (SELECT COUNT(*) FROM products) = 4
     AND (SELECT COUNT(*) FROM customers) = 3,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen';

-- Hasil JOIN langkah E sebagai bukti pendukung
SELECT p.product_id, p.sku, c.category_name
FROM products_v2 AS p
JOIN categories AS c ON p.category_id = c.category_id
ORDER BY p.product_id;
