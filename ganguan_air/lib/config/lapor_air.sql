-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Jun 2026 pada 13.12
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lapor_air`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporann`
--

CREATE TABLE `laporann` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Diproses','Selesai') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `progress` enum('Laporan Terkirim','Terverifikasi','Dikerjakan','Selesai') DEFAULT 'Laporan Terkirim',
  `progres` enum('Laporan Dikirim','Diverifikasi','Dalam Proses Perbaikan','Selesai') DEFAULT 'Laporan Dikirim',
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `laporann`
--

INSERT INTO `laporann` (`id`, `nama`, `alamat`, `keterangan`, `foto`, `status`, `created_at`, `progress`, `progres`, `email`) VALUES
(2, 'coba', 'jaya', 'bocor dia', 'http://localhost/lapor_air/uploads/1781084738_scaled_bocor.jpeg', 'Diproses', '2026-06-10 09:45:38', 'Laporan Terkirim', 'Dalam Proses Perbaikan', NULL),
(3, 'adit', 'keruak', 'pipa mengalami retak', 'http://localhost/lapor_air/uploads/1781085981_scaled_pipa_bocor.jpg', 'Diproses', '2026-06-10 10:06:21', 'Laporan Terkirim', 'Dalam Proses Perbaikan', NULL),
(4, 'ngurah', 'cakranegara', 'airnya keruh', 'http://localhost/lapor_air/uploads/1781089943_scaled_air_keruh.jpg', 'Selesai', '2026-06-10 11:12:23', 'Laporan Terkirim', 'Selesai', NULL),
(5, 'pak budi', 'Desa Sindu', 'air tekanannnya rendah, keluarnya kecil dan sedikit', 'http://localhost/lapor_air/uploads/1781096140_scaled_tekanan_rendah.jpg', 'Pending', '2026-06-10 12:55:40', 'Laporan Terkirim', 'Laporan Dikirim', NULL),
(6, 'ibu dani', 'jl.ismail marzuki no 11', 'air sering mati tiba tiba', 'http://localhost/lapor_air/uploads/1781096512_scaled_air_mati.jpg', 'Diproses', '2026-06-10 13:01:52', 'Laporan Terkirim', 'Diverifikasi', NULL),
(7, 'ngurah', 'monjok', 'mengalami kebocoran', 'http://localhost/lapor_air/uploads/1781147932_scaled_bocor.jpeg', 'Selesai', '2026-06-11 03:18:52', 'Laporan Terkirim', 'Selesai', NULL),
(8, 'ngurah', 'jl.rama selagalas', 'pipanya bolong', 'http://localhost/lapor_air/uploads/1781252748_scaled_pipa_bocor.jpg', 'Diproses', '2026-06-12 08:25:48', 'Laporan Terkirim', 'Dalam Proses Perbaikan', 'ngurah11@gmail.com'),
(9, 'ngurah', 'jl.rama selagalas', 'air nya mati tidak ada keluar air', 'http://localhost/lapor_air/uploads/1781253388_scaled_air_mati.jpg', 'Diproses', '2026-06-12 08:36:28', 'Laporan Terkirim', 'Diverifikasi', 'ngurah11@gmail.com'),
(10, 'Aditya Febrian', 'rembiga', 'pipa mengalami retak kemudian bocor', 'http://localhost/lapor_air/uploads/1781255968_scaled_pipa_bocor.jpg', 'Diproses', '2026-06-12 09:19:28', 'Laporan Terkirim', 'Dalam Proses Perbaikan', 'adit07@gmail.com'),
(11, 'ngurah', 'jl.banjaran sari', 'air tiba tiba mati', 'http://localhost/lapor_air/uploads/1781318744_scaled_air_mati.jpg', 'Pending', '2026-06-13 02:45:44', 'Laporan Terkirim', 'Laporan Dikirim', 'ngurah11@gmail.com');

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_kendala`
--

CREATE TABLE `laporan_kendala` (
  `id` int(11) NOT NULL,
  `kategori` varchar(100) DEFAULT NULL,
  `lokasi` text DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `foto` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` int(11) NOT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `judul` varchar(100) DEFAULT NULL,
  `pesan` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `notifikasi`
--

INSERT INTO `notifikasi` (`id`, `user_email`, `judul`, `pesan`, `is_read`, `created_at`) VALUES
(1, '', 'Status Laporan Diperbarui', 'Laporan #7 anda telah diperbarui menjadi: Selesai. Progress: Selesai', 0, '2026-06-11 09:06:13'),
(2, '', 'Status Laporan Diperbarui', 'Laporan #4 anda telah diperbarui menjadi: Selesai. Progress: Selesai', 0, '2026-06-11 09:06:23'),
(3, '', 'Status Laporan Diperbarui', 'Laporan #6 anda telah diperbarui menjadi: Diproses. Progress: Diverifikasi', 0, '2026-06-11 09:06:35'),
(4, 'ngurah11@gmail.com', 'Status Laporan Diperbarui', 'Laporan #9 anda telah diperbarui menjadi: Diproses. Progress: Diverifikasi', 1, '2026-06-12 08:40:13'),
(5, 'ngurah11@gmail.com', 'Status Laporan Diperbarui', 'Laporan #8 anda telah diperbarui menjadi: Diproses. Progress: Diverifikasi', 1, '2026-06-12 08:40:21'),
(6, '', 'Status Laporan Diperbarui', 'Laporan #3 anda telah diperbarui menjadi: Diproses. Progress: Dalam Proses Perbaikan', 0, '2026-06-12 09:03:47'),
(7, 'adit07@gmail.com', 'Status Laporan Diperbarui', 'Laporan #10 anda telah diperbarui menjadi: Diproses. Progress: Dalam Proses Perbaikan', 1, '2026-06-12 09:21:11'),
(8, '', 'Status Laporan Diperbarui', 'Laporan #2 anda telah diperbarui menjadi: Diproses. Progress: Dalam Proses Perbaikan', 0, '2026-06-13 02:42:29'),
(9, 'ngurah11@gmail.com', 'Status Laporan Diperbarui', 'Laporan #8 anda telah diperbarui menjadi: Diproses. Progress: Dalam Proses Perbaikan', 0, '2026-06-13 05:06:39');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `no_telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`, `no_telepon`) VALUES
(1, 'Admin', 'admin@gmail.com', '123456', 'admin', NULL),
(2, 'saya baru', 'coba123@gmail.com', 'coba123', 'user', '082331124562'),
(3, 'hahaha', 'huhu235@gmail.com', '12133', 'user', NULL),
(4, 'coba lagi', 'coba65@gmail.com', '654321', 'user', NULL),
(5, 'ngurah', 'ngurah11@gmail.com', 'ngurah123', 'user', '082340086161'),
(6, 'Aditya Febrian', 'adit07@gmail.com', 'adit0704', 'user', '083214578901');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `laporann`
--
ALTER TABLE `laporann`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `laporan_kendala`
--
ALTER TABLE `laporan_kendala`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `laporann`
--
ALTER TABLE `laporann`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `laporan_kendala`
--
ALTER TABLE `laporan_kendala`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
