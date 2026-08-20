-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2026 at 09:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smartcare`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `appointment_id` int(11) NOT NULL,
  `reference_no` varchar(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `location` varchar(50) NOT NULL,
  `schedule_date` date NOT NULL,
  `time_slot` varchar(30) NOT NULL,
  `service` varchar(100) DEFAULT 'General Consultation',
  `status` enum('booked','sent_to_doctor','serving','completed','cancelled') NOT NULL DEFAULT 'booked',
  `follow_up_date` date DEFAULT NULL,
  `follow_up_time_slot` varchar(30) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `slot_lock` varchar(120) GENERATED ALWAYS AS (if(`status` in ('booked','sent_to_doctor','serving'),concat(`location`,'|',`schedule_date`,'|',`time_slot`),NULL)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`appointment_id`, `reference_no`, `user_id`, `location`, `schedule_date`, `time_slot`, `service`, `status`, `follow_up_date`, `follow_up_time_slot`, `created_at`) VALUES
(1, 'GUA26081202', 6, 'Guagua', '2026-08-12', '1:20pm - 1:40pm', 'General Consultation', 'completed', '2026-08-14', '1:00pm - 1:20pm', '2026-08-11 17:00:09'),
(2, 'GUA26081401', 6, 'Guagua', '2026-08-14', '1:00pm - 1:20pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-11 17:03:11'),
(3, 'GUA26090202', 6, 'Guagua', '2026-09-02', '1:20pm - 1:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-11 17:04:47'),
(7, 'GUA26081904', 6, 'Guagua', '2026-08-19', '2:00pm - 2:20pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 06:40:01'),
(8, 'STR26081802', 6, 'Sta. Rita', '2026-08-18', '3:20pm - 3:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 15:08:13'),
(9, 'STR26081405', 12, 'Sta. Rita', '2026-08-14', '4:20pm - 4:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 16:14:24'),
(10, 'STR26082105', 6, 'Sta. Rita', '2026-08-21', '4:20pm - 4:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 16:15:51'),
(11, 'STR26082105', 6, 'Sta. Rita', '2026-08-21', '4:20pm - 4:40pm', 'General Consultation', 'booked', NULL, NULL, '2026-08-13 16:16:26'),
(12, 'STR26081405', 12, 'Sta. Rita', '2026-08-14', '4:20pm - 4:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 16:17:49'),
(13, 'STR26081405', 12, 'Sta. Rita', '2026-08-14', '4:20pm - 4:40pm', 'General Consultation', 'cancelled', NULL, NULL, '2026-08-13 18:01:36'),
(20, 'STR26081401', 12, 'Sta. Rita', '2026-08-14', '3:00pm - 3:20pm', 'General Consultation', 'completed', '2026-08-14', '2:20pm - 2:40pm', '2026-08-13 18:17:22'),
(21, 'GUA26081405', 12, 'Guagua', '2026-08-14', '2:20pm - 2:40pm', 'General Consultation', 'completed', NULL, NULL, '2026-08-13 18:19:53');

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(150) NOT NULL,
  `role` varchar(20) NOT NULL,
  `action` varchar(20) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `resource_id` varchar(50) DEFAULT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`id`, `user_id`, `user_name`, `role`, `action`, `resource_type`, `resource_id`, `description`, `created_at`) VALUES
(1, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Appointment', '4', 'Booked a new appointment for Delfin Felizardo on 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', '2026-08-13 06:25:15'),
(2, 6, 'Delfin Felizardo', 'patient', 'UPDATE', 'Appointment', '4', 'Cancelled Delfin Felizardo\'s appointment on 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita). Reason: testing audit log', '2026-08-13 06:25:24'),
(3, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Appointment', '5', 'Booked a new appointment for Delfin Felizardo on 2026-08-14 at 3:20pm - 3:40pm (Sta. Rita).', '2026-08-13 06:25:24'),
(4, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '5', 'Updated appointment status from Booked to Serving.', '2026-08-13 06:26:01'),
(5, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '5', 'Marked Delfin Felizardo\'s consultation complete. Follow-up requested for 2026-08-19 at 3:00pm - 3:20pm.', '2026-08-13 06:26:01'),
(6, 3, 'Mark Daniel Felizardo', 'doctor', 'CREATE', 'Appointment', '6', 'Booked a follow-up appointment for Delfin Felizardo on 2026-08-19 at 3:00pm - 3:20pm (Sta. Rita).', '2026-08-13 06:26:01'),
(7, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Sta. Rita', 'Updated Sta. Rita geofence coordinates from (14.9968000, 120.6531000) to (16.25, 120.46).', '2026-08-13 06:26:08'),
(8, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Sta. Rita', 'Updated Sta. Rita geofence coordinates from (16.2500000, 120.4600000) to (16.2449, 120.459).', '2026-08-13 06:26:08'),
(9, 8, 'Test Deleteme', 'patient', 'REGISTER', 'User', '8', 'Registered a new patient account.', '2026-08-13 06:26:58'),
(10, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'User', '8', 'Updated Test Deleteme\'s account (testdeleteme@example.com, role: patient). Password was changed.', '2026-08-13 06:29:53'),
(11, 3, 'Mark Daniel Felizardo', 'doctor', 'DELETE', 'User', '8', 'Deleted Test Deleteme\'s account (testdeleteme@example.com, role: patient).', '2026-08-13 06:29:53'),
(12, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 06:39:02'),
(13, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '3', 'Cancelled Delfin Felizardo\'s appointment on 2026-09-02 at 1:20pm - 1:40pm (Guagua). Reason: Rescheduled by the clinic.', '2026-08-08 06:40:00'),
(14, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '7', 'Rescheduled Delfin Felizardo\'s appointment to 2026-08-19 at 2:00pm - 2:20pm (Guagua).', '2026-08-05 06:40:01'),
(15, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Lubao', 'Updated Lubao geofence coordinates from (14.9376000, 120.5995000) to (14.9376, 120.5995).', '2026-08-13 10:01:55'),
(16, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Lubao', 'Updated Lubao geofence coordinates from (14.9376000, 120.5995000) to (14.9376, 120.5995).', '2026-08-13 10:01:55'),
(17, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6245000) to (14.9856, 120.6245).', '2026-08-13 10:01:56'),
(18, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6245000) to (14.9856, 120.6245).', '2026-08-13 10:01:56'),
(19, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Geofence', 'Sta. Rita', 'Updated Sta. Rita geofence coordinates from (16.2449000, 120.4590000) to (16.2449, 120.459).', '2026-08-13 10:01:57'),
(20, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 11:02:26'),
(21, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Appointment', '7', 'Updated appointment status from Booked to Cancelled.', '2026-08-13 11:05:56'),
(22, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Lubao', 'Updated Lubao geofence coordinates from (14.9376000, 120.5995000) to (14.9376, 120.5995).', '2026-08-13 11:11:37'),
(23, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Lubao', 'Updated Lubao geofence coordinates from (14.9376000, 120.5995000) to (14.9376, 120.5995).', '2026-08-13 11:11:38'),
(24, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6245000) to (14.9856, 120.6245).', '2026-08-13 11:11:38'),
(25, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6245000) to (14.9856, 120.6245).', '2026-08-13 11:11:38'),
(26, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Sta. Rita', 'Updated Sta. Rita geofence coordinates from (16.2449000, 120.4590000) to (16.2449, 120.459).', '2026-08-13 11:11:39'),
(27, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6245000) to (14.9856, 120.6246).', '2026-08-13 11:41:19'),
(28, 7, 'Daniela Felizardo', 'secretary', 'UPDATE', 'Geofence', 'Guagua', 'Updated Guagua geofence coordinates from (14.9856000, 120.6246000) to (14.9856, 120.6245).', '2026-08-13 11:41:25'),
(29, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 12:21:18'),
(30, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 13:56:34'),
(31, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 13:58:49'),
(32, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 13:59:36'),
(33, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 14:04:15'),
(34, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 14:11:41'),
(35, NULL, 'Juan Dela Cruz (juan@example.com)', 'guest', 'CREATE', 'Contact', NULL, 'Sent a Contact Us message: \"Anonymous guest test message.\"', '2026-08-13 14:38:44'),
(36, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Contact', NULL, 'Sent a Contact Us message: \"Logged-in patient test message.\"', '2026-08-13 14:38:48'),
(37, 3, 'Mark Daniel Felizardo', 'doctor', 'CREATE', 'Contact', NULL, 'Sent a Contact Us message: \"pogi po ni mark\"', '2026-08-13 14:41:27'),
(38, NULL, 'hi po (daniel@gmail.com)', 'guest', 'CREATE', 'Contact', NULL, 'Sent a Contact Us message: \"dasdasdas\"', '2026-08-13 14:45:21'),
(39, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 14:45:44'),
(40, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 14:46:02'),
(41, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 15:03:42'),
(42, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 15:04:41'),
(43, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 15:05:21'),
(44, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Appointment', '8', 'Booked a new appointment for Delfin Felizardo on 2026-08-18 at 3:20pm - 3:40pm (Sta. Rita).', '2026-08-13 15:08:13'),
(45, 9, 'Mark Daniel Felizardo', 'patient', 'REGISTER', 'User', '9', 'Registered a new patient account.', '2026-08-13 15:10:42'),
(46, 10, 'Test Duplicate', 'patient', 'REGISTER', 'User', '10', 'Registered a new patient account.', '2026-08-13 15:31:11'),
(47, 11, 'Test OTP', 'patient', 'REGISTER', 'User', '11', 'Registered a new patient account.', '2026-08-13 15:37:10'),
(48, 12, 'Mark Daniel Felizardo', 'patient', 'REGISTER', 'User', '12', 'Registered a new patient account.', '2026-08-13 15:45:49'),
(49, 12, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '12', 'Logged in.', '2026-08-13 15:46:11'),
(50, 9, 'Mark Daniel Felizardo', 'patient', 'UPDATE', 'Auth', '9', 'Reset password via email verification code.', '2026-08-13 15:52:12'),
(51, 9, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '9', 'Logged in.', '2026-08-13 15:52:12'),
(52, 12, 'Mark Daniel Felizardo', 'patient', 'UPDATE', 'Auth', '12', 'Reset password via email verification code.', '2026-08-13 16:02:43'),
(53, 12, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '12', 'Logged in.', '2026-08-13 16:03:12'),
(54, 12, 'Mark Daniel Felizardo', 'patient', 'CREATE', 'Appointment', '9', 'Booked a new appointment for Mark Daniel Felizardo on 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:14:24'),
(55, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 16:14:55'),
(56, 6, 'Delfin Felizardo', 'patient', 'UPDATE', 'Appointment', '8', 'Cancelled Delfin Felizardo\'s appointment on 2026-08-18 at 3:20pm - 3:40pm (Sta. Rita).', '2026-08-13 16:15:42'),
(57, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Appointment', '10', 'Booked a new appointment for Delfin Felizardo on 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:15:51'),
(58, 6, 'Delfin Felizardo', 'patient', 'UPDATE', 'Appointment', '10', 'Cancelled Delfin Felizardo\'s appointment on 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:16:07'),
(59, 12, 'Mark Daniel Felizardo', 'patient', 'UPDATE', 'Appointment', '9', 'Cancelled Mark Daniel Felizardo\'s appointment on 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:16:14'),
(60, 6, 'Delfin Felizardo', 'patient', 'CREATE', 'Appointment', '11', 'Booked a new appointment for Delfin Felizardo on 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:16:26'),
(61, 12, 'Mark Daniel Felizardo', 'patient', 'CREATE', 'Appointment', '12', 'Booked a new appointment for Mark Daniel Felizardo on 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 16:17:49'),
(62, 9, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '9', 'Logged in.', '2026-08-13 16:25:20'),
(63, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 16:42:15'),
(64, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 16:42:32'),
(65, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 16:43:27'),
(66, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 16:43:40'),
(67, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 16:44:49'),
(68, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 17:43:22'),
(69, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 17:54:49'),
(70, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 17:56:21'),
(71, 6, 'Delfin Felizardo', 'patient', 'LOGIN', 'Auth', '6', 'Logged in.', '2026-08-13 17:57:01'),
(72, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 17:57:30'),
(73, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '12', 'Cancelled Mark Daniel Felizardo\'s appointment on 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita). Reason: Rescheduled by the clinic.', '2026-08-13 18:01:36'),
(74, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '13', 'Rescheduled Mark Daniel Felizardo\'s appointment to 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', '2026-08-13 18:01:36'),
(75, 12, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '12', 'Logged in.', '2026-08-13 18:03:11'),
(76, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '13', 'Cancelled Mark Daniel Felizardo\'s appointment on 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita). Reason: secret erp', '2026-08-13 18:07:20'),
(77, NULL, 'Unknown', 'system', 'UPDATE', 'Appointment', '14', 'Marked Delfin Felizardo\'s consultation complete. Follow-up requested for 2026-08-25 at 9:00am - 9:20am.', '2026-08-13 18:09:44'),
(78, NULL, 'Unknown', 'system', 'UPDATE', 'Appointment', '15', 'Marked Delfin Felizardo\'s consultation complete. Follow-up requested for 2026-08-25 at 3:00pm - 3:20pm.', '2026-08-13 18:11:19'),
(79, NULL, 'Unknown', 'system', 'CREATE', 'Appointment', '16', 'Booked a follow-up appointment for Delfin Felizardo on 2026-08-25 at 3:00pm - 3:20pm (Sta. Rita).', '2026-08-13 18:11:19'),
(80, 9, 'Mark Daniel Felizardo', 'patient', 'CREATE', 'Appointment', '19', 'Booked a new appointment for Mark Daniel Felizardo on 2026-08-26 at 1:20pm - 1:40pm (Guagua).', '2026-08-13 18:15:02'),
(81, 12, 'Mark Daniel Felizardo', 'patient', 'CREATE', 'Appointment', '20', 'Booked a new appointment for Mark Daniel Felizardo on 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', '2026-08-13 18:17:22'),
(82, 7, 'Daniela Felizardo', 'secretary', 'LOGIN', 'Auth', '7', 'Logged in.', '2026-08-13 18:17:35'),
(83, 3, 'Mark Daniel Felizardo', 'doctor', 'LOGIN', 'Auth', '3', 'Logged in.', '2026-08-13 18:18:41'),
(84, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '20', 'Marked Mark Daniel Felizardo\'s consultation complete. Follow-up requested for 2026-08-14 at 2:20pm - 2:40pm.', '2026-08-13 18:19:53'),
(85, 3, 'Mark Daniel Felizardo', 'doctor', 'CREATE', 'Appointment', '21', 'Booked a follow-up appointment for Mark Daniel Felizardo on 2026-08-14 at 2:20pm - 2:40pm (Guagua).', '2026-08-13 18:19:53'),
(86, 12, 'Mark Daniel Felizardo', 'patient', 'LOGIN', 'Auth', '12', 'Logged in.', '2026-08-13 18:23:24'),
(87, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '22', 'Marked Delfin Felizardo\'s consultation complete.', '2026-08-13 18:23:46'),
(88, 3, 'Mark Daniel Felizardo', 'doctor', 'UPDATE', 'Appointment', '21', 'Marked Mark Daniel Felizardo\'s consultation complete.', '2026-08-13 18:29:10');

-- --------------------------------------------------------

--
-- Table structure for table `blocked_slot`
--

CREATE TABLE `blocked_slot` (
  `blocked_slot_id` int(11) NOT NULL,
  `location` varchar(50) NOT NULL,
  `schedule_date` date NOT NULL,
  `time_slot` varchar(30) NOT NULL,
  `blocked_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blocked_slot`
--

INSERT INTO `blocked_slot` (`blocked_slot_id`, `location`, `schedule_date`, `time_slot`, `blocked_by`, `created_at`) VALUES
(16, 'Guagua', '2026-07-24', '1:00pm - 1:30pm', 3, '2026-07-21 04:46:30'),
(17, 'Guagua', '2026-07-24', '10:30am - 11:00am', 3, '2026-07-21 04:46:30'),
(18, 'Guagua', '2026-07-24', '2:00pm - 2:30pm', 3, '2026-07-21 04:46:30'),
(19, 'Guagua', '2026-07-24', '2:30pm - 3:00pm', 3, '2026-07-21 04:46:31'),
(20, 'Guagua', '2026-07-24', '3:00pm - 3:30pm', 3, '2026-07-21 04:46:31'),
(21, 'Guagua', '2026-07-24', '1:30pm - 2:00pm', 3, '2026-07-21 04:46:31'),
(22, 'Guagua', '2026-07-24', '11:00am - 11:30am', 3, '2026-07-21 04:46:31'),
(23, 'Guagua', '2026-07-24', '10:00am - 10:30am', 3, '2026-07-21 04:46:32'),
(65, 'Sta. Rita', '2026-07-21', '1:00pm - 1:30pm', 3, '2026-07-21 05:13:32'),
(66, 'Sta. Rita', '2026-07-21', '11:00am - 11:30am', 3, '2026-07-21 05:13:33'),
(67, 'Sta. Rita', '2026-07-21', '2:00pm - 2:30pm', 3, '2026-07-21 05:13:33'),
(68, 'Sta. Rita', '2026-07-21', '1:30pm - 2:00pm', 3, '2026-07-21 05:13:34'),
(69, 'Sta. Rita', '2026-07-21', '2:30pm - 3:00pm', 3, '2026-07-21 05:13:34'),
(78, 'Sta. Rita', '2026-07-28', '9:30am - 10:00am', 3, '2026-07-28 06:31:41'),
(79, 'Sta. Rita', '2026-07-28', '10:30am - 11:00am', 3, '2026-07-28 06:31:42'),
(80, 'Sta. Rita', '2026-07-28', '10:00am - 10:30am', 3, '2026-07-28 06:31:44'),
(81, 'Sta. Rita', '2026-07-28', '11:00am - 11:30am', 3, '2026-07-28 06:31:45'),
(82, 'Sta. Rita', '2026-07-28', '12:00pm - 12:30pm', 3, '2026-07-28 06:36:26'),
(83, 'Sta. Rita', '2026-08-08', '9:00am - 9:30am', 3, '2026-08-05 07:32:55'),
(84, 'Sta. Rita', '2026-08-08', '9:30am - 10:00am', 3, '2026-08-05 07:32:56'),
(85, 'Sta. Rita', '2026-08-08', '10:00am - 10:30am', 3, '2026-08-05 07:32:57'),
(86, 'Sta. Rita', '2026-08-08', '10:30am - 11:00am', 3, '2026-08-05 08:10:36'),
(87, 'Sta. Rita', '2026-08-08', '8:30am - 9:00am', 3, '2026-08-05 08:10:40'),
(88, 'Sta. Rita', '2026-08-08', '8:00am - 8:30am', 3, '2026-08-05 08:10:42');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_geofence`
--

