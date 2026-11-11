-- =====================================================================
-- DM099 Praktikum 6 - P06_pulihkan_p5.sql
-- Memulihkan kondisi akhir praktikum 5
-- (categories, products, customers, dan products_v2)
--
-- KAPAN DIPAKAI
--   Hanya jika P06_cek_awal.sql menunjukkan tabel, data, atau aturan
--   praktikum 2-5 belum lengkap. Jika semua baris di cek awal sudah OK
--   atau INFO, JANGAN jalankan berkas ini.
--
-- AMAN DIJALANKAN ULANG
--   Berkas ini tidak memakai DROP, TRUNCATE, DELETE, atau UPDATE.
--   - Tabel hanya dibuat jika belum ada (CREATE TABLE IF NOT EXISTS).
--   - Baris hanya ditambah jika ID-nya belum ada (WHERE NOT EXISTS).
--   - Indeks unik sku, foreign key, dan CHECK hanya ditambah jika belum
--     ada dan datanya tidak melanggar aturan.
--   - Baris yang sudah ada tidak diubah.
--   - Tabel sales dan sale_items TIDAK dibuat di sini, karena itu
--     pekerjaan praktikum 6 (langkah B).
--   Jika tabel sudah ada tetapi strukturnya berbeda, berkas ini tidak
--   memperbaikinya. Panggil dosen.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Jalankan lagi P06_cek_awal.sql.
--
-- Struktur dan data sama dengan modul praktikum 2, 3, 4, dan 5.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Struktur tabel (dibuat seperti praktikum 2 dan 3)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id   INT UNSIGNED  NOT NULL,
  category_name VARCHAR(60)   NOT NULL,
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
SELECT 1, 'P01', 'Teh Botol',    1, 5000.00, 20 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 1 OR sku = 'P01');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 2, 'P02', 'Roti Cokelat', 2, 8000.00, 15 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 2 OR sku = 'P02');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 3, 'P03', 'Air Mineral',  1, 4000.00, 30 FROM DUAL
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
-- 4. Data praktikum 4 (langkah D): kategori 3 dan produk P04
-- ---------------------------------------------------------------------
INSERT INTO categories (category_id, category_name)
SELECT 3, 'Alat Tulis' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE category_id = 3);

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 4, 'P04', 'Pensil Uji', 3, 3000.00, 10 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 4 OR sku = 'P04');

-- ---------------------------------------------------------------------
-- 5. Aturan praktikum 4 (langkah C)
--    Foreign key dan CHECK ditambahkan hanya jika belum ada dan data
--    tidak melanggar. Jika data melanggar, tabel tidak diubah.
-- ---------------------------------------------------------------------
SET @fk_sudah_ada = EXISTS(
  SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
    AND REFERENCED_TABLE_NAME = 'categories');
SET @ada_tanpa_kategori = EXISTS(
  SELECT 1 FROM products
  WHERE category_id NOT IN (SELECT category_id FROM categories));
SET @perintah = CASE
  WHEN @fk_sudah_ada THEN
    'SELECT ''foreign key kategori sudah ada, tidak diubah'' AS foreign_key'
  WHEN @ada_tanpa_kategori THEN
    'SELECT ''ADA PRODUK TANPA KATEGORI: tabel tidak diubah, panggil dosen'' AS foreign_key'
  ELSE
    'ALTER TABLE products ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories (category_id) ON UPDATE CASCADE ON DELETE RESTRICT'
END;
PREPARE langkah FROM @perintah;
EXECUTE langkah;
DEALLOCATE PREPARE langkah;

SET @check_sudah_ada = EXISTS(
  SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products'
    AND CONSTRAINT_TYPE = 'CHECK');
SET @ada_harga_negatif = EXISTS(SELECT 1 FROM products WHERE unit_price < 0);
SET @perintah = CASE
  WHEN @check_sudah_ada THEN
    'SELECT ''CHECK harga sudah ada, tidak diubah'' AS check_harga'
  WHEN @ada_harga_negatif THEN
    'SELECT ''ADA HARGA NEGATIF: tabel tidak diubah, panggil dosen'' AS check_harga'
  ELSE
    'ALTER TABLE products ADD CONSTRAINT ck_products_price CHECK (unit_price >= 0)'
END;
PREPARE langkah FROM @perintah;
EXECUTE langkah;
DEALLOCATE PREPARE langkah;

-- ---------------------------------------------------------------------
-- 6. Tabel products_v2 dan dua produk latihan (praktikum 5, langkah B-C)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products_v2 (
  product_id   INT UNSIGNED  NOT NULL,
  sku          VARCHAR(20)   NOT NULL,
  product_name VARCHAR(100)  NOT NULL,
  category_id  INT UNSIGNED  NOT NULL,
  unit_price   DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT uq_products_v2_sku UNIQUE (sku),
  CONSTRAINT ck_products_v2_price CHECK (unit_price >= 0),
  CONSTRAINT fk_products_v2_category FOREIGN KEY (category_id)
    REFERENCES categories (category_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO products_v2 (product_id, sku, product_name, category_id, unit_price)
SELECT 101, 'L01', 'Teh Latihan', 1, 5000.00 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products_v2 WHERE product_id = 101 OR sku = 'L01');

INSERT INTO products_v2 (product_id, sku, product_name, category_id, unit_price)
SELECT 102, 'L02', 'Pensil Latihan', 3, 3000.00 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products_v2 WHERE product_id = 102 OR sku = 'L02');

-- ---------------------------------------------------------------------
-- 7. Hasil pemulihan
--    Harapan: 3 kategori, 4 produk, 3 pelanggan, 2 produk products_v2.
--    Jika jumlahnya lebih atau datanya berbeda, panggil dosen.
-- ---------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM categories)  AS jumlah_kategori,
  (SELECT COUNT(*) FROM products)    AS jumlah_produk,
  (SELECT COUNT(*) FROM customers)   AS jumlah_pelanggan,
  (SELECT COUNT(*) FROM products_v2) AS jumlah_products_v2;
