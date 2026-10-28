-- =====================================================================
-- DM099 Praktikum 2 - P02_cek_awal.sql
-- Langkah A: memeriksa database latihan sebelum membuat tabel
--
-- KAPAN DIPAKAI
--   Saat masuk lab, sambil menunggu absensi (07.00-07.15).
--   Berkas ini hanya membaca data (SELECT, SHOW). Aman dijalankan ulang.
--
-- CARA PAKAI
--   1. Ganti nama database pada baris USE di bawah.
--   2. Tempel seluruh isi berkas ke tab SQL phpMyAdmin, lalu klik Go.
--   3. Lihat tabel hasil "STATUS" dan ikuti kolom "tindakan".
--   4. Simpan tangkapan layar hasil ini untuk lembar kerja
--      (DATABASE(), VERSION(), dan nama database).
--
-- JIKA MUNCUL ERROR
--   "Unknown database" atau "Access denied": periksa nama database pada
--   baris USE. Jika nama sudah benar, panggil dosen.
-- =====================================================================

USE pbd_latihan_p01;  -- GANTI dengan nama database latihanmu

-- ---------------------------------------------------------------------
-- 1. Lingkungan praktik (lembar kerja)
-- ---------------------------------------------------------------------
SELECT DATABASE()  AS database_aktif,
       VERSION()   AS versi_server;

SHOW TABLES;

-- ---------------------------------------------------------------------
-- 2. STATUS: apakah tabel praktikum 2 sudah pernah dibuat?
-- ---------------------------------------------------------------------
SELECT 'Database latihan terpilih' AS cek,
  IF(DATABASE() IS NOT NULL, 'OK', 'BELUM') AS status,
  'Jika BELUM: periksa nama database pada baris USE' AS tindakan
UNION ALL
SELECT 'Tabel categories',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'categories'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: jalankan P02_cek_mandiri.sql sebelum langkah B'
UNION ALL
SELECT 'Tabel products',
  IF(EXISTS(SELECT 1 FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'products'),
     'INFO', 'OK'),
  'OK = belum ada (normal). INFO = sudah ada: jalankan P02_cek_mandiri.sql sebelum langkah B';
