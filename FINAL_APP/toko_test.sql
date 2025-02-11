-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2024 at 06:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `toko_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id`, `nama`, `email`, `password`) VALUES
(1, 'Dicky', 'dickygg@gmail.com', '$2y$10$r.24qbPWScHlyTHFvIJtNeaVmdFZuKIi1FLSwYKdpnR7rRDghRcDC'),
(2, 'test', 'test@gmail.com', '$2y$10$g63O0NaJa6rea6qQKxK2U.WbQDeD/AqsmTUVEYa3DyjF2iBY09jMG'),
(3, 'dicky', 'uas@gmail.com', '$2y$10$B0Mgo3QD2uz7SQQ3k1PWQOOm3v7i0zz/Za9UbPwRhBHhxtCwQMtCq'),
(4, 'uas', 'uas@gmail.com', '$2y$10$LmKxX3IrtrYyhPWB6u0Hx.QCtNyWiFOdU9VaVu7SUPgpYdR4bmV/i'),
(5, 'dicky', 'dicky01@gmail.com', '$2y$10$CNG9FxK0H08./RZHLa5OoOxaQiPl2TEWPemutElFKE2hXUOvUp5IK');

-- --------------------------------------------------------

--
-- Table structure for table `member_token`
--

CREATE TABLE `member_token` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `auth_key` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `member_token`
--

