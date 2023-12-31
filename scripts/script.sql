-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th9 05, 2023 lúc 03:02 PM
-- Phiên bản máy phục vụ: 10.4.14-MariaDB
-- Phiên bản PHP: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `getgo`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `Conversations`
--

CREATE TABLE `Conversations` (
  `id` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `trip_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `messages`
--

CREATE TABLE `Messages` (
  `id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `conversation_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `rates`
--

CREATE TABLE `Rates` (
  `id` int(11) NOT NULL,
  `star` float DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `trip_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `rates`
--

INSERT INTO `Rates` (`id`, `star`, `comment`, `createdAt`, `updatedAt`, `trip_id`) VALUES
(1, 4, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', NULL),
(2, 5, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 2),
(3, 2, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 3),
(4, 5, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 4),
(5, 1, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 5),
(6, 4, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 6);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `settings`
--

CREATE TABLE `Settings` (
  `id` int(11) NOT NULL,
  `auto_accept_trip` tinyint(1) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `Trips`
--

CREATE TABLE `Trips` (
  `id` int(11) NOT NULL,
  `status` enum('Callcenter','Pending','Waiting','Confirmed','Driving','Arrived','Done','Cancelled') DEFAULT NULL,
  `start` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`start`)),
  `end` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`end`)),
  `finished_date` datetime DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `is_paid` tinyint(1) DEFAULT NULL,
  `paymentMethod` enum('Cash','Momo','IE') DEFAULT NULL,
  `is_scheduled` tinyint(1) DEFAULT NULL,
  `schedule_time` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `is_callcenter` tinyint(1) DEFAULT NULL,
  `distance` decimal(10,0) DEFAULT NULL,
  `duration` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `Trips`
--

