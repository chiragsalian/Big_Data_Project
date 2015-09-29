-- MySQL dump 10.13  Distrib 5.6.24, for osx10.8 (x86_64)
--
-- Host: localhost    Database: yelp
-- ------------------------------------------------------
-- Server version	5.6.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `business_category`
--

DROP TABLE IF EXISTS `business_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_category` (
  `business_id` varchar(22) DEFAULT NULL,
  `category` varchar(15) DEFAULT NULL,
  KEY `business_id` (`business_id`),
  KEY `category` (`category`),
  CONSTRAINT `business_category_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `business_main` (`business_id`),
  CONSTRAINT `business_category_ibfk_2` FOREIGN KEY (`category`) REFERENCES `categories` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_category`
--

LOCK TABLES `business_category` WRITE;
/*!40000 ALTER TABLE `business_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_hours` (
  `business_id` varchar(22) DEFAULT NULL,
  `monday_open_time` time DEFAULT NULL,
  `monday_close_time` time DEFAULT NULL,
  `tuesday_open_time` time DEFAULT NULL,
  `tuesday_close_time` time DEFAULT NULL,
  `wednesday_open_time` time DEFAULT NULL,
  `wednesday_close_time` time DEFAULT NULL,
  `thursday_open_time` time DEFAULT NULL,
  `thursday_close_time` time DEFAULT NULL,
  `friday_open_time` time DEFAULT NULL,
  `friday_close_time` time DEFAULT NULL,
  `saturday_open_time` time DEFAULT NULL,
  `saturday_close_time` time DEFAULT NULL,
  `sunday_open_time` time DEFAULT NULL,
  `sunday_close_time` time DEFAULT NULL,
  KEY `business_id` (`business_id`),
  CONSTRAINT `business_hours_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `business_main` (`business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_hours`
--

LOCK TABLES `business_hours` WRITE;
/*!40000 ALTER TABLE `business_hours` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_main`
--

DROP TABLE IF EXISTS `business_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_main` (
  `business_id` varchar(22) NOT NULL,
  `fulladdress` varchar(60) DEFAULT NULL,
  `city` varchar(15) NOT NULL,
  `review_count` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `stars` int(11) DEFAULT NULL,
  PRIMARY KEY (`business_id`),
  KEY `state` (`state`),
  CONSTRAINT `business_main_ibfk_1` FOREIGN KEY (`state`) REFERENCES `state` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_main`
--

LOCK TABLES `business_main` WRITE;
/*!40000 ALTER TABLE `business_main` DISABLE KEYS */;
INSERT INTO `business_main` VALUES ('cE27W9VPgO88Qxe4ol6y_g','1530 Hamilton Rd\nBethel Park, PA 15234','Bethel Park',5,'PA','Cool Springs Golf Center',-80.0159,40.3569,3),('UsFtqoBl7naz8AVUBZMjQQ','202 McClure St\nDravosburg, PA 15034','Dravosburg',4,'PA','Clancy\'s Pub',-79.8869,40.3505,4),('vcNAWiLM4dR7D2nwwJ7nCA','4840 E Indian School Rd\nSte 101\nPhoenix, AZ 85018','Phoenix',9,'AZ','Eric Goldberg, MD',-111.984,33.4993,4);
/*!40000 ALTER TABLE `business_main` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `category` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review` (
  `review_id` varchar(22) NOT NULL DEFAULT '',
  `business_id` varchar(22) DEFAULT NULL,
  `user_id` varchar(22) DEFAULT NULL,
  `stars` int(11) DEFAULT NULL,
  `text` varchar(1000) DEFAULT NULL,
  `votes_funny` int(11) DEFAULT NULL,
  `votes_useful` int(11) DEFAULT NULL,
  `votes_cool` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES ('15SdjuK7DmYqUAj6rjGowg','vcNAWiLM4dR7D2nwwJ7nCA','Xqd0DzHaiyRqVH3WRG7hzg',5,'dr. goldberg offers everything i look for in a general practitioner.  he\'s nice and easy to talk to without being patronizing; he\'s always on time in seeing his patients; he\'s affiliated with a top-notch hospital (nyu) which my parents have explained to me is very important in case something happens and you need surgery; and you can get referrals to see specialists without having to see him first.  really, what more do you need?  i\'m sitting here trying to think of any complaints i have about him, but i\'m really drawing a blank.',0,1,2,'2007-05-17');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `ID` char(2) NOT NULL DEFAULT '',
  `NAME` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES ('AK','Alaska'),('AL','Alabama'),('AR','Arkansas'),('AS','American Samoa'),('AZ','Arizona'),('CA','California'),('CO','Colorado'),('CT','Connecticut'),('DC','District Of Columbia'),('DE','Delaware'),('FL','Florida'),('FM','Federated States Of Micronesia'),('GA','Georgia'),('GU','Guam'),('HI','Hawaii'),('IA','Iowa'),('ID','Idaho'),('IL','Illinois'),('IN','Indiana'),('KS','Kansas'),('KY','Kentucky'),('LA','Louisiana'),('MA','Massachusetts'),('MD','Maryland'),('ME','Maine'),('MH','Marshall Islands'),('MI','Michigan'),('MN','Minnesota'),('MO','Missouri'),('MP','Northern Mariana Islands'),('MS','Mississippi'),('MT','Montana'),('NC','North Carolina'),('ND','North Dakota'),('NE','Nebraska'),('NH','New Hampshire'),('NJ','New Jersey'),('NM','New Mexico'),('NV','Nevada'),('NY','New York'),('OH','Ohio'),('OK','Oklahoma'),('OR','Oregon'),('PA','Pennsylvania'),('PR','Puerto Rico'),('PW','Palau'),('RI','Rhode Island'),('SC','South Carolina'),('SD','South Dakota'),('TN','Tennessee'),('TX','Texas'),('UT','Utah'),('VA','Virginia'),('VI','Virgin Islands'),('VT','Vermont'),('WA','Washington'),('WI','Wisconsin'),('WV','West Virginia'),('WY','Wyoming');
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_detail`
--

DROP TABLE IF EXISTS `user_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_detail` (
  `user_id` varchar(22) DEFAULT NULL,
  `profile` int(11) DEFAULT NULL,
  `cute` int(11) DEFAULT NULL,
  `funny` int(11) DEFAULT NULL,
  `plain` int(11) DEFAULT NULL,
  `writer` int(11) DEFAULT NULL,
  `note` int(11) DEFAULT NULL,
  `photo` int(11) DEFAULT NULL,
  `hot` int(11) DEFAULT NULL,
  `cool` int(11) DEFAULT NULL,
  `more` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_detail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_main` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_detail`
--

LOCK TABLES `user_detail` WRITE;
/*!40000 ALTER TABLE `user_detail` DISABLE KEYS */;
INSERT INTO `user_detail` VALUES ('Rir-YRPPClKXDFQbc3BsVw',41,114,222,405,230,164,89,708,554,54);
/*!40000 ALTER TABLE `user_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_main`
--

DROP TABLE IF EXISTS `user_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_main` (
  `user_id` varchar(22) NOT NULL,
  `review_count` int(11) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `avg_stars` float DEFAULT NULL,
  `fans` int(11) DEFAULT NULL,
  `votes_funny` int(11) DEFAULT NULL,
  `votes_cool` int(11) DEFAULT NULL,
  `votes_useful` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_main`
--

LOCK TABLES `user_main` WRITE;
/*!40000 ALTER TABLE `user_main` DISABLE KEYS */;
INSERT INTO `user_main` VALUES ('18kPq7GPye-YQ3LyKyAZPw',108,'Russel',4.14,69,166,245,278),('Rir-YRPPClKXDFQbc3BsVw',754,'Megan',4.26,372,2001,3021,3757);
/*!40000 ALTER TABLE `user_main` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-02  5:12:10
