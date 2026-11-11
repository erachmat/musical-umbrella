-- =====================================================================
-- DM099 Praktikum 6 - P06_cek_mandiri.sql
-- Pemeriksaan akhir mandiri setelah langkah B, C, dan D
--
-- KAPAN DIPAKAI
--   - Di langkah E, sebelum menyimpan berkas SQL.
--   - Jika cek awal menunjukkan sales atau sale_items sudah ada (INFO),
--     untuk melihat bagian mana yang sudah selesai.
--   Boleh dijalankan setelah langkah B; baris data akan BELUM sampai
--   langkah C selesai. Jika muncul error "Table ... doesn't exist",
--   kerjakan langkah B terlebih dahulu.
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

SELECT '1. sales dan sale_items tersedia (InnoDB)' AS cek,
  IF((SELECT COUNT(*) FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME IN ('sales', 'sale_items') AND ENGINE = 'InnoDB') = 2,
     'OK', 'BELUM') AS status,
  'Jika BELUM: jalankan CREATE TABLE di langkah B' AS tindakan
UNION ALL
SELECT '2. Lima kolom sales sesuai langkah B, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sales'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'sale_id'     AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'invoice_no'  AND COLUMN_TYPE = 'varchar(24)')
          OR (COLUMN_NAME = 'customer_id' AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'sale_at'     AND COLUMN_TYPE = 'datetime')
          OR (COLUMN_NAME = 'status'      AND COLUMN_TYPE = 'varchar(12)'))) = 5
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sales') = 5,
     'OK', 'CEK'),
  'Jika CEK: bandingkan SHOW CREATE TABLE sales dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '3. sales: PK sale_id dan UNIQUE invoice_no',
  IF((SELECT GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX)
      FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sales'
        AND INDEX_NAME = 'PRIMARY') = 'sale_id'
     AND EXISTS(SELECT 1 FROM information_schema.STATISTICS s
                WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'sales'
                  AND s.NON_UNIQUE = 0 AND s.INDEX_NAME <> 'PRIMARY'
                  AND s.COLUMN_NAME = 'invoice_no'
                  AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                                  WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                                    AND s2.TABLE_NAME   = s.TABLE_NAME
                                    AND s2.INDEX_NAME   = s.INDEX_NAME
                                    AND s2.COLUMN_NAME <> 'invoice_no')),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '4. FK sales.customer_id -> customers',
  IF(EXISTS(SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sales'
              AND COLUMN_NAME = 'customer_id'
              AND REFERENCED_TABLE_NAME = 'customers'
              AND REFERENCED_COLUMN_NAME = 'customer_id'),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '5. Empat kolom sale_items sesuai langkah B, semuanya NOT NULL',
  IF((SELECT COUNT(*) FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items'
        AND IS_NULLABLE = 'NO'
        AND ((COLUMN_NAME = 'sale_id'    AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'product_id' AND COLUMN_TYPE LIKE 'int%unsigned')
          OR (COLUMN_NAME = 'quantity'   AND COLUMN_TYPE LIKE 'int%')
          OR (COLUMN_NAME = 'unit_price' AND COLUMN_TYPE = 'decimal(12,2)'))) = 4
     AND (SELECT COUNT(*) FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items') = 4,
     'OK', 'CEK'),
  'Jika CEK: bandingkan SHOW CREATE TABLE sale_items dengan langkah B, lalu panggil dosen'
UNION ALL
SELECT '6. sale_items: PK gabungan (sale_id, product_id)',
  IF((SELECT GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX)
      FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items'
        AND INDEX_NAME = 'PRIMARY') = 'sale_id,product_id',
     'OK', 'CEK'),
  'Jika CEK: panggil dosen (jangan buat UNIQUE pada product_id saja)'
UNION ALL
SELECT '7. Dua FK sale_items -> sales dan -> products (bukan products_v2)',
  IF(EXISTS(SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items'
              AND COLUMN_NAME = 'sale_id' AND REFERENCED_TABLE_NAME = 'sales')
     AND EXISTS(SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sale_items'
                  AND COLUMN_NAME = 'product_id' AND REFERENCED_TABLE_NAME = 'products'),
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '8. Dua CHECK: quantity > 0 dan unit_price >= 0',
  IF((SELECT COUNT(*)
      FROM information_schema.TABLE_CONSTRAINTS tc
      JOIN information_schema.CHECK_CONSTRAINTS cc
        ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
       AND cc.CONSTRAINT_NAME   = tc.CONSTRAINT_NAME
      WHERE tc.TABLE_SCHEMA = DATABASE() AND tc.TABLE_NAME = 'sale_items'
        AND tc.CONSTRAINT_TYPE = 'CHECK'
        AND (cc.CHECK_CLAUSE LIKE '%quantity%' OR cc.CHECK_CLAUSE LIKE '%unit_price%')) = 2,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen'
UNION ALL
SELECT '9. Penjualan 601 (pelanggan 1) dan 602 (pelanggan 2), DRAFT',
  IF((SELECT COUNT(*) FROM sales
      WHERE (sale_id = 601 AND invoice_no = 'INV-L06-001' AND customer_id = 1 AND status = 'DRAFT')
         OR (sale_id = 602 AND invoice_no = 'INV-L06-002' AND customer_id = 2 AND status = 'DRAFT')) = 2,
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT sales di langkah C; jika datanya berbeda, panggil dosen'
UNION ALL
SELECT '10. Tiga detail: (601,1)x2, (601,2)x1, (602,1)x1',
  IF((SELECT COUNT(*) FROM sale_items
      WHERE (sale_id = 601 AND product_id = 1 AND quantity = 2 AND unit_price = 5000.00)
         OR (sale_id = 601 AND product_id = 2 AND quantity = 1 AND unit_price = 8000.00)
         OR (sale_id = 602 AND product_id = 1 AND quantity = 1 AND unit_price = 5000.00)) = 3
     AND (SELECT COUNT(*) FROM sale_items) = 3,
     'OK', 'BELUM'),
  'Jika BELUM: jalankan INSERT sale_items di langkah C; jika ada baris lain, lihat baris 11'
UNION ALL
SELECT '11. Baris uji tidak tersimpan',
  IF(NOT EXISTS(SELECT 1 FROM sale_items
                WHERE sale_id = 699 OR product_id = 999
                   OR (sale_id = 601 AND product_id = 3)
                   OR (sale_id = 602 AND product_id = 2)),
     'OK', 'MASALAH'),
  'Jika MASALAH: aturan tidak bekerja. Jangan hapus baris, panggil dosen'
UNION ALL
SELECT '12. Data lama tetap: 3 kategori, 4 produk, 3 pelanggan, 2 products_v2',
  IF((SELECT COUNT(*) FROM categories) = 3
     AND (SELECT COUNT(*) FROM products) = 4
     AND (SELECT COUNT(*) FROM customers) = 3
     AND (SELECT COUNT(*) FROM products_v2) = 2,
     'OK', 'CEK'),
  'Jika CEK: panggil dosen';

-- Hasil JOIN langkah E sebagai bukti pendukung
SELECT s.invoice_no, p.product_name,
       i.quantity, i.unit_price,
       i.quantity * i.unit_price AS subtotal
FROM sales AS s
JOIN sale_items AS i ON i.sale_id = s.sale_id
JOIN products AS p ON p.product_id = i.product_id
WHERE s.sale_id IN (601, 602)
ORDER BY s.sale_id, i.product_id;