INSERT INTO `member_token` (`id`, `member_id`, `auth_key`) VALUES
(1, 1, 'YeCiabULMxY1MEoM5m4jMq2vDaaAY9N33iGCphJgsThS49t9mJu9FEUpiaEIrvpkEvM4DzMPhxLJoOkTH6waOkUX2WME0s44YZIo'),
(2, 1, 'hJnTebVuDpAY3jrTft2MpDQfVAT1EYQRaUE3eimVJvRViUd3aHrIOkdIdn8iVS02OthFQRvllGxitze7E3LfZs2rTzRWGupDWhqU'),
(3, 2, '8dJIHyjebnKukiXuKul7J1rVRLaLxuG2SUklcGhpdIrGGYkXBjkywmyraBoeRyEMUGFfC0h6WVuSgYvreLCP7d1zXKfC2D1MCRts'),
(4, 1, '4xP3ZCfomLd7txqME9sd19WRf0eS54VBTu5G1wv7ZmtnsMMilqpq3pZ6rFzIPjfm2D6Ff8GoYe06OEZ7ORnWw8cX4atckFJ9F92O'),
(5, 1, 'TerBu6F8QbWYJJLxC10TfLFBi0NqYk6EQk9umdBNDI0gYDqck41CNaLu2OceRbkglUtGHADVGMhc2W2dK7jXLPbsDgTNg9uABhVJ'),
(6, 1, 'mEOYFHbVD2dIEVi9a1NbhJM6U7zpqA7oOjnP4TjqCqXr3zW5031oDemMQxdxhuxZNuaPvDvb8ExvbaLGAvmsGPFE5EkIPi0rmyjG'),
(7, 1, 'qswl3HDXD1xm1YnQc01TbRnNkvN3Qgi1VPFM7vElU6j5f3ix9LN7NtuI4NrTvFtYfZU9Yprhx7VKp1jSgbgSSv1a3BjvBwrGzz1S'),
(8, 1, 'H2F7wi6VshXIW4xYV4j0XTifoGzrFHlqgKZ56rjJ8mSnUlfK97q2aKoW6f8sXp4X0flV7YxWSBgxhWOV8NJtJmPDt9pTFplBgnDP'),
(9, 1, 'mECVYrMFxZWZzu14cGFicXvb9kjGk2fOWXBabXadkp3VWUkfIhuJCIWuWgTvA9E9Ckb8AA4PffrHHKhG7YOyxZ82Eu3BCTYiQsms'),
(10, 1, '5sTelgXw3Q5KEj3ty14ygTADOZ3DOTpf5DMUIDUWrSaSS5nWPsH6dLms1g2GzpzOXdoh5YPFIFcj6FtBz0xqq2y6F8z7yxwCuE5k'),
(11, 1, 'gD8mHsOMAAcgpIPOm6qHD27z0ZUYfMj8mkVxyZwZ1QeAqHEIqCNMZGbZvMWF5Br9D0s7zsxZ1ib35oEQQO33pa6KV83PbLtcFIUz'),
(12, 1, 'u2kPHMjW8fLd9uzIhcxJNTowCtqNYCYfcjtFWzjsqSmLrEJi5XPoEnXbpnMSYeNcmBYqqDmMuL8172Q2RXkY61mmxGqzAnXJ5I2O'),
(13, 3, '6QyziDzvZ6YoJAjFvivFeGarZiRLSro8z4c20UCVfx7m7G11ykmPNopl28J5r5BUVi0I1qGUqyZBFPoMWZPe1YDYll5nIGwIt0Ow'),
(14, 1, 'chhkevMvovjEm8sGz7izaSJadjxBK4m4T7do3V5ScdwSbitUtqR8wXxt65TOaftEf2AI2rN8Hd05p37AmYOgMtRGUkyKQ3SRgkkb'),
(15, 1, 'mcsR5zwnqZ9wjZVOOzs6ajxTPUkAnOzjrN878jRr4JmSzUR2cUJHnZTPs53mjBkpTqoCftT7DgIjbcAqdUrxXXNjTjsjZbM8Ry58'),
(16, 1, 'PYalLY1dmLzyUO5ZRwD2PFuUkNjMwYYvmwjhpYcFNIOCOUFCzEkm0fQF8hDN65KwCetaBCpNMMdtlFSK89rvwir6tBsMQlQP1uQ4'),
(17, 1, '1VJn9KOHsdvCSMD53TZqlZSwliXHN2Jy7vuxnY5Pj0zSWaplXuEBFeljEYmBBAN2V2q8o49rNO3YaZb8Uqds04XNOHsfidDKtTXX'),
(18, 1, 'wFsnfMxAScEJwreSy2W3cCwzGmNWdi2cdhJ2UseOIoGdUaUXcKaoXcP1Z0JcjZJhdAiWcq1EBmzOaWyyQs52eoF5evjGL38hHXBP'),
(19, 1, 'qzEAeoV1blOByipdabIzggS8dDbhvjl1srHUmELKY7uEPKZ4q8lT4sxoKuldbX6gzWeUR8O1qOvLIGyJnFIroJE8RALM8tJ52zxg'),
(20, 1, 'UYcnE9YexJ6ksbNt8RD9HOOG6SYNwbUcCzFtWW0PjOPyJd4B54NG5xpGzMDQzxsIyMJUdQMgoIvF87qzMD0CTAyHTg7ybLRUXzEF'),
(21, 1, 'nqI5DlmZgIuVmZng1ftnXnObUTq4vBSdXu6hdZFf3LJmzKRxFVl2q5uyxnE5P3z7pwBwnhC8XeHx0PEuMQKHtFfJLoJZheQYdzC1'),
(22, 1, 'l6yFrtW8gnSC9pwHc5kztnuRpgHbZmKsxuMzngqlHRoKprBd4pk71xwAdFddGWOl2Toz56soMaS97hsvCss4ZNMu1k1qI6VM8dIl'),
(23, 1, 'J7J7rOrRPGrQYL7ZQc4kOlPbwc2qXomBi2CNYVCJcb4WNBOFDRSOmFrbAVtw5zZoG5mCP2M4CBjFVlPH7USMxmmrGebRJ06yRwcW'),
(24, 5, 'hDwMRiQJRESBUxLdFEO11LPeDqYMy1WyJ5lssD04E6e6OLIf8NCsqKRxDqNrshFcEJkESMQOqWsukTxyn37i1u0oEnOO7eGqfpEt'),
(25, 5, '1evswsIn3S1VPEMpwqEdikh1A0cAiuXXGNHSNatlQzQznFhavYGQolgTRn7JQzzJOnhy4wqQSnrTPYUT0STcqsy9HVCiU0AndiAA'),
(26, 1, 'ODbFwk8ymePqUSBEM8Mdtj0QRaM0rc5h6V6kg9EVLLcMwAQW58tbkkyjYegql82PmnV2ADpNwhzSEFj7XENWEc6aFEe5puAdLvno'),
(27, 1, '13laa0TPh90023Sc5tG4U1R8yU7ter8lBydEGu7J6ZKZId206ivFGsOwDmIUHAdGfSy6dtwnpH5DbCThCR63minjrQacKGoXoJol'),
(28, 1, 'PxRahFQfSRdB51Ke0MkkqZXecmBVz5VtF73xexX7q8hcuTs2rw2TY52LVN0We1Tg7ZIQWayatksKaAcsTSy2LmBkI5dIh20xlJv3');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(255) NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL,
  `gambar` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `stok` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `kode_produk`, `nama_produk`, `harga`, `gambar`, `deskripsi`, `stok`) VALUES
