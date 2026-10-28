-- =====================================================================
-- DM099 Praktikum 4 - P04_pulihkan_p3.sql
-- Memulihkan kondisi akhir praktikum 3 (categories, products, customers)
--
-- KAPAN DIPAKAI
--   Hanya jika P04_cek_awal.sql menunjukkan tabel atau data praktikum 3
--   belum lengkap. Jika semua baris di cek awal sudah OK, JANGAN
--   jalankan berkas ini.
--
-- AMAN DIJALANKAN ULANG
--   Berkas ini tidak memakai DROP, TRUNCATE, DELETE, atau UPDATE.
--   - Tabel hanya dibuat jika belum ada (CREATE TABLE IF NOT EXISTS).
--   - Baris hanya ditambah jika ID-nya belum ada (WHERE NOT EXISTS).
--   - Indeks unik sku hanya ditambah jika belum ada dan tidak ada SKU ganda.
--   - Baris yang sudah ada tidak diubah.
--   Jika tabel sudah ada tetapi strukturnya berbeda, berkas ini tidak
--   memperbaikinya. Panggil dosen.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Jalankan lagi P04_cek_awal.sql.
--
-- CATATAN DOSEN: struktur products dan customers serta data pelanggan
-- mengikuti modul praktikum 3. Panjang category_name, nama produk, dan
-- harga P01-P03 berasal dari praktikum 2 dan masih berupa contoh;
-- sesuaikan dengan modul praktikum 2 sebelum dibagikan (tanda: SESUAIKAN P2).
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Struktur tabel (kondisi akhir praktikum 3, belum ada FK dan CHECK)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id   INT UNSIGNED  NOT NULL,
  category_name VARCHAR(50)   NOT NULL,  -- SESUAIKAN P2
  PRIMARY KEY (category_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS products (
  product_id   INT UNSIGNED  NOT NULL,
  sku          VARCHAR(20)   NOT NULL,
  product_name VARCHAR(100)  NOT NULL,
  category_id  INT UNSIGNED  NOT NULL,
  unit_price   DECIMAL(12,2) NOT NULL,
  stock_qty    INT UNSIGNED  NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT uq_products_sku UNIQUE (sku)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT UNSIGNED  NOT NULL,
  full_name   VARCHAR(100)  NOT NULL,
  email       VARCHAR(160)  NULL,
  created_at  DATE          NOT NULL,
  PRIMARY KEY (customer_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ---------------------------------------------------------------------
-- 2. Data awal (hanya baris yang ID-nya belum ada)
-- ---------------------------------------------------------------------
INSERT INTO categories (category_id, category_name)
SELECT 1, 'Minuman' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE category_id = 1);

INSERT INTO categories (category_id, category_name)
SELECT 2, 'Roti' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE category_id = 2);

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 1, 'P01', 'Air Mineral 600 ml', 1, 3500.00, 20 FROM DUAL  -- SESUAIKAN P2: nama, harga
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 1 OR sku = 'P01');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 2, 'P02', 'Teh Manis Botol', 1, 5000.00, 15 FROM DUAL  -- SESUAIKAN P2: nama, harga
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 2 OR sku = 'P02');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 3, 'P03', 'Roti Tawar', 2, 15000.00, 30 FROM DUAL  -- SESUAIKAN P2: nama, harga
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 3 OR sku = 'P03');

-- Data pelanggan sama dengan langkah D praktikum 3
INSERT INTO customers (customer_id, full_name, email, created_at)
SELECT 1, 'Rani Sintetis', 'rani@example.com', CURRENT_DATE() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 1);

INSERT INTO customers (customer_id, full_name, email, created_at)
SELECT 2, 'Bima Sintetis', NULL, CURRENT_DATE() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 2);

INSERT INTO customers (customer_id, full_name, email, created_at)
SELECT 3, 'Nisa Sintetis', 'nisa@example.com', CURRENT_DATE() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 3);

-- ---------------------------------------------------------------------
-- 3. Indeks unik sku (langkah C praktikum 3)
--    Ditambahkan hanya jika sku belum memiliki indeks unik dan tidak ada
--    SKU ganda. Jika ada SKU ganda, tabel tidak diubah: panggil dosen.
-- ---------------------------------------------------------------------
SET @sku_sudah_unik = EXISTS(
  SELECT 1 FROM information_schema.STATISTICS s
  WHERE s.TABLE_SCHEMA = DATABASE() AND s.TABLE_NAME = 'products'
    AND s.NON_UNIQUE = 0 AND s.COLUMN_NAME = 'sku'
    AND NOT EXISTS (SELECT 1 FROM information_schema.STATISTICS s2
                    WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
                      AND s2.TABLE_NAME   = s.TABLE_NAME
                      AND s2.INDEX_NAME   = s.INDEX_NAME
                      AND s2.COLUMN_NAME <> 'sku'));
SET @ada_sku_ganda = EXISTS(
  SELECT sku FROM products GROUP BY sku HAVING COUNT(*) > 1);
SET @perintah = CASE
  WHEN @sku_sudah_unik THEN
    'SELECT ''sku sudah unik, tidak diubah'' AS indeks_sku'
  WHEN @ada_sku_ganda THEN
    'SELECT ''ADA SKU GANDA: tabel tidak diubah, panggil dosen'' AS indeks_sku'
  ELSE
    'ALTER TABLE products ADD CONSTRAINT uq_products_sku UNIQUE (sku)'
END;
PREPARE langkah FROM @perintah;
EXECUTE langkah;
DEALLOCATE PREPARE langkah;

-- ---------------------------------------------------------------------
-- 4. Hasil pemulihan
--    Harapan: 2 kategori, 3 produk, 3 pelanggan (atau 3, 4, 3 jika
--    langkah D praktikum 4 sudah dikerjakan).
--    Jika jumlahnya lebih atau datanya berbeda, panggil dosen.
-- ---------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM categories) AS jumlah_kategori,
  (SELECT COUNT(*) FROM products)   AS jumlah_produk,
  (SELECT COUNT(*) FROM customers)  AS jumlah_pelanggan;
