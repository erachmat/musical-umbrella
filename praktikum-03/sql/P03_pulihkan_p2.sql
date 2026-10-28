-- =====================================================================
-- DM099 Praktikum 3 - P03_pulihkan_p2.sql
-- Memulihkan kondisi akhir praktikum 2 (categories dan products)
--
-- KAPAN DIPAKAI
--   Hanya jika P03_cek_awal.sql menunjukkan tabel atau data praktikum 2
--   belum lengkap. Jika semua baris di cek awal sudah OK, JANGAN
--   jalankan berkas ini.
--
-- AMAN DIJALANKAN ULANG
--   Berkas ini tidak memakai DROP, TRUNCATE, DELETE, atau UPDATE.
--   - Tabel hanya dibuat jika belum ada (CREATE TABLE IF NOT EXISTS).
--   - Baris hanya ditambah jika ID dan SKU-nya belum ada.
--   - Baris yang sudah ada tidak diubah.
--   - Tabel customers dan indeks unik sku TIDAK dibuat di sini, karena
--     keduanya adalah pekerjaan praktikum 3 (langkah B dan C).
--   Jika tabel sudah ada tetapi strukturnya berbeda, berkas ini tidak
--   memperbaikinya. Panggil dosen.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Jalankan lagi P03_cek_awal.sql.
--
-- Struktur dan data sama dengan langkah B dan C modul praktikum 2.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Struktur tabel (kondisi akhir praktikum 2)
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
  PRIMARY KEY (product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ---------------------------------------------------------------------
-- 2. Data awal (hanya baris yang belum ada)
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

-- ---------------------------------------------------------------------
-- 3. Hasil pemulihan
--    Harapan: 2 kategori dan 3 produk.
--    Jika jumlahnya lebih atau datanya berbeda, panggil dosen.
-- ---------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM categories) AS jumlah_kategori,
  (SELECT COUNT(*) FROM products)   AS jumlah_produk;
