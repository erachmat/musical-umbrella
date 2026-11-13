-- =====================================================================
-- UTS DM099 Perancangan Basis Data - CONTOH JAWABAN soal 5
-- Kasus contoh: Toko Saku (penjualan minuman, roti, dan alat tulis)
--
-- Isi berkas:
--   Bagian 1  Membuat database
--   Bagian 2  Membuat enam tabel (urutan: induk dulu, baru anak)
--   Bagian 3  Mengisi data contoh dari data mentah (soal 2)
--   Bagian 4  Pemeriksaan hasil (bahan tangkapan layar)
--
-- Berkas ini memakai database baru agar tidak mengganggu database
-- latihan praktikum. Tidak ada DROP, TRUNCATE, DELETE, atau UPDATE.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Bagian 1. Database
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS uts_pbd_tokosaku
  DEFAULT CHARACTER SET utf8mb4;
USE uts_pbd_tokosaku;

-- ---------------------------------------------------------------------
-- Bagian 2. Tabel
-- ---------------------------------------------------------------------

-- Entitas induk: kategori produk
CREATE TABLE IF NOT EXISTS categories (
  category_id   INT UNSIGNED NOT NULL,
  category_name VARCHAR(60)  NOT NULL,
  PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Entitas induk: pelanggan.
-- Atribut komposit Alamat dipecah menjadi street, city, postal_code.
-- Email boleh NULL karena belum tentu dimiliki pelanggan.
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT UNSIGNED NOT NULL,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(160) NULL,
  street      VARCHAR(150) NULL,
  city        VARCHAR(60)  NULL,
  postal_code CHAR(5)      NULL,
  PRIMARY KEY (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Atribut bernilai banyak No_HP dipisah menjadi tabel sendiri.
-- Kunci gabungan: satu pelanggan tidak boleh memiliki nomor yang sama dua kali.
CREATE TABLE IF NOT EXISTS customer_phones (
  customer_id INT UNSIGNED NOT NULL,
  phone_no    VARCHAR(20)  NOT NULL,
  PRIMARY KEY (customer_id, phone_no),
  CONSTRAINT fk_phones_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Produk: setiap produk wajib memiliki satu kategori yang sudah tercatat
CREATE TABLE IF NOT EXISTS products (
  product_id   INT UNSIGNED  NOT NULL,
  sku          VARCHAR(20)   NOT NULL,
  product_name VARCHAR(100)  NOT NULL,
  category_id  INT UNSIGNED  NOT NULL,
  unit_price   DECIMAL(12,2) NOT NULL,
  stock_qty    INT UNSIGNED  NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT uq_products_sku UNIQUE (sku),
  CONSTRAINT ck_products_price CHECK (unit_price >= 0),
  CONSTRAINT fk_products_category FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Penjualan (nota): hanya tanggal yang dibutuhkan, sehingga memakai DATE.
CREATE TABLE IF NOT EXISTS sales (
  sale_id     INT UNSIGNED NOT NULL,
  invoice_no  VARCHAR(24)  NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  sale_date   DATE         NOT NULL,
  PRIMARY KEY (sale_id),
  CONSTRAINT uq_sales_invoice UNIQUE (invoice_no),
  CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Entitas asosiasi: detail penjualan.
-- Subtotal dan Total_Bayar (atribut turunan) TIDAK disimpan; keduanya
-- dihitung dengan query pada Bagian 4.
CREATE TABLE IF NOT EXISTS sale_items (
  sale_id    INT UNSIGNED  NOT NULL,
  product_id INT UNSIGNED  NOT NULL,
  quantity   INT           NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (sale_id, product_id),
  CONSTRAINT ck_items_qty   CHECK (quantity > 0),
  CONSTRAINT ck_items_price CHECK (unit_price >= 0),
  CONSTRAINT fk_items_sale    FOREIGN KEY (sale_id)
    REFERENCES sales(sale_id),
  CONSTRAINT fk_items_product FOREIGN KEY (product_id)
    REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- Bagian 3. Data contoh (dari data mentah soal 2). Induk dulu, baru anak.
-- ---------------------------------------------------------------------
INSERT INTO categories (category_id, category_name)
VALUES (1, 'Minuman'), (2, 'Roti');

INSERT INTO customers (customer_id, full_name, email, street, city, postal_code)
VALUES
  (1, 'Rani Sintetis', 'rani@example.com', 'Jl. Kaliurang Km 5',  'Sleman', '55281'),
  (2, 'Bima Sintetis', NULL,               'Jl. Gejayan No. 10',  'Sleman', '55283'),
  (3, 'Nisa Sintetis', 'nisa@example.com', 'Jl. Affandi No. 3',   'Sleman', '55281');

INSERT INTO customer_phones (customer_id, phone_no)
VALUES
  (1, '081200000001'), (1, '081200000002'),
  (2, '081200000003'),
  (3, '081200000004');

INSERT INTO products (product_id, sku, product_name, category_id, unit_price, stock_qty)
VALUES
  (1, 'P01', 'Teh Botol',    1, 5000.00, 20),
  (2, 'P02', 'Roti Cokelat', 2, 8000.00, 15),
  (3, 'P03', 'Air Mineral',  1, 4000.00, 30);

INSERT INTO sales (sale_id, invoice_no, customer_id, sale_date)
VALUES
  (1, 'INV-UTS-001', 1, '2026-10-05'),
  (2, 'INV-UTS-002', 2, '2026-10-06'),
  (3, 'INV-UTS-003', 3, '2026-10-06');

INSERT INTO sale_items (sale_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 2, 5000.00),
  (1, 2, 1, 8000.00),
  (2, 1, 1, 5000.00),
  (3, 3, 3, 4000.00);

-- ---------------------------------------------------------------------
-- Bagian 4. Pemeriksaan hasil (jalankan dan ambil tangkapan layar)
-- ---------------------------------------------------------------------
SHOW TABLES;

DESCRIBE customers;
DESCRIBE customer_phones;
DESCRIBE products;
DESCRIBE sales;
DESCRIBE sale_items;

-- Atribut turunan dihitung, bukan disimpan: subtotal per baris nota
SELECT s.invoice_no, s.sale_date, c.full_name,
       p.sku, p.product_name, i.quantity, i.unit_price,
       i.quantity * i.unit_price AS subtotal
FROM sales AS s
JOIN customers  AS c ON c.customer_id = s.customer_id
JOIN sale_items AS i ON i.sale_id     = s.sale_id
JOIN products   AS p ON p.product_id  = i.product_id
ORDER BY s.sale_id, p.product_id;

-- Total bayar per nota
SELECT s.invoice_no, SUM(i.quantity * i.unit_price) AS total_bayar
FROM sales AS s
JOIN sale_items AS i ON i.sale_id = s.sale_id
GROUP BY s.sale_id, s.invoice_no
ORDER BY s.sale_id;

-- Atribut komposit dan bernilai banyak ditampilkan kembali seperti data mentah
SELECT c.customer_id, c.full_name,
       CONCAT_WS(', ', c.street, c.city, c.postal_code) AS alamat,
       GROUP_CONCAT(ph.phone_no ORDER BY ph.phone_no SEPARATOR '; ') AS no_hp
FROM customers AS c
LEFT JOIN customer_phones AS ph ON ph.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.street, c.city, c.postal_code
ORDER BY c.customer_id;
