-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Bulan Mei 2026 pada 09.11
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
  `kategori` varchar(100) DEFAULT NULL,
  `lokasi` text DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Diproses','Selesai') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `progres_laporan` enum('Laporan Terkirim','Terverifikasi','Dikerjalan','Selesai') DEFAULT 'Laporan Terkirim'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `laporann`
--

INSERT INTO `laporann` (`id`, `kategori`, `lokasi`, `deskripsi`, `foto`, `status`, `created_at`, `progres_laporan`) VALUES
(1, 'Pipa Bocor', 'Mataram', 'Pipa bocor depan rumah', 'tes.jpg', 'Pending', '2026-05-30 01:39:36', 'Laporan Terkirim'),
(2, 'Pipa Bocor', 'jl..hasanudin', 'pipa mengalami kebocoran', '1780116400_scaled_Screenshot 2026-01-15 194854.png', 'Selesai', '2026-05-30 04:46:40', 'Selesai');

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
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`) VALUES
(1, 'Admin', 'admin@gmail.com', '123456'),
(2, 'saya baru', 'coba123@gmail.com', '12345678'),
(3, 'hahaha', 'huhu235@gmail.com', '12133'),
(4, 'coba lagi', 'coba65@gmail.com', '654321'),
(5, 'ngurah', 'ngurah11@gmail.com', 'ngurah123');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `laporan_kendala`
--
ALTER TABLE `laporan_kendala`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