CREATE TABLE `clinic_geofence` (
  `location` varchar(50) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clinic_geofence`
--

INSERT INTO `clinic_geofence` (`location`, `latitude`, `longitude`, `updated_at`) VALUES
('Guagua', 14.9856000, 120.6245000, '2026-08-13 11:41:25'),
('Lubao', 14.9376000, 120.5995000, '2026-08-11 15:37:01'),
('Sta. Rita', 16.2449000, 120.4590000, '2026-08-13 06:26:08');

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE `doctor` (
  `doctor_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `personal_information_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`doctor_id`, `user_id`, `personal_information_id`) VALUES
(1, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `doctor_status`
--

CREATE TABLE `doctor_status` (
  `user_id` int(11) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 0,
  `current_location` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_tracking` tinyint(1) NOT NULL DEFAULT 0,
  `distances_json` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_status`
--

INSERT INTO `doctor_status` (`user_id`, `is_available`, `current_location`, `updated_at`, `is_tracking`, `distances_json`) VALUES
(3, 0, NULL, '2026-08-13 18:11:37', 0, '{\"Sta. Rita\":146309.88072200122,\"Guagua\":5983.349601602567,\"Lubao\":5.546345177791639}');

-- --------------------------------------------------------

--
-- Table structure for table `geofence_notification_log`
--

CREATE TABLE `geofence_notification_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `location` varchar(50) NOT NULL,
  `notified_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `geofence_notification_log`
--

INSERT INTO `geofence_notification_log` (`id`, `user_id`, `location`, `notified_date`, `created_at`) VALUES
(8, 3, 'Lubao', '2026-08-11', '2026-08-11 15:18:30'),
(13, 3, 'Guagua', '2026-08-12', '2026-08-11 16:02:04'),
(15, 3, 'Sta. Rita', '2026-08-13', '2026-08-13 05:48:32'),
(16, 3, 'Lubao', '2026-08-13', '2026-08-13 05:49:04'),
(19, 3, 'Guagua', '2026-08-13', '2026-08-13 09:53:51'),
(34, 3, 'Lubao', '2026-08-14', '2026-08-13 16:43:59');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT 'Alerts',
  `target_route` varchar(100) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`notification_id`, `user_id`, `title`, `message`, `type`, `target_route`, `is_read`, `created_at`) VALUES
(5, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-01 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-28 06:57:59'),
(6, 3, 'Appointment Rescheduled', 'Delfin Felizardo rescheduled to 2026-07-28 at 8:30am - 9:00am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-28 22:04:07'),
(7, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-07-29 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-28 22:19:36'),
(9, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-07-29 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-28 23:18:04'),
(10, 6, 'You\'re Being Called', 'Your appointment (STR26072903) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-07-29 00:30:27'),
(11, 6, 'Consultation Completed', 'Your consultation (STR26072903) is complete.', 'Alerts', '/appointment', 1, '2026-07-29 00:30:51'),
(12, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-01 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-29 00:31:36'),
(13, 3, 'Appointment Rescheduled', 'Delfin Felizardo rescheduled to 2026-07-29 at 8:00am - 8:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-29 00:32:06'),
(14, 6, 'You\'re Being Called', 'Your appointment (STR26072901) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-07-29 00:33:00'),
(15, 6, 'Consultation Completed', 'Your consultation (STR26072901) is complete.', 'Alerts', '/appointment', 1, '2026-07-29 00:33:24'),
(16, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-07-29 at 12:00pm - 12:30pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-07-29 00:35:14'),
(17, 6, 'You\'re Being Called', 'Your appointment (STR26072908) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-07-29 00:38:37'),
(18, 6, 'Appointment Cancelled', 'Your appointment (STR26072908) was cancelled by the clinic. Reason: kain muna me', 'Alerts', '/appointment', 1, '2026-07-29 00:51:41'),
(19, 6, 'Appointment Cancelled', 'Your appointment (STR26072903) was cancelled by the clinic. Reason: kain muna me', 'Alerts', '/appointment', 1, '2026-07-29 00:51:50'),
(20, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-05 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-05 00:51:16'),
(21, 6, 'Appointment in 1 hour', 'Your appointment on August 5 at 9:00am - 9:30am (Sta. Rita) is coming up. Please arrive earlier than your schedule, at least 10 minutes before.', 'Reminders', '/appointment', 1, '2026-08-05 00:51:21'),
(22, 6, 'Appointment in 10 minutes', 'Your appointment on August 5 at 9:00am - 9:30am (Sta. Rita) is starting soon. Please head to the clinic now.', 'Reminders', '/appointment', 1, '2026-08-05 00:51:22'),
(23, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080503).', 'Alerts', '/queue', 1, '2026-08-05 00:51:31'),
(24, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080503).', 'Alerts', '/queue', 1, '2026-08-05 00:51:45'),
(25, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080503).', 'Alerts', '/queue', 1, '2026-08-05 00:52:03'),
(26, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080503).', 'Alerts', '/queue', 1, '2026-08-05 00:52:12'),
(27, 6, 'You\'re Being Called', 'Your appointment (STR26080503) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-08-05 00:52:31'),
(28, 6, 'Appointment Cancelled', 'Your appointment (STR26080503) was cancelled by the clinic. Reason: mamaya kana bro', 'Alerts', '/appointment', 1, '2026-08-05 00:53:34'),
(29, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-05 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-05 00:54:12'),
(30, 6, 'Appointment in 1 hour', 'Your appointment on August 5 at 9:00am - 9:30am (Sta. Rita) is coming up. Please arrive earlier than your schedule, at least 10 minutes before.', 'Reminders', '/appointment', 1, '2026-08-05 00:54:17'),
(31, 6, 'Appointment in 10 minutes', 'Your appointment on August 5 at 9:00am - 9:30am (Sta. Rita) is starting soon. Please head to the clinic now.', 'Reminders', '/appointment', 1, '2026-08-05 00:54:19'),
(32, 6, 'You\'re Being Called', 'Your appointment (STR26080503) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-08-05 00:54:42'),
(33, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080503).', 'Alerts', '/queue', 1, '2026-08-05 00:55:04'),
(34, 6, 'Consultation Completed', 'Your consultation (STR26080503) is complete. Please come back on 8/21/2026 at 1:30pm - 2:00pm for your follow-up.', 'Alerts', '/appointment', 1, '2026-08-05 05:42:25'),
(35, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-08 at 9:00am - 9:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-05 07:45:03'),
(36, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-05 at 3:30pm - 4:00pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-05 08:11:50'),
(38, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-08 at 11:00am - 11:30am (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-05 08:21:10'),
(39, 3, 'New Appointment Booked', 'A patient booked 2026-08-12 at 1:40pm - 2:00pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-07 05:39:15'),
(40, 3, 'New Appointment Booked', 'A patient booked 2026-08-11 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-07 05:46:17'),
(41, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-05 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-07 05:52:31'),
(42, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-07 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-07 06:00:30'),
(43, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080701).', 'Alerts', '/queue', 1, '2026-08-07 06:03:42'),
(44, 6, 'You\'re Being Called', 'Your appointment (STR26080701) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-08-07 06:03:48'),
(45, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080701).', 'Alerts', '/queue', 1, '2026-08-07 06:03:51'),
(46, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26080701).', 'Alerts', '/queue', 1, '2026-08-07 06:03:52'),
(47, 6, 'Consultation Completed', 'Your consultation (STR26080701) is complete.', 'Alerts', '/appointment', 1, '2026-08-07 07:25:31'),
(48, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-14 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 06:17:44'),
(49, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-11 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 06:23:12'),
(50, 6, 'Appointment Cancelled', 'Your appointment (STR26081101) was cancelled by the clinic. Reason: No reason provided.', 'Alerts', '/appointment', 1, '2026-08-11 07:03:58'),
(51, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-11 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 07:16:40'),
(52, 6, 'You\'re Being Called', 'Your appointment (STR26081102) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-08-11 07:17:03'),
(55, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-12 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 16:12:25'),
(56, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-12 at 1:00pm - 1:20pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 16:13:11'),
(57, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-19 at 2:00pm - 2:20pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 16:13:50'),
(58, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-21 at 1:20pm - 1:40pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 16:17:45'),
(59, 3, 'New Appointment Booked', 'Maria Reyes booked 2026-08-19 at 1:00pm - 1:20pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 16:17:46'),
(60, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-12 at 1:20pm - 1:40pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 17:00:09'),
(61, 6, 'You\'re Being Called', 'Your appointment (GUA26081202) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 1, '2026-08-11 17:01:51'),
(62, 6, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (GUA26081202).', 'Alerts', '/queue', 1, '2026-08-11 17:02:29'),
(63, 6, 'Consultation Completed', 'Your consultation (GUA26081202) is complete. Please come back on 8/14/2026 at 1:00pm - 1:20pm for your follow-up.', 'Alerts', '/appointment', 1, '2026-08-11 17:03:12'),
(64, 3, 'Appointment Rescheduled', 'Delfin Felizardo rescheduled to 2026-09-02 at 1:20pm - 1:40pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-11 17:04:47'),
(65, 6, 'Appointment Rescheduled', 'Your appointment was rescheduled to 2026-09-02 at 1:20pm - 1:40pm (Guagua) by the clinic.', 'Alerts', '/appointment', 1, '2026-08-11 17:04:48'),
(66, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 06:25:15'),
(67, 7, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 06:25:15'),
(68, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-14 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 06:25:24'),
(69, 7, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-14 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 06:25:24'),
(70, 3, 'Appointment Rescheduled', 'Delfin Felizardo rescheduled to 2026-08-19 at 2:00pm - 2:20pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 06:40:01'),
(71, 7, 'Appointment Rescheduled', 'Delfin Felizardo rescheduled to 2026-08-19 at 2:00pm - 2:20pm (Guagua).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 06:40:01'),
(72, 6, 'Appointment Rescheduled', 'Your appointment was rescheduled to 2026-08-19 at 2:00pm - 2:20pm (Guagua) by the clinic.', 'Alerts', '/appointment', 1, '2026-08-13 06:40:02'),
(73, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-18 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 15:08:13'),
(74, 7, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-18 at 3:20pm - 3:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 15:08:13'),
(75, 3, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 16:14:24'),
(76, 7, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 16:14:24'),
(77, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 16:15:51'),
(78, 7, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 1, '2026-08-13 16:15:51'),
(79, 3, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 16:16:26'),
(80, 7, 'New Appointment Booked', 'Delfin Felizardo booked 2026-08-21 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 1, '2026-08-13 16:16:26'),
(81, 3, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 16:17:49'),
(82, 7, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 1, '2026-08-13 16:17:49'),
(83, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 17:57:39'),
(84, 12, 'You\'re Being Called', 'Your appointment (STR26081405) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 0, '2026-08-13 17:57:41'),
(85, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 17:57:58'),
(86, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 18:00:55'),
(87, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 18:01:05'),
(88, 3, 'Appointment Rescheduled', 'Mark Daniel Felizardo rescheduled to 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 18:01:36'),
(89, 7, 'Appointment Rescheduled', 'Mark Daniel Felizardo rescheduled to 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 18:01:36'),
(90, 12, 'Appointment Rescheduled', 'Your appointment was rescheduled to 2026-08-14 at 4:20pm - 4:40pm (Sta. Rita) by the clinic.', 'Alerts', '/appointment', 0, '2026-08-13 18:01:36'),
(91, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 18:03:20'),
(92, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 18:03:35'),
(93, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081405).', 'Alerts', '/queue', 0, '2026-08-13 18:03:53'),
(94, 12, 'You\'re Being Called', 'Your appointment (STR26081405) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 0, '2026-08-13 18:04:15'),
(95, 12, 'Appointment Cancelled', 'Your appointment (STR26081405) was cancelled by the clinic. Reason: secret erp', 'Alerts', '/appointment', 1, '2026-08-13 18:07:20'),
(96, 3, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-26 at 1:20pm - 1:40pm (Guagua).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 18:15:02'),
(97, 7, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-26 at 1:20pm - 1:40pm (Guagua).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 18:15:02'),
(98, 3, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/doctor-schedule', 0, '2026-08-13 18:17:22'),
(99, 7, 'New Appointment Booked', 'Mark Daniel Felizardo booked 2026-08-14 at 3:00pm - 3:20pm (Sta. Rita).', 'Alerts', '/secretary-schedule', 0, '2026-08-13 18:17:22'),
(100, 12, 'You\'re Being Called', 'Please proceed to the counter now for your appointment (STR26081401).', 'Alerts', '/queue', 1, '2026-08-13 18:17:40'),
(101, 12, 'You\'re Being Called', 'Your appointment (STR26081401) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 0, '2026-08-13 18:17:57'),
(102, 12, 'Consultation Completed', 'Your consultation (STR26081401) is complete. Please come back on 8/14/2026 at 2:20pm - 2:40pm (Guagua) for your follow-up.', 'Alerts', '/appointment', 0, '2026-08-13 18:19:54'),
(103, 12, 'You\'re Being Called', 'Your appointment (GUA26081405) is being sent to the doctor. Please stay nearby.', 'Alerts', '/queue', 0, '2026-08-13 18:29:00'),
(104, 12, 'Consultation Completed', 'Your consultation (GUA26081405) is complete.', 'Alerts', '/appointment', 0, '2026-08-13 18:29:11');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset`
--

CREATE TABLE `password_reset` (
  `email` varchar(150) NOT NULL,
  `code` varchar(6) NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `patient_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `personal_information_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`patient_id`, `user_id`, `personal_information_id`) VALUES
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(9, 9, 9),
(12, 12, 12);

-- --------------------------------------------------------

--
-- Table structure for table `personal_information`
--

CREATE TABLE `personal_information` (
  `personal_information_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `civil_status` varchar(50) DEFAULT NULL,
  `emergency_contact` varchar(150) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `personal_information`
--

INSERT INTO `personal_information` (`personal_information_id`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `contact_number`, `gender`, `occupation`, `civil_status`, `emergency_contact`, `address`) VALUES
(2, 'Maria', 'Santos', 'Reyes', '2000-01-15', '09171234567', 'Female', 'Nurse', 'Single', 'Juan Reyes - 09991234567', 'Sta. Rita, San Fernando, Pampanga'),
(3, 'Mark Daniel', 'Javier', 'Felizardo', '2000-01-12', '09935918552', 'Female', 'Secret', 'Single', '09935918552', 'Tabang Guiguinto Bulacan'),
(4, 'Jose', 'Cruz', 'Ramos', '2000-01-15', '', 'Male', NULL, NULL, '', ''),
(5, 'Patient', 'Mid', 'One', '2000-01-14', '09935918552', 'Female', NULL, NULL, NULL, NULL),
(6, 'Delfin', 'Javier', 'Felizardo', '2000-01-19', '', 'Male', '', '', '', ''),
(7, 'Daniela', 'Javier', 'Felizardo', '2005-05-07', '0912342323', 'Male', NULL, NULL, '', ''),
(9, 'Mark Daniel', 'Javier', 'Felizardo', '2005-05-07', '09935918552', 'Male', NULL, NULL, NULL, NULL),
(12, 'Mark Daniel', 'Javier', 'Felizardo', '2005-05-07', '09935918552', 'Male', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `secretary`
--

CREATE TABLE `secretary` (
  `secretary_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `personal_information_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `secretary`
--

INSERT INTO `secretary` (`secretary_id`, `user_id`, `personal_information_id`) VALUES
(2, 6, 6),
(3, 7, 7);

-- --------------------------------------------------------

--
-- Table structure for table `signup_verification`
--

CREATE TABLE `signup_verification` (
  `email` varchar(150) NOT NULL,
  `code` varchar(6) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('patient','doctor','secretary') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `password`, `role`, `created_at`) VALUES
(2, 'maria.reyes@example.com', '$2y$10$Qv/cqjaeGX.vhkfMTT13cuMVu2s4hO3kRnfsCkND7b5OF7N655unG', 'patient', '2026-07-13 20:02:07'),
(3, 'felizardo886@gmail.com', '$2y$10$QSY.oH21P1mtvSVwIJbtJeGlNkWWF8lTuxtxrmnuOJ14vTzH0dra6', 'doctor', '2026-07-13 20:09:32'),
(4, 'jose.ramos@example.com', '$2y$10$mP2u9/orMur9BdSl9dpSpu4utAg4X6z1SI7vxiqLqU.jNLFAWk98K', 'patient', '2026-07-18 21:10:39'),
(5, 'patient1@gmail.com', '$2y$10$QcNiM0sXFIUoyMnCyz3pu.KZWqPc49NwncATNxEJaFlESJolrCZWi', 'patient', '2026-07-21 05:12:08'),
(6, 'delfin@gmail.com', '$2y$10$IGjV7Ln64o3ZOAnAucXBgORUsP/Ojht1NQHbrM6Oqn/mJU3OL8cZu', 'patient', '2026-07-24 22:00:32'),
(7, 'secretary@gmail.com', '$2y$10$XnxCCdsRrcxhZpHI5qX8/egYbP5iPkKJ0qQoX1.jjH2v2nIRt79/q', 'secretary', '2026-08-11 17:12:14'),
(9, 'admin@gmail.com', '$2y$10$nQ9v8URK0bMlZpFEbCk7h.N.b89IJ5o/EhaWIw82sBemdrjjoRYv6', 'patient', '2026-08-13 15:10:42'),
(12, '2023300924@pampangastateu.edu.ph', '$2y$10$e0PjT2/IdrVZi3I8uTWAzeHk3FeH48d00vvOZtZAi8P.WEzLsJDJK', 'patient', '2026-08-13 15:45:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`appointment_id`),
  ADD UNIQUE KEY `uniq_active_slot` (`slot_lock`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_resource` (`resource_type`,`resource_id`);

--
-- Indexes for table `blocked_slot`
--
ALTER TABLE `blocked_slot`
  ADD PRIMARY KEY (`blocked_slot_id`),
  ADD UNIQUE KEY `uniq_slot` (`location`,`schedule_date`,`time_slot`);

--
-- Indexes for table `clinic_geofence`
--
ALTER TABLE `clinic_geofence`
  ADD PRIMARY KEY (`location`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`doctor_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `personal_information_id` (`personal_information_id`);

--
-- Indexes for table `doctor_status`
--
ALTER TABLE `doctor_status`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `geofence_notification_log`
--
ALTER TABLE `geofence_notification_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_notify` (`user_id`,`location`,`notified_date`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indexes for table `password_reset`
--
ALTER TABLE `password_reset`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`patient_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `personal_information_id` (`personal_information_id`);

--
-- Indexes for table `personal_information`
--
ALTER TABLE `personal_information`
  ADD PRIMARY KEY (`personal_information_id`);

--
-- Indexes for table `secretary`
--
ALTER TABLE `secretary`
  ADD PRIMARY KEY (`secretary_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `personal_information_id` (`personal_information_id`);

--
-- Indexes for table `signup_verification`
--
ALTER TABLE `signup_verification`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `blocked_slot`
--
ALTER TABLE `blocked_slot`
  MODIFY `blocked_slot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `doctor`
--
ALTER TABLE `doctor`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `geofence_notification_log`
--
ALTER TABLE `geofence_notification_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `patient`
--
ALTER TABLE `patient`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `personal_information`
--
ALTER TABLE `personal_information`
  MODIFY `personal_information_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `secretary`
--
ALTER TABLE `secretary`
  MODIFY `secretary_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `doctor_ibfk_2` FOREIGN KEY (`personal_information_id`) REFERENCES `personal_information` (`personal_information_id`) ON DELETE CASCADE;

--
-- Constraints for table `doctor_status`
--
ALTER TABLE `doctor_status`
  ADD CONSTRAINT `fk_doctor_status_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `geofence_notification_log`
--
ALTER TABLE `geofence_notification_log`
  ADD CONSTRAINT `fk_geofence_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `patient_ibfk_2` FOREIGN KEY (`personal_information_id`) REFERENCES `personal_information` (`personal_information_id`) ON DELETE CASCADE;

--
-- Constraints for table `secretary`
--
ALTER TABLE `secretary`
  ADD CONSTRAINT `secretary_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `secretary_ibfk_2` FOREIGN KEY (`personal_information_id`) REFERENCES `personal_information` (`personal_information_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
