-- =====================================================================
-- DM099 Praktikum 3 - P03_cek_mandiri.sql
-- Pemeriksaan akhir mandiri setelah langkah B, C, dan D
--
-- KAPAN DIPAKAI
--   Setelah INSERT uji SKU ganda dijalankan (langkah E), sebelum
--   menyimpan berkas. Boleh juga dijalankan setelah langkah B atau C;
--   baris untuk langkah berikutnya akan BELUM sampai langkah itu selesai.
--   Jika muncul error "Table ... customers doesn't exist", kerjakan
--   langkah B terlebih dahulu.
--   Berkas ini hanya membaca data. Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Semua baris harus OK. Ikuti kolom "tindakan" untuk baris lain.
--   4. Panggil dosen hanya jika tindakan memintanya.
--   5. Tangkapan layar hasil ini melengkapi Bukti 4.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

SELECT '1. Tabel customers tersedia' AS cek,
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'),
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan CREATE TABLE di langkah B' AS tindakan
UNION ALL
SELECT '2. Kolom customers: tipe dan NULL sesuai bagian 3 modul',
  CASE
    WHEN NOT EXISTS(SELECT 1 FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers')
      THEN 'BELUM'
    WHEN (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'
            AND ((COLUMN_NAME = 'customer_id' AND COLUMN_TYPE LIKE 'int%unsigned' AND IS_NULLABLE = 'NO')
              OR (COLUMN_NAME = 'full_name'   AND COLUMN_TYPE = 'varchar(100)'   AND IS_NULLABLE = 'NO')
              OR (COLUMN_NAME = 'email'       AND COLUMN_TYPE = 'varchar(160)'   AND IS_NULLABLE = 'YES')
              OR (COLUMN_NAME = 'created_at'  AND COLUMN_TYPE = 'date'           AND IS_NULLABLE = 'NO'))) = 4
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers') = 4
      THEN 'OK'
    ELSE 'CEK'
  END,
  'Jika CEK: bandingkan DESCRIBE customers dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '3. PRIMARY KEY pada customer_id',
  IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'
              AND INDEX_NAME = 'PRIMARY' AND COLUMN_NAME = 'customer_id')
     AND (SELECT COUNT(*) FROM information_schema.STATISTICS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customers'
            AND INDEX_NAME = 'PRIMARY') = 1,
     'OK', 'BELUM'),
  'Jika BELUM setelah langkah B: panggil dosen'
UNION ALL
SELECT '4. Indeks unik hanya berisi sku (Non_unique = 0)',
  IF(EXISTS(SELECT 1 FROM information_schema.STATISTICS s
            WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'products'
              AND s.NON_UNIQUE = 0 AND s.COLUMN_NAME = 'sku'
              AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                              WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                                AND s2.TABLE_NAME   = s.TABLE_NAME
                                AND s2.INDEX_NAME   = s.INDEX_NAME
                                AND s2.COLUMN_NAME <> 'sku')),
     'OK', 'BELUM'),
  'Jika BELUM: jalankan pemeriksaan dan ALTER di langkah C'
UNION ALL
SELECT '5. Tiga pelanggan Rani, Bima, Nisa tersimpan',
  IF((SELECT COUNT(*) FROM customers
      WHERE (customer_id = 1 AND full_name = 'Rani Sintetis')
         OR (customer_id = 2 AND full_name = 'Bima Sintetis')
         OR (customer_id = 3 AND full_name = 'Nisa Sintetis')) = 3
     AND (SELECT COUNT(*) FROM customers) = 3,
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT di langkah D; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '6. Email Bima bernilai NULL (bukan teks kosong atau ''NULL'')',
  IF(EXISTS(SELECT 1 FROM customers WHERE customer_id = 2 AND email IS NULL),
     'OK', 'BELUM'),
  'Jika BELUM: periksa apakah NULL ditulis tanpa tanda kutip, lalu panggil dosen'
UNION ALL
SELECT '7. Produk tetap 3 baris, stok P01, P02, P03 = 20, 15, 30',
  IF((SELECT COUNT(*) FROM products) = 3
     AND (SELECT COUNT(*) FROM products
          WHERE (sku = 'P01' AND stock_qty = 20)
             OR (sku = 'P02' AND stock_qty = 15)
             OR (sku = 'P03' AND stock_qty = 30)) = 3,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '8. Produk uji ID 99 tidak tersimpan',
  IF(NOT EXISTS(SELECT 1 FROM products WHERE product_id = 99),
     'OK', 'MASALAH'),
  'Jika MASALAH: SKU belum unik. Jangan hapus baris, panggil dosen';

-- Data akhir sebagai bukti pendukung
SELECT customer_id, full_name, email, created_at
FROM customers ORDER BY customer_id;