(7, 'MV02', 'bridge751', 1250000, '1720152401_d92475b107144672c4e8.jpg', 'Kondisi: Baru\n    Waktu Preorder: 60 Hari\n    Min. Pemesanan: 1 Buah\n    Etalase: Mechanical Keyboard\n\n[BATCH 2 - DATANG AKHIR JULI 2024, BEGITU DATANG LANSUNG JADI IN-STOCK]\n[LISTING INI HANYA UNTUK BRIDGE75 PLUS, UNTUK YANG BIASA ATAU YANG HE BISA LANSUNG KE WEBSITE KITA]\n\nISI BOX:\n1. Fully Assembled Keyboard With Plastic dust cover\n2. Type C Cable\n3. 2.4GHz Dongle (kecuali Bridge75 HE)\n4. Switch/Keycap puller\n5. 3 extra switches\n\nBridge 75 adalah mechanical keyboard berbahan aluminium yang langsung siap digunakan. Nikmati pengalaman mengetik premium dengan desain dan akustik superior, semuanya dengan harga awal yang luar biasa.\n\n\n\nMinimalisme dalam desain\nBridge 75 menggabungkan minimalisme dan fungsionalitas dalam satu paket lengkap dengan front height yang rendah dan typing angle yang pas, memberikan pengalaman mengetik yang nyaman dengan atau tanpa sandaran pergelangan tangan.\n\n\n\nTekstur Luar Biasa\nBridge 75 menghadirkan kualitas terbaik dalam kisaran harganya, dengan tekstur anodized dan spray-coated, memastikan hasil akhir yang sangat halus dan halus untuk sentuhan dan mata.\n\n\n\nPembongkaran Mudah\nKami merancang Bridge 75 dengan tujuan customizability, dengan mekanisme ball catch yang ditemukan pada keyboard mechanical high end yang menyediakan proses assembly tanpa alat yang mudah, dipasangkan dengan PCB hot swappable, Anda dapat mengganti switch dan, memodifikasi foam untuk menemukan rasa mengetik dan profil suara yang paling sesuai dengan Anda.\n\n\nAkustik Luar Biasa\nBridge 75 menawarkan paket akustik yang menyaingi, jika tidak melebihi, keyboard mekanis lain di tingkat yang sama. Performa suara superior ini dicapai melalui kombinasi material yang teliti: INOAC Poron foam, IPXE sheet, PET sheet, dan EPDM case foam. Terlepas dari switch yang dipakai, keyboard ini dirancang untuk memberikan akustik yang luar biasa.\n\n\n\nKonektivitas Nirkabel & Kompatibel VIA\nBridge 75 menyediakan tiga mode konektivitas, kabel, Bluetooth, dan 2.4G, untuk memastikan fleksibilitas maksimum dalam penggunaan Anda. Untuk masa pakai baterai yang lebih lama, pilih versi Plus, yang menawarkan opsi baterai hingga 8000mAh. Selain itu, kompatibilitas keyboard dengan perangkat lunak VIA memberi Anda kekuatan untuk menyesuaikan peta tombol agar sesuai dengan kebutuhan unik Anda.\n\n\n', 5);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `member_token`
--
ALTER TABLE `member_token`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `member_token`
--
ALTER TABLE `member_token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `member_token`
--
ALTER TABLE `member_token`
  ADD CONSTRAINT `member_token_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