INSERT INTO `Trips` (`id`, `status`, `start`, `end`, `finished_date`, `type`, `note`, `price`, `is_paid`, `paymentMethod`, `is_scheduled`, `schedule_time`, `createdAt`, `updatedAt`, `user_id`, `driver_id`, `is_callcenter`,`distance`,`duration`) VALUES
(2, 'Done', '{\"lat\":10.1,\"lng\":10.2,\"place\":\"random places\"}', '{\"lat\":10.3,\"lng\":10.4,\"place\":\"2nd random places\"}', NULL, NULL, NULL, '50000', 0, 'Cash', 0, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 4, 2, NULL,NULL,NULL),
(3, 'Cancelled', '{\"lat\":10.1,\"lng\":10.2,\"place\":\"random places\"}', '{\"lat\":10.3,\"lng\":10.4,\"place\":\"2nd random places\"}', NULL, NULL, NULL, '50000', 0, 'Cash', 0, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 5, 2, NULL,NULL,NULL),
(4, 'Done', '{\"lat\":10.1,\"lng\":10.2,\"place\":\"random places\"}', '{\"lat\":10.3,\"lng\":10.4,\"place\":\"2nd random places\"}', NULL, NULL, NULL, '50000', 0, 'Cash', 0, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 4, 3, NULL,NULL,NULL),
(5, 'Done', '{\"lat\":10.1,\"lng\":10.2,\"place\":\"random places\"}', '{\"lat\":10.3,\"lng\":10.4,\"place\":\"2nd random places\"}', NULL, NULL, NULL, '50000', 0, 'Cash', 0, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 4, 3, 1,NULL,NULL),
(6, 'Done', '{\"lat\":10.1,\"lng\":10.2,\"place\":\"random places\"}', '{\"lat\":10.3,\"lng\":10.4,\"place\":\"2nd random places\"}', NULL, NULL, NULL, '50000', 0, 'Cash', 0, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 5, 3, NULL,NULL,NULL),
(7, 'Done', '{\"place\":\"2 Nguyễn Bỉnh Khiêm, Quận 1, Thành phố Hồ Chí Minh, Việt Nam\",\"lat\":10.7877783,\"lng\":106.705055}', '{\"name\":\"Quận 1, Ho Chi Minh City, Vietnam\",\"lat\":10.7756587,\"lng\":106.7004238}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 10, 9, NULL,NULL,NULL),
(8, 'Done', '{\"place\":\"History Museum of Ho Chi Minh City, 2 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Vietnam\",\"lat\":10.787984,\"lng\":106.7047376}', '{\"place\":\"Quận 7, Ho Chi Minh City, Vietnam\",\"lat\":10.7340344,\"lng\":106.7215787}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 10, 9, NULL,NULL,NULL),
(9, 'Done', '{\"place\":\"58B, Quận 3, Thành phố Hồ Chí Minh, Việt Nam\",\"lat\":10.7843683,\"lng\":106.6844083}', '{\"place\":\"Quán 1...2...3...DZÔ | Quán nhậu ngon quận 8, Đường Cao Lỗ, Phường 4, District 8, Ho Chi Minh City, Vietnam\",\"lat\":10.743322,\"lng\":106.6764163}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 10, 9, NULL,NULL,NULL),
(10, 'Done', '{\"place\":\"History Museum of Ho Chi Minh City, 2 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Vietnam\",\"lat\":10.787984,\"lng\":106.7047376}', '{\"place\":\"Quận 7, Ho Chi Minh City, Vietnam\",\"lat\":10.7340344,\"lng\":106.7215787}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 12, 9, NULL,NULL,NULL),
(11, 'Done', '{\"place\":\"58B, Quận 3, Thành phố Hồ Chí Minh, Việt Nam\",\"lat\":10.7843683,\"lng\":106.6844083}', '{\"place\":\"Quán 1...2...3...DZÔ | Quán nhậu ngon quận 8, Đường Cao Lỗ, Phường 4, District 8, Ho Chi Minh City, Vietnam\",\"lat\":10.743322,\"lng\":106.6764163}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 12, 9, NULL,NULL,NULL),
(13, 'Pending', '{\"place\":\"History Museum of Ho Chi Minh City, 2 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Vietnam\",\"lat\":10.787984,\"lng\":106.7047376}', '{\"place\":\"Quận 7, Ho Chi Minh City, Vietnam\",\"lat\":10.7340344,\"lng\":106.7215787}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 10, 9, NULL,NULL,NULL),
(14, 'Waiting', '{\"place\":\"58B, Quận 3, Thành phố Hồ Chí Minh, Việt Nam\",\"lat\":10.7843683,\"lng\":106.6844083}', '{\"place\":\"Quán 1...2...3...DZÔ | Quán nhậu ngon quận 8, Đường Cao Lỗ, Phường 4, District 8, Ho Chi Minh City, Vietnam\",\"lat\":10.743322,\"lng\":106.6764163}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 10, 9, NULL,NULL,NULL),
(15, 'Confirmed', '{\"place\":\"History Museum of Ho Chi Minh City, 2 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Vietnam\",\"lat\":10.787984,\"lng\":106.7047376}', '{\"place\":\"Quận 7, Ho Chi Minh City, Vietnam\",\"lat\":10.7340344,\"lng\":106.7215787}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 12, 9, NULL,NULL,NULL),
(16, 'Driving', '{\"place\":\"58B, Quận 3, Thành phố Hồ Chí Minh, Việt Nam\",\"lat\":10.7843683,\"lng\":106.6844083}', '{\"place\":\"Quán 1...2...3...DZÔ | Quán nhậu ngon quận 8, Đường Cao Lỗ, Phường 4, District 8, Ho Chi Minh City, Vietnam\",\"lat\":10.743322,\"lng\":106.6764163}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-11 09:45:30', '2023-08-11 09:45:30', 12, 9, 1,NULL,NULL),
(18, 'Pending', '\"{\\\"place\\\":\\\"random places\\\",\\\"lat\\\":10.1,\\\"lng\\\":10.2}\"', '\"{\\\"place\\\":\\\"2nd random places\\\",\\\"lat\\\":10.3,\\\"lng\\\":10.4}\"', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-16 11:02:34', '2023-08-16 11:02:34', 4, NULL, 0,NULL,NULL),
(19, 'Pending', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 05:58:55', '2023-08-22 05:58:55', 4, NULL, 0,NULL,NULL),
(20, 'Pending', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 07:54:59', '2023-08-22 07:54:59', 4, NULL, 0,NULL,NULL),
(21, 'Pending', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 07:56:33', '2023-08-22 07:56:33', 4, NULL, 0,NULL,NULL),
(22, 'Pending', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 07:59:55', '2023-08-22 07:59:55', 4, NULL, 0,NULL,NULL),
(23, 'Confirmed', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 08:06:30', '2023-08-22 08:06:39', 4, 3, 0,NULL,NULL),
(26, 'Confirmed', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 08:11:17', '2023-08-22 08:11:22', 4, 3, 0,NULL,NULL),
(37, 'Confirmed', '{\"place\":\"random places\",\"lat\":10.1,\"lng\":10.2}', '{\"place\":\"2nd random places\",\"lat\":10.3,\"lng\":10.4}', NULL, NULL, NULL, '50000', 0, NULL, 0, NULL, '2023-08-22 09:00:12', '2023-08-22 09:00:46', 4, 3, 0,NULL,NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `Users`
--

CREATE TABLE `Users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `avatar` varchar(255) NOT NULL DEFAULT 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg',
  `type` enum('Admin','User','User_Vip','Driver','CallCenterS1','CallCenterS2','CallCenterS3') DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `accessToken` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `token_fcm` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `Users`
--

INSERT INTO `Users` (`id`, `name`, `phone`, `email`, `password`, `gender`, `birthday`, `avatar`, `type`, `active`, `accessToken`, `createdAt`, `updatedAt`, `token_fcm`) VALUES
(1, 'Admin', '+84111111111', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'Admin', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(2, 'Driver', '+84222222222', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'Driver', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(3, 'Driver', '+84333333333', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'Driver', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(4, 'User_vip', '+84444444444', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'User_Vip', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicGhvbmUiOiIrODQ0NDQ0NDQ0NDQiLCJ0eXBlIjoiVXNlcl9WaXAiLCJpYXQiOjE2OTIxODM1NzUsImV4cCI6MTY5MzI2MzU3NX0.5uonl_EPt52dMZRKNxvrJ9aUFHedzl-vT2Nb29p_TKw', '2023-08-11 09:44:46', '2023-08-16 10:59:35', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(5, 'User', '+84555555555', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'User', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(6, 'Tổng đài 1', '+84666666666', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'CallCenterS1', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwicGhvbmUiOiIrODQ2NjY2NjY2NjYiLCJ0eXBlIjoiQ2FsbENlbnRlclMxIiwiaWF0IjoxNjkyMTgzNTY2LCJleHAiOjE2OTMyNjM1NjZ9.i01bmSAiMRC6RFYlFqgTybCK6oFaUwSfU2BAXf7uUo8', '2023-08-11 09:44:46', '2023-08-16 10:59:26', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(7, 'Tổng đài 2', '+84777777777', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'CallCenterS2', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(8, 'Tổng đài 3', '+84888888888', NULL, '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', NULL, NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'CallCenterS3', NULL, NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(9, 'Doan Huu Loc', '+84941544569', 'lapdoan.010102@gmail.com', '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', 'Male', NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'Driver', NULL, NULL, '2023-08-09 16:14:48', '2023-08-09 16:14:48', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(10, 'Nguyen Dang Manh Tu', '+84974220702', 'manhtu22702@gmail.com', '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', 'Male', NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'User_Vip', NULL, NULL, '2023-08-09 16:14:48', '2023-08-09 16:14:48', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(11, 'Le Nguyen Lan Vy', '+84777063550', 'lanvy@gmail.com', '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', 'Female', NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', '', NULL, NULL, '2023-08-09 16:14:48', '2023-08-09 16:14:48', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB'),
(12, 'Tang Kim Long', '+84974649123', 'kimlong@gmail.com', '$2a$10$Ficn2IbPjW2xSwbjIkkC0u6LmJNGCJmEAqT4Iuw0srI/GfXL/Aeee', 'Male', NULL, 'https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-facebook-dep-cho-nam-53-28-16-28-17.jpg', 'User', NULL, NULL, '2023-08-09 16:14:48', '2023-08-09 16:14:48', 'fj9Kb13NThm-4QqSAIu4rb:APA91bHOZm3Fja_OzP7tXdhV391geJ6ZIM_1W_KMOexa_VYF4OUL_M2K7QBrqJlxv1lRlTnJaOnHbDGyrgiP3niBJGoJ8x9y5RzLQn7SNhLbJA2mqgyxnoWENpeE6FTSIfy8dv7iatEB');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vehicles`
--

CREATE TABLE `Vehicles` (
  `id` int(11) NOT NULL,
  `driver_license` varchar(255) DEFAULT NULL,
  `vehicle_registration` varchar(255) DEFAULT NULL,
  `license_plate` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `vehicle_type_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `vehicles`
--

INSERT INTO `Vehicles` (`id`, `driver_license`, `vehicle_registration`, `license_plate`, `name`, `description`, `createdAt`, `updatedAt`, `driver_id`, `vehicle_type_id`) VALUES
(1, '0964155097', '123456', '30D-206.32', 'Honda 4 Chỗ Vip', NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 2, 1),
(2, '0964155097', '123456', '30D-206.32', 'Honda 7 Chỗ Vip', NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 3, 2),
(3, '0964155097', '123456', '30D-206.32', 'Honda 4 Chỗ Vip', NULL, '2023-08-11 09:44:46', '2023-08-11 09:44:46', 9, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vehicle_types`
--

CREATE TABLE `Vehicle_Types` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Đang đổ dữ liệu cho bảng `vehicle_types`
--

INSERT INTO `Vehicle_Types` (`id`, `name`, `createdAt`, `updatedAt`) VALUES
(1, 'Xe 4 Chỗ', '2023-08-11 09:44:46', '2023-08-11 09:44:46'),
(2, 'Xe 7 Chỗ', '2023-08-11 09:44:46', '2023-08-11 09:44:46');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `Conversations`
--
ALTER TABLE `Conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `trip_id` (`trip_id`);

--
-- Chỉ mục cho bảng `messages`
--
ALTER TABLE `Messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversation_id` (`conversation_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `rates`
--
ALTER TABLE `Rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trip_id` (`trip_id`);

--
-- Chỉ mục cho bảng `settings`
--
ALTER TABLE `Settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `Trips`
--
ALTER TABLE `Trips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- Chỉ mục cho bảng `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `vehicles`
--
ALTER TABLE `Vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `vehicle_type_id` (`vehicle_type_id`);

--
-- Chỉ mục cho bảng `vehicle_types`
--
ALTER TABLE `Vehicle_Types`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `Conversations`
--
ALTER TABLE `Conversations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `messages`
--
ALTER TABLE `Messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `rates`
--
ALTER TABLE `Rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `settings`
--
ALTER TABLE `Settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `Trips`
--
ALTER TABLE `Trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT cho bảng `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `vehicles`
--
ALTER TABLE `Vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `vehicle_types`
--
ALTER TABLE `Vehicle_Types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `Conversations`
--
ALTER TABLE `Conversations`
  ADD CONSTRAINT `Conversations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Conversations_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Conversations_ibfk_3` FOREIGN KEY (`trip_id`) REFERENCES `Trips` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `messages`
--
ALTER TABLE `Messages`
  ADD CONSTRAINT `Messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `Conversations` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `rates`
--
ALTER TABLE `Rates`
  ADD CONSTRAINT `Rates_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `Trips` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `settings`
--
ALTER TABLE `Settings`
  ADD CONSTRAINT `Settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `Trips`
--
ALTER TABLE `Trips`
  ADD CONSTRAINT `Trips_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Trips_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `vehicles`
--
ALTER TABLE `Vehicles`
  ADD CONSTRAINT `Vehicles_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Vehicles_ibfk_2` FOREIGN KEY (`vehicle_type_id`) REFERENCES `Vehicle_Types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
