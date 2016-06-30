-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: CoCoBBF
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

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
-- Table structure for table `ases`
--

DROP TABLE IF EXISTS `ases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ases` (
  `id` int(10) unsigned NOT NULL,
  `bgp_ip` varchar(45) DEFAULT NULL,
  `as_num` int(11) DEFAULT NULL,
  `as_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ases`
--

LOCK TABLES `ases` WRITE;
/*!40000 ALTER TABLE `ases` DISABLE KEYS */;
/*!40000 ALTER TABLE `ases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ext_links`
--

DROP TABLE IF EXISTS `ext_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ext_links` (
  `id` int(11) NOT NULL,
  `switch` int(11) DEFAULT NULL,
  `as` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `switch_idx` (`switch`),
  KEY `as_idx` (`as`),
  CONSTRAINT `as_fk` FOREIGN KEY (`as`) REFERENCES `ases` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `switch_fk` FOREIGN KEY (`switch`) REFERENCES `switches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ext_links`
--

LOCK TABLES `ext_links` WRITE;
/*!40000 ALTER TABLE `ext_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `ext_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `from_idx` (`from`),
  KEY `to_idx` (`to`),
  CONSTRAINT `from` FOREIGN KEY (`from`) REFERENCES `switches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `to` FOREIGN KEY (`to`) REFERENCES `switches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links`
--

LOCK TABLES `links` WRITE;
/*!40000 ALTER TABLE `links` DISABLE KEYS */;
INSERT INTO `links` VALUES (1,6,4),(2,4,2),(3,3,6),(4,3,2),(5,3,4),(6,6,1),(7,1,5),(8,5,2);
/*!40000 ALTER TABLE `links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site2vpn`
--

DROP TABLE IF EXISTS `site2vpn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site2vpn` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `vpnid` int(10) unsigned DEFAULT NULL,
  `siteid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `site_idx` (`siteid`),
  KEY `vpn_idx` (`vpnid`),
  CONSTRAINT `site` FOREIGN KEY (`siteid`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vpn` FOREIGN KEY (`vpnid`) REFERENCES `vpns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site2vpn`
--

LOCK TABLES `site2vpn` WRITE;
/*!40000 ALTER TABLE `site2vpn` DISABLE KEYS */;
/*!40000 ALTER TABLE `site2vpn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitelinks`
--

DROP TABLE IF EXISTS `sitelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitelinks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `site` int(10) unsigned NOT NULL,
  `switch` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `site_idx` (`site`),
  KEY `switch_idx` (`switch`),
  CONSTRAINT `from_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `to_switch` FOREIGN KEY (`switch`) REFERENCES `switches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitelinks`
--

LOCK TABLES `sitelinks` WRITE;
/*!40000 ALTER TABLE `sitelinks` DISABLE KEYS */;
INSERT INTO `sitelinks` VALUES (1,4,4),(2,2,5),(3,1,2),(4,3,3);
/*!40000 ALTER TABLE `sitelinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `switch` int(11) NOT NULL,
  `remote_port` int(10) unsigned NOT NULL,
  `local_port` int(10) unsigned NOT NULL,
  `vlanid` int(10) unsigned NOT NULL,
  `ipv4prefix` varchar(45) NOT NULL,
  `mac_address` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `switch_idx` (`switch`),
  CONSTRAINT `switch_id` FOREIGN KEY (`switch`) REFERENCES `switches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'h2He',0,0,2,4,0,0,'10.0.2.0/24','00:00:10:00:02:01'),(2,'h7N',0,0,5,3,0,0,'10.0.7.0/24','00:00:10:00:07:01'),(3,'h5B',0,0,3,4,0,0,'10.0.5.0/24','00:00:10:00:05:01'),(4,'h3Li',0,0,4,4,0,0,'10.0.3.0/24','00:00:10:00:03:01');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `switches`
--

DROP TABLE IF EXISTS `switches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `switches` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `mpls_label` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`name`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `switches`
--

LOCK TABLES `switches` WRITE;
/*!40000 ALTER TABLE `switches` DISABLE KEYS */;
INSERT INTO `switches` VALUES (1,'openflow:100',0,0,0),(2,'openflow:64',0,0,0),(3,'openflow:32',0,0,0),(4,'openflow:128',0,0,0),(5,'openflow:1',0,0,0),(6,'openflow:96',0,0,0);
/*!40000 ALTER TABLE `switches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vpns`
--

DROP TABLE IF EXISTS `vpns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vpns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `pathProtection` varchar(45) DEFAULT NULL,
  `failoverType` varchar(45) DEFAULT NULL,
  `isPublic` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vpns`
--

LOCK TABLES `vpns` WRITE;
/*!40000 ALTER TABLE `vpns` DISABLE KEYS */;
/*!40000 ALTER TABLE `vpns` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-03-11 23:27:12
