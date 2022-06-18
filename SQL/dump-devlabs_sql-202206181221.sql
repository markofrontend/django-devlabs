-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: devlabs_sql
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bioskop`
--

DROP TABLE IF EXISTS `bioskop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bioskop` (
  `bid` int NOT NULL AUTO_INCREMENT,
  `ime` varchar(100) NOT NULL,
  `naziv` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`bid`),
  KEY `naziv` (`naziv`),
  CONSTRAINT `bioskop_ibfk_1` FOREIGN KEY (`naziv`) REFERENCES `grad` (`naziv`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bioskop`
--

LOCK TABLES `bioskop` WRITE;
/*!40000 ALTER TABLE `bioskop` DISABLE KEYS */;
INSERT INTO `bioskop` VALUES (1,'Cineplexx Podgorica','Podgorica'),(2,'Cineplexx Beograd','Beograd'),(3,'Cineplexx Split','Split');
/*!40000 ALTER TABLE `bioskop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drzava`
--

DROP TABLE IF EXISTS `drzava`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drzava` (
  `naziv` varchar(50) NOT NULL,
  PRIMARY KEY (`naziv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drzava`
--

LOCK TABLES `drzava` WRITE;
/*!40000 ALTER TABLE `drzava` DISABLE KEYS */;
INSERT INTO `drzava` VALUES ('Crna Gora'),('Hrvatska'),('Srbija');
/*!40000 ALTER TABLE `drzava` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `film`
--

DROP TABLE IF EXISTS `film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `film` (
  `fid` int NOT NULL AUTO_INCREMENT,
  `naslov` varchar(200) NOT NULL,
  `trajanje` int DEFAULT NULL,
  PRIMARY KEY (`fid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `film`
--

LOCK TABLES `film` WRITE;
/*!40000 ALTER TABLE `film` DISABLE KEYS */;
INSERT INTO `film` VALUES (1,'LOŠI MOMCI',100),(2,'PATROLNE ŠAPE FILM',88),(3,'SVIJET IZ DOBA JURE: NADMOĆ',146),(4,'TOP GAN - MAVERIK',131),(5,'ZLOČIN U HOLIVUDU',110);
/*!40000 ALTER TABLE `film` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grad`
--

DROP TABLE IF EXISTS `grad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grad` (
  `naziv` varchar(50) NOT NULL,
  `drzava` varchar(50) DEFAULT NULL,
  `broj_stanovnika` int DEFAULT NULL,
  PRIMARY KEY (`naziv`),
  KEY `drzava` (`drzava`),
  CONSTRAINT `grad_ibfk_1` FOREIGN KEY (`drzava`) REFERENCES `drzava` (`naziv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grad`
--

LOCK TABLES `grad` WRITE;
/*!40000 ALTER TABLE `grad` DISABLE KEYS */;
INSERT INTO `grad` VALUES ('Beograd','Srbija',1576124),('Podgorica','Crna Gora',150977),('Split','Hrvatska',178627);
/*!40000 ALTER TABLE `grad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projekcija`
--

DROP TABLE IF EXISTS `projekcija`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projekcija` (
  `pid` int NOT NULL AUTO_INCREMENT,
  `fid` int DEFAULT NULL,
  `broj` int DEFAULT NULL,
  `bid` int DEFAULT NULL,
  `broj_gledalaca` int DEFAULT '0',
  PRIMARY KEY (`pid`),
  KEY `fid` (`fid`),
  KEY `broj` (`broj`,`bid`),
  CONSTRAINT `projekcija_ibfk_1` FOREIGN KEY (`fid`) REFERENCES `film` (`fid`),
  CONSTRAINT `projekcija_ibfk_2` FOREIGN KEY (`broj`, `bid`) REFERENCES `sala` (`broj`, `bid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projekcija`
--

LOCK TABLES `projekcija` WRITE;
/*!40000 ALTER TABLE `projekcija` DISABLE KEYS */;
INSERT INTO `projekcija` VALUES (1,1,1,1,24),(2,1,2,2,42),(3,1,3,2,12),(4,1,2,3,69),(5,4,1,1,24),(6,5,3,3,140),(7,2,3,3,88),(8,2,1,2,55),(9,2,3,1,99),(10,2,3,1,140),(11,4,2,3,41),(12,5,1,1,22),(13,4,3,3,2);
/*!40000 ALTER TABLE `projekcija` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sala`
--

DROP TABLE IF EXISTS `sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sala` (
  `broj` int NOT NULL,
  `bid` int NOT NULL,
  `kapacitet` int NOT NULL,
  PRIMARY KEY (`broj`,`bid`),
  KEY `bid` (`bid`),
  CONSTRAINT `sala_ibfk_1` FOREIGN KEY (`bid`) REFERENCES `bioskop` (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sala`
--

LOCK TABLES `sala` WRITE;
/*!40000 ALTER TABLE `sala` DISABLE KEYS */;
INSERT INTO `sala` VALUES (1,1,135),(1,2,96),(1,3,107),(2,1,129),(2,2,152),(2,3,181),(3,1,132),(3,2,169),(3,3,166);
/*!40000 ALTER TABLE `sala` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'devlabs_sql'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-18 12:21:08
