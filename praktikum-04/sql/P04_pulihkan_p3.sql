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
--   - Tabel atau baris yang sudah ada tidak diubah.
--   Jika tabel sudah ada tetapi strukturnya berbeda, berkas ini tidak
--   memperbaikinya. Panggil dosen.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Jalankan lagi P04_cek_awal.sql.
--
-- CATATAN DOSEN: struktur dan nilai contoh di bawah disusun dari
-- modul praktikum 4. Sesuaikan nama produk, harga, panjang VARCHAR, dan
-- data pelanggan dengan modul praktikum 3 sebelum dibagikan.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Struktur tabel (kondisi akhir praktikum 3, belum ada FK dan CHECK)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id   INT UNSIGNED  NOT NULL,
  category_name VARCHAR(50)   NOT NULL,
  PRIMARY KEY (category_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS products (
  product_id   INT UNSIGNED  NOT NULL,
  sku          VARCHAR(10)   NOT NULL,
  product_name VARCHAR(100)  NOT NULL,
  category_id  INT UNSIGNED  NOT NULL,
  unit_price   DECIMAL(12,2) NOT NULL,
  stock_qty    INT UNSIGNED  NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT uq_products_sku UNIQUE (sku)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT UNSIGNED  NOT NULL,
  full_name   VARCHAR(100)  NOT NULL,
  email       VARCHAR(100)  NOT NULL,
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  CONSTRAINT uq_customers_email UNIQUE (email)
) ENGINE = InnoDB;

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
SELECT 1, 'P01', 'Air Mineral 600 ml', 1, 3500.00, 20 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 1 OR sku = 'P01');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 2, 'P02', 'Teh Manis Botol', 1, 5000.00, 15 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 2 OR sku = 'P02');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
SELECT 3, 'P03', 'Roti Tawar', 2, 15000.00, 30 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM products WHERE product_id = 3 OR sku = 'P03');

INSERT INTO customers (customer_id, full_name, email)
SELECT 1, 'Pelanggan Satu', 'pelanggan1@example.com' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 1 OR email = 'pelanggan1@example.com');

INSERT INTO customers (customer_id, full_name, email)
SELECT 2, 'Pelanggan Dua', 'pelanggan2@example.com' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 2 OR email = 'pelanggan2@example.com');

INSERT INTO customers (customer_id, full_name, email)
SELECT 3, 'Pelanggan Tiga', 'pelanggan3@example.com' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = 3 OR email = 'pelanggan3@example.com');

-- ---------------------------------------------------------------------
-- 3. Hasil pemulihan
--    Harapan: 2 kategori, 3 produk, 3 pelanggan (atau 3, 4, 3 jika
--    langkah D praktikum 4 sudah dikerjakan).
--    Jika jumlahnya lebih atau datanya berbeda, panggil dosen.
-- ---------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM categories) AS jumlah_kategori,
  (SELECT COUNT(*) FROM products)   AS jumlah_produk,
  (SELECT COUNT(*) FROM customers)  AS jumlah_pelanggan;
