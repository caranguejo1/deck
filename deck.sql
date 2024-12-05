-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/12/2024 às 01:01
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `deck`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `deck_id` varchar(255) DEFAULT NULL,
  `code` varchar(10) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `svg_image` varchar(255) DEFAULT NULL,
  `value` varchar(50) NOT NULL,
  `suit` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `on_hand` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cards`
--

INSERT INTO `cards` (`id`, `deck_id`, `code`, `image`, `svg_image`, `value`, `suit`, `created_at`, `on_hand`) VALUES
(1, '491c4orhe8nc', 'JD', 'https://deckofcardsapi.com/static/img/JD.png', NULL, 'JACK', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(2, '491c4orhe8nc', '6D', 'https://deckofcardsapi.com/static/img/6D.png', NULL, '6', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(3, '491c4orhe8nc', 'QC', 'https://deckofcardsapi.com/static/img/QC.png', NULL, 'QUEEN', 'CLUBS', '2024-12-04 23:56:25', 0),
(4, '491c4orhe8nc', 'QH', 'https://deckofcardsapi.com/static/img/QH.png', NULL, 'QUEEN', 'HEARTS', '2024-12-04 23:56:25', 0),
(5, '491c4orhe8nc', 'JH', 'https://deckofcardsapi.com/static/img/JH.png', NULL, 'JACK', 'HEARTS', '2024-12-04 23:56:25', 0),
(6, '491c4orhe8nc', '9H', 'https://deckofcardsapi.com/static/img/9H.png', NULL, '9', 'HEARTS', '2024-12-04 23:56:25', 0),
(7, '491c4orhe8nc', 'AC', 'https://deckofcardsapi.com/static/img/AC.png', NULL, 'ACE', 'CLUBS', '2024-12-04 23:56:25', 0),
(8, '491c4orhe8nc', '8S', 'https://deckofcardsapi.com/static/img/8S.png', NULL, '8', 'SPADES', '2024-12-04 23:56:25', 0),
(9, '491c4orhe8nc', '0S', 'https://deckofcardsapi.com/static/img/0S.png', NULL, '10', 'SPADES', '2024-12-04 23:56:25', 0),
(10, '491c4orhe8nc', '4D', 'https://deckofcardsapi.com/static/img/4D.png', NULL, '4', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(11, '491c4orhe8nc', '3S', 'https://deckofcardsapi.com/static/img/3S.png', NULL, '3', 'SPADES', '2024-12-04 23:56:25', 0),
(12, '491c4orhe8nc', '5D', 'https://deckofcardsapi.com/static/img/5D.png', NULL, '5', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(13, '491c4orhe8nc', '7H', 'https://deckofcardsapi.com/static/img/7H.png', NULL, '7', 'HEARTS', '2024-12-04 23:56:25', 0),
(14, '491c4orhe8nc', '4H', 'https://deckofcardsapi.com/static/img/4H.png', NULL, '4', 'HEARTS', '2024-12-04 23:56:25', 0),
(15, '491c4orhe8nc', '7S', 'https://deckofcardsapi.com/static/img/7S.png', NULL, '7', 'SPADES', '2024-12-04 23:56:25', 0),
(16, '491c4orhe8nc', '6S', 'https://deckofcardsapi.com/static/img/6S.png', NULL, '6', 'SPADES', '2024-12-04 23:56:25', 0),
(17, '491c4orhe8nc', '0D', 'https://deckofcardsapi.com/static/img/0D.png', NULL, '10', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(18, '491c4orhe8nc', '8C', 'https://deckofcardsapi.com/static/img/8C.png', NULL, '8', 'CLUBS', '2024-12-04 23:56:25', 0),
(19, '491c4orhe8nc', '6H', 'https://deckofcardsapi.com/static/img/6H.png', NULL, '6', 'HEARTS', '2024-12-04 23:56:25', 0),
(20, '491c4orhe8nc', '0H', 'https://deckofcardsapi.com/static/img/0H.png', NULL, '10', 'HEARTS', '2024-12-04 23:56:25', 0),
(21, '491c4orhe8nc', '4S', 'https://deckofcardsapi.com/static/img/4S.png', NULL, '4', 'SPADES', '2024-12-04 23:56:25', 0),
(22, '491c4orhe8nc', '9C', 'https://deckofcardsapi.com/static/img/9C.png', NULL, '9', 'CLUBS', '2024-12-04 23:56:25', 0),
(23, '491c4orhe8nc', 'KS', 'https://deckofcardsapi.com/static/img/KS.png', NULL, 'KING', 'SPADES', '2024-12-04 23:56:25', 0),
(24, '491c4orhe8nc', '9S', 'https://deckofcardsapi.com/static/img/9S.png', NULL, '9', 'SPADES', '2024-12-04 23:56:25', 0),
(25, '491c4orhe8nc', 'KH', 'https://deckofcardsapi.com/static/img/KH.png', NULL, 'KING', 'HEARTS', '2024-12-04 23:56:25', 0),
(26, '491c4orhe8nc', '7D', 'https://deckofcardsapi.com/static/img/7D.png', NULL, '7', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(27, '491c4orhe8nc', '8D', 'https://deckofcardsapi.com/static/img/8D.png', NULL, '8', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(28, '491c4orhe8nc', 'QD', 'https://deckofcardsapi.com/static/img/QD.png', NULL, 'QUEEN', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(29, '491c4orhe8nc', '2C', 'https://deckofcardsapi.com/static/img/2C.png', NULL, '2', 'CLUBS', '2024-12-04 23:56:25', 0),
(30, '491c4orhe8nc', 'AH', 'https://deckofcardsapi.com/static/img/AH.png', NULL, 'ACE', 'HEARTS', '2024-12-04 23:56:25', 0),
(31, '491c4orhe8nc', 'AD', 'https://deckofcardsapi.com/static/img/aceDiamonds.png', NULL, 'ACE', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(32, '491c4orhe8nc', '0C', 'https://deckofcardsapi.com/static/img/0C.png', NULL, '10', 'CLUBS', '2024-12-04 23:56:25', 0),
(33, '491c4orhe8nc', '4C', 'https://deckofcardsapi.com/static/img/4C.png', NULL, '4', 'CLUBS', '2024-12-04 23:56:25', 0),
(34, '491c4orhe8nc', '5C', 'https://deckofcardsapi.com/static/img/5C.png', NULL, '5', 'CLUBS', '2024-12-04 23:56:25', 0),
(35, '491c4orhe8nc', '9D', 'https://deckofcardsapi.com/static/img/9D.png', NULL, '9', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(36, '491c4orhe8nc', '3H', 'https://deckofcardsapi.com/static/img/3H.png', NULL, '3', 'HEARTS', '2024-12-04 23:56:25', 0),
(37, '491c4orhe8nc', '5S', 'https://deckofcardsapi.com/static/img/5S.png', NULL, '5', 'SPADES', '2024-12-04 23:56:25', 0),
(38, '491c4orhe8nc', '2S', 'https://deckofcardsapi.com/static/img/2S.png', NULL, '2', 'SPADES', '2024-12-04 23:56:25', 0),
(39, '491c4orhe8nc', '8H', 'https://deckofcardsapi.com/static/img/8H.png', NULL, '8', 'HEARTS', '2024-12-04 23:56:25', 0),
(40, '491c4orhe8nc', '3D', 'https://deckofcardsapi.com/static/img/3D.png', NULL, '3', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(41, '491c4orhe8nc', '3C', 'https://deckofcardsapi.com/static/img/3C.png', NULL, '3', 'CLUBS', '2024-12-04 23:56:25', 0),
(42, '491c4orhe8nc', '2D', 'https://deckofcardsapi.com/static/img/2D.png', NULL, '2', 'DIAMONDS', '2024-12-04 23:56:25', 0),
(43, '491c4orhe8nc', '2H', 'https://deckofcardsapi.com/static/img/2H.png', NULL, '2', 'HEARTS', '2024-12-04 23:56:25', 1),
(44, '491c4orhe8nc', '7C', 'https://deckofcardsapi.com/static/img/7C.png', NULL, '7', 'CLUBS', '2024-12-04 23:56:25', 1),
(45, '491c4orhe8nc', 'KD', 'https://deckofcardsapi.com/static/img/KD.png', NULL, 'KING', 'DIAMONDS', '2024-12-04 23:56:25', 1),
(46, '491c4orhe8nc', 'KC', 'https://deckofcardsapi.com/static/img/KC.png', NULL, 'KING', 'CLUBS', '2024-12-04 23:56:25', 1),
(47, '491c4orhe8nc', '6C', 'https://deckofcardsapi.com/static/img/6C.png', NULL, '6', 'CLUBS', '2024-12-04 23:56:25', 1),
(48, '491c4orhe8nc', 'JC', 'https://deckofcardsapi.com/static/img/JC.png', NULL, 'JACK', 'CLUBS', '2024-12-04 23:56:25', 1),
(49, '491c4orhe8nc', '5H', 'https://deckofcardsapi.com/static/img/5H.png', NULL, '5', 'HEARTS', '2024-12-04 23:56:25', 1),
(50, '491c4orhe8nc', 'AS', 'https://deckofcardsapi.com/static/img/AS.png', NULL, 'ACE', 'SPADES', '2024-12-04 23:56:25', 1),
(51, '491c4orhe8nc', 'QS', 'https://deckofcardsapi.com/static/img/QS.png', NULL, 'QUEEN', 'SPADES', '2024-12-04 23:56:25', 1),
(52, '491c4orhe8nc', 'JS', 'https://deckofcardsapi.com/static/img/JS.png', NULL, 'JACK', 'SPADES', '2024-12-04 23:56:25', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `decks`
--

CREATE TABLE `decks` (
  `deck_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `remaining` int(11) NOT NULL,
  `shuffled` tinyint(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `decks`
--

INSERT INTO `decks` (`deck_id`, `name`, `success`, `remaining`, `shuffled`, `created_at`) VALUES
('491c4orhe8nc', 'xyz', 1, 42, 1, '2024-12-04 23:56:25'),
('ugahlpfzi6a6', 'a', 1, 32, 1, '2024-12-04 22:40:40');

-- --------------------------------------------------------

--
-- Estrutura para tabela `log`
--

CREATE TABLE `log` (
  `idlog` int(11) NOT NULL,
  `data_hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `numeroregistros` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `log`
--

INSERT INTO `log` (`idlog`, `data_hora`, `numeroregistros`) VALUES
(1, '2024-12-04 23:53:29', 52),
(2, '2024-12-04 23:53:31', 52),
(3, '2024-12-04 23:54:49', 52),
(4, '2024-12-04 23:55:55', 52),
(5, '2024-12-04 23:56:12', 52),
(6, '2024-12-04 23:58:16', 52);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `translated_deck_view`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `translated_deck_view` (
`deck_id` varchar(255)
,`name` varchar(255)
,`success` varchar(3)
,`remaining` int(11)
,`shuffled` varchar(3)
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Estrutura para view `translated_deck_view`
--
DROP TABLE IF EXISTS `translated_deck_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `translated_deck_view`  AS SELECT `decks`.`deck_id` AS `deck_id`, `decks`.`name` AS `name`, CASE WHEN `decks`.`success` = 1 THEN 'Sim' WHEN `decks`.`success` = 0 THEN 'Não' END AS `success`, `decks`.`remaining` AS `remaining`, CASE WHEN `decks`.`shuffled` = 1 THEN 'Sim' WHEN `decks`.`shuffled` = 0 THEN 'Não' ELSE NULL END AS `shuffled`, `decks`.`created_at` AS `created_at` FROM `decks` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `deck_id` (`deck_id`,`code`);

--
-- Índices de tabela `decks`
--
ALTER TABLE `decks`
  ADD PRIMARY KEY (`deck_id`);

--
-- Índices de tabela `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`idlog`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT de tabela `log`
--
ALTER TABLE `log`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `cards`
--
ALTER TABLE `cards`
  ADD CONSTRAINT `fk_deck` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`deck_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
