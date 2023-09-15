-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: money_pos
-- ------------------------------------------------------
-- Server version	8.0.27

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
-- Table structure for table `gms_brand`
--
CREATE DATABASE IF NOT EXISTS `money_pos` CHARACTER SET 'utf8mb4';
USE money_pos;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `gms_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gms_brand` (
  `id` bigint unsigned NOT NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '品牌logo',
  `name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '品牌描述',
  `goods_count` int unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL,
  `tenant_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品品牌表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gms_brand`
--

LOCK TABLES `gms_brand` WRITE;
/*!40000 ALTER TABLE `gms_brand` DISABLE KEYS */;
INSERT INTO `gms_brand` VALUES (1701775713710555136,'brand/1694573136385.jpg','玉溪','12333',2,'money','2023-09-13 09:52:02','money','2023-09-13 09:52:02',0);
/*!40000 ALTER TABLE `gms_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gms_goods`
--

DROP TABLE IF EXISTS `gms_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gms_goods` (
  `id` bigint NOT NULL,
  `brand_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '品牌id',
  `category_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '分类id',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `pinyin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '商品拼音',
  `pic` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '单位',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '描述',
  `purchase_price` decimal(10,2) NOT NULL COMMENT '进价',
  `sale_price` decimal(10,2) NOT NULL COMMENT '售价',
  `stock` bigint NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` bigint unsigned NOT NULL DEFAULT '0' COMMENT '销量',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'SALE' COMMENT '状态',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `size` varchar(32) DEFAULT NULL COMMENT '规格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gms_goods`
--

LOCK TABLES `gms_goods` WRITE;
/*!40000 ALTER TABLE `gms_goods` DISABLE KEYS */;
INSERT INTO `gms_goods` VALUES (1487743593950072833,0,0,'护垫','','','包','',4.54,11.00,46,170,'SALE','money','2022-04-27 21:10:15','money','2022-04-30 13:01:17',NULL),(1488070069522055170,0,0,'夜用','','','','',3.47,9.00,50,392,'SALE','money','2022-04-29 21:20:08','money','2022-04-30 13:01:17',NULL),(1488070478168899586,0,0,'日用','','','件','',3.47,9.00,1,631,'SALE','money','2022-04-28 16:55:14','money','2022-04-30 19:48:55',NULL),(1488071281298423809,0,0,'加长360','','','','',5.13,12.50,47,223,'SALE','money','2022-04-29 21:19:33','money','2022-04-30 13:01:17',NULL),(1488072124630351874,0,0,'臻享迷你巾','','','','',4.72,12.00,25,72,'SALE','money','2022-04-26 17:04:26','money','2022-04-30 13:01:18',NULL),(1488073045384937473,0,0,'洋甘菊眼罩','','','','',17.00,29.00,0,4,'SOLD_OUT','money','2022-03-10 13:32:06','money','2022-04-30 13:01:18',NULL),(1488079493057789954,0,0,'绿茶眼罩','','','','',17.00,29.00,0,5,'SOLD_OUT','money','2022-03-10 13:32:06','money','2022-04-30 13:01:18',NULL),(1488081253579145217,0,0,'卸妆湿巾[80p]','','','','',8.00,16.00,1,7,'SALE','money','2022-04-28 14:46:44','money','2022-04-30 13:01:18',NULL),(1488082288095838209,0,0,'女士士私护贴','','','','',26.00,49.00,1,4,'SALE','money','2022-03-03 13:16:58','money','2022-04-30 13:01:18',NULL),(1488083019636981761,0,0,'爱生活水凝芦荟胶','','','','',11.10,19.00,4,6,'SALE','money','2022-04-28 14:51:06','money','2022-04-30 13:01:18',NULL),(1488083512274763777,0,0,'洁净控油洗发水','','','','',18.00,40.00,1,0,'SALE','money','2022-01-31 20:41:21','money','2022-04-30 13:01:18',NULL),(1488084268776210433,0,0,'抑菌内衣洗衣液','','','','',14.93,35.00,0,2,'SOLD_OUT','money','2022-04-26 17:04:26','money','2022-04-30 13:01:18',NULL),(1488354540397793281,0,0,'超凡洁净洁厕','','','','',5.10,12.00,6,13,'SALE','money','2022-04-28 14:53:36','money','2022-04-30 13:01:18',NULL),(1488355061607174146,0,0,'重油污净','','','包','',7.20,18.00,1,66,'SALE','money','2022-04-29 22:05:31','money','2022-04-30 19:48:55',NULL),(1488355668917227522,0,0,'天然海藻牙膏','','','','',5.60,10.00,3,34,'SALE','money','2022-04-19 13:15:19','money','2022-04-30 13:01:19',NULL),(1488356238075891714,0,0,'绿茶牙膏','','','','',6.90,11.00,10,7,'SALE','money','2022-04-19 13:11:53','money','2022-04-30 13:01:19',NULL),(1488358086757322754,0,0,'薄荷牙膏','','','','',7.00,11.00,7,2,'SALE','money','2022-03-19 13:53:52','money','2022-04-30 13:01:19',NULL),(1488359120493875201,0,0,'清盈去屑洗发水','','','','',17.01,29.00,1,35,'SALE','money','2022-04-28 14:53:36','money','2022-04-30 13:01:19',NULL),(1488359596320886786,0,0,'滋养柔顺洗发水','','','','',17.01,29.00,7,27,'SALE','money','2022-04-29 08:39:31','money','2022-04-30 13:01:19',NULL),(1488361012577964034,0,0,'清凉爽肤沐浴露','','','','',15.52,35.00,1,14,'SALE','money','2022-04-28 14:53:36','money','2022-04-30 13:01:19',NULL),(1488361550245793794,0,0,'多效2公斤','','','','',15.12,34.00,-2,49,'SOLD_OUT','money','2022-04-27 15:11:21','money','2022-04-30 13:01:20',NULL),(1488362032292958209,0,0,'清盈滋养沐浴露','','','','',13.97,29.00,10,32,'SALE','money','2022-04-29 08:39:31','money','2022-04-30 13:01:20',NULL),(1488363280383610882,0,0,'柔顺剂薰衣草','','','','',11.70,18.00,2,1,'SALE','money','2022-03-19 15:01:24','money','2022-04-30 13:01:20',NULL),(1488364342100365314,0,0,'固体管道通','','','','',7.98,14.00,2,8,'SALE','money','2022-03-15 18:54:08','money','2022-04-30 13:01:20',NULL),(1488365342139879425,0,0,'喷头','','','','',0.64,2.00,42,6,'SALE','money','2022-04-28 18:26:21','money','2022-04-30 13:01:20',NULL),(1488376486145560578,0,0,'亲轻棉日用','','','','',7.00,17.00,27,46,'SALE','money','2022-04-27 15:10:25','money','2022-04-30 13:01:20',NULL),(1488377381126148098,0,0,'亲轻棉迷你巾','','','','',6.62,16.00,14,21,'SALE','money','2022-04-16 17:46:40','money','2022-04-30 13:01:20',NULL),(1488377708722262017,0,0,'亲轻棉夜用','','','','',7.00,17.00,28,14,'SALE','money','2022-04-27 15:11:21','money','2022-04-30 13:01:21',NULL),(1488378311108202497,0,0,'yy夜用','','','','',5.88,14.00,5,15,'SALE','money','2022-03-25 18:10:38','money','2022-04-30 13:01:21',NULL),(1488378678369849345,0,0,'yy日用','','','','',5.88,14.00,7,26,'SALE','money','2022-03-25 18:10:38','money','2022-04-30 13:01:21',NULL),(1488379232663900162,0,0,'yy加长','','','','',5.88,14.00,8,36,'SALE','money','2022-04-26 17:04:26','money','2022-04-30 13:01:21',NULL),(1488379776753209345,0,0,'爱生活安心裤','','','','',5.40,12.00,12,27,'SALE','money','2022-04-27 21:12:06','money','2022-04-30 13:01:21',NULL),(1701776231627407360,1701775713710555136,0,'软','','','条','',11.00,12.00,1,0,'SALE','money','2023-09-13 09:54:06','money','2023-09-13 09:54:06',NULL),(1702191951548948480,1701775713710555136,1701878846134636544,'硬和谐','','','条','',360.00,400.00,5,0,'SALE','money','2023-09-14 13:26:01','money','2023-09-14 13:26:01','10'),(1702239911095771136,1701775713710555136,1701878846134636544,'硬和谐','','','包','',36.00,40.00,80,0,'SOLD_OUT','money','2023-09-14 13:26:01','money','2023-09-14 13:26:01','10');
/*!40000 ALTER TABLE `gms_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gms_goods_category`
--

DROP TABLE IF EXISTS `gms_goods_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gms_goods_category` (
  `id` bigint unsigned NOT NULL,
  `pid` bigint unsigned NOT NULL COMMENT '父分类id',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '分类图标',
  `name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `goods_count` int NOT NULL DEFAULT '0' COMMENT '商品数量',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gms_goods_category`
--

LOCK TABLES `gms_goods_category` WRITE;
/*!40000 ALTER TABLE `gms_goods_category` DISABLE KEYS */;
INSERT INTO `gms_goods_category` VALUES (1701878846134636544,0,'','呵呵',1,'money','2023-09-13 16:41:51','money','2023-09-13 16:41:51');
/*!40000 ALTER TABLE `gms_goods_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_expenditure`
--

DROP TABLE IF EXISTS `oms_expenditure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_expenditure` (
  `id` bigint NOT NULL,
  `reason` varchar(320) NOT NULL COMMENT '支出原因',
  `money` bigint NOT NULL COMMENT '支出金额',
  `expenditure_time` datetime NOT NULL COMMENT '支出时间',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) DEFAULT NULL COMMENT '修改者',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `notes` varchar(320) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支出表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_expenditure`
--

LOCK TABLES `oms_expenditure` WRITE;
/*!40000 ALTER TABLE `oms_expenditure` DISABLE KEYS */;
INSERT INTO `oms_expenditure` VALUES (1,'找烟',100,'2023-09-16 16:07:10','money','2023-09-15 17:07:24','money','2023-09-15 17:07:32','此乃备注'),(2,'新君',300,'2023-09-15 17:15:43','money','2023-09-15 17:15:48','money','2023-09-15 17:15:57',NULL);
/*!40000 ALTER TABLE `oms_expenditure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_order`
--

DROP TABLE IF EXISTS `oms_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_order` (
  `id` bigint unsigned NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `contact` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '联系方式',
  `cost_amount` decimal(10,2) unsigned NOT NULL COMMENT '总成本',
  `total_amount` decimal(10,2) unsigned NOT NULL COMMENT '总价',
  `pay_amount` decimal(10,2) unsigned NOT NULL COMMENT '实付款',
  `final_sales_amount` decimal(10,2) unsigned NOT NULL COMMENT '最终销售金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备注',
  `payment_time` datetime NOT NULL COMMENT '支付时间',
  `completion_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_order`
--

LOCK TABLES `oms_order` WRITE;
/*!40000 ALTER TABLE `oms_order` DISABLE KEYS */;
INSERT INTO `oms_order` VALUES (1701524747019010048,'202309121714466','RETURN','',40.40,85.00,85.00,0.00,'','2023-09-12 17:14:46',NULL,'money','2023-09-12 17:14:47','money','2023-09-12 17:14:47'),(1701869394908102656,'202309131604162','PAID','',3.47,9.00,9.00,9.00,'','2023-09-13 16:04:17',NULL,'money','2023-09-13 16:04:18','money','2023-09-13 16:04:18');
/*!40000 ALTER TABLE `oms_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_order_detail`
--

DROP TABLE IF EXISTS `oms_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_order_detail` (
  `id` bigint NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `goods_id` bigint NOT NULL COMMENT '商品id',
  `goods_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `goods_price` decimal(10,2) NOT NULL COMMENT '实际单价',
  `quantity` int unsigned NOT NULL COMMENT '数量',
  `sale_price` decimal(10,2) NOT NULL COMMENT '售价',
  `purchase_price` decimal(10,2) NOT NULL COMMENT '进价',
  `return_quantity` int NOT NULL DEFAULT '0' COMMENT '退货数量',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_order_detail`
--

LOCK TABLES `oms_order_detail` WRITE;
/*!40000 ALTER TABLE `oms_order_detail` DISABLE KEYS */;
INSERT INTO `oms_order_detail` VALUES (1701524747069341696,'202309121714466','RETURN',1488355061607174146,'重油污净',18.00,2,18.00,7.20,2,'money','2023-09-12 17:14:47','money','2023-09-12 17:14:47'),(1701524747077730304,'202309121714466','RETURN',1488082288095838209,'女士士私护贴',49.00,1,49.00,26.00,1,'money','2023-09-12 17:14:47','money','2023-09-12 17:14:47'),(1701869394958434304,'202309131604162','PAID',1488070478168899586,'日用',9.00,1,9.00,3.47,0,'money','2023-09-13 16:04:18','money','2023-09-13 16:04:18');
/*!40000 ALTER TABLE `oms_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_order_log`
--

DROP TABLE IF EXISTS `oms_order_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_order_log` (
  `id` bigint unsigned NOT NULL,
  `order_id` bigint NOT NULL COMMENT '订单id',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '描述',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单操作日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_order_log`
--

LOCK TABLES `oms_order_log` WRITE;
/*!40000 ALTER TABLE `oms_order_log` DISABLE KEYS */;
INSERT INTO `oms_order_log` VALUES (1656309547227369473,1656309547093151745,'完成订单','money','2023-05-10 22:45:43','money','2023-05-10 22:45:43'),(1701524747195170816,1701524747019010048,'完成订单','money','2023-09-12 17:14:47','money','2023-09-12 17:14:47'),(1701799861740584960,1701524747019010048,'<span style=\"color:red\">退单</span>','money','2023-09-13 11:28:00','money','2023-09-13 11:28:00'),(1701869395029737472,1701869394908102656,'完成订单','money','2023-09-13 16:04:18','money','2023-09-13 16:04:18');
/*!40000 ALTER TABLE `oms_order_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict`
--

DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '字典描述',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='字典表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict`
--

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
INSERT INTO `sys_dict` VALUES (1,'switch','开关','','2022-03-05 16:22:32','','2022-03-05 16:22:34'),(2,'permissionType','权限类型','','2022-03-06 12:02:55','','2022-03-06 12:02:58'),(3,'yesOrNo','是否','','2022-03-05 16:22:32','','2022-03-05 16:22:34'),(1629745205996666882,'goodsStatus','商品状态','money','2023-02-26 15:28:31','money','2023-02-26 15:28:31'),(1629751225758216194,'orderStatus','订单状态','money','2023-02-26 15:52:26','money','2023-02-26 15:52:32');
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_detail`
--

DROP TABLE IF EXISTS `sys_dict_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_detail` (
  `id` bigint unsigned NOT NULL,
  `dict` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名',
  `label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典标签',
  `value` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典值',
  `sort` int NOT NULL DEFAULT '999' COMMENT '排序',
  `hidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT '隐藏',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='字典详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_detail`
--

LOCK TABLES `sys_dict_detail` WRITE;
/*!40000 ALTER TABLE `sys_dict_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_dict_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_permission` (
  `id` bigint unsigned NOT NULL,
  `permission_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `permission_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源类型',
  `parent_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT '父编码',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `permission` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限标识',
  `router_path` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '路由地址',
  `iframe` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否外链菜单',
  `hidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏',
  `component_name` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组件名称',
  `component_path` varchar(125) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组件路径',
  `sub_count` int NOT NULL DEFAULT '0' COMMENT '子节点数',
  `sort` int NOT NULL DEFAULT '999' COMMENT '排序',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='资源权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_permission`
--

LOCK TABLES `sys_permission` WRITE;
/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;
INSERT INTO `sys_permission` VALUES (1501921151197130754,'系统管理','DIR',0,'system','','system',0,0,'','',5,1,'admin','2022-03-10 22:01:21','admin','2022-03-10 23:06:45'),(1502278787507806210,'用户管理','MENU',1501921151197130754,'peoples','user:list','user',0,0,'User','system/user/index',3,1,'admin','2022-03-11 21:42:29','admin','2022-03-11 21:42:29'),(1502863016289398785,'角色管理','MENU',1501921151197130754,'people','role:list','role',0,0,'Role','system/role/index',2,2,'admin','2022-03-13 12:24:00','admin','2022-03-13 12:24:00'),(1502863270971731970,'权限管理','MENU',1501921151197130754,'permission','permission:list','permission',0,0,'Permission','system/permission/index',3,3,'admin','2022-03-13 12:25:00','admin','2022-03-13 12:25:00'),(1503736683986800642,'新增用户','BUTTON',1502278787507806210,'','user:add','',0,0,'','',0,1,'admin','2022-03-15 22:15:38','admin','2022-03-15 22:15:38'),(1503738104236822529,'修改用户','BUTTON',1502278787507806210,'','user:edit','',0,0,'','',0,2,'admin','2022-03-15 22:21:17','admin','2022-03-15 22:21:17'),(1503738191579009025,'删除用户','BUTTON',1502278787507806210,'','user:del','',0,0,'','',0,3,'admin','2022-03-15 22:21:38','admin','2022-03-15 22:21:38'),(1503753702563991553,'新增角色','BUTTON',1502863016289398785,'','role:add','',0,0,'','',0,1,'admin','2022-03-15 23:23:16','admin','2022-03-15 23:23:16'),(1503753930130149377,'修改角色','BUTTON',1502863016289398785,'','role:edit','',0,0,'','',0,2,'admin','2022-03-15 23:24:10','admin','2022-03-15 23:24:10'),(1503754013445804034,'删除角色','BUTTON',1502863016289398785,'','role:del','',0,0,'','',0,3,'admin','2022-03-15 23:24:30','admin','2022-03-15 23:24:30'),(1503754297878335489,'新增权限','BUTTON',1502863270971731970,'','permission:add','',0,0,'','',0,1,'admin','2022-03-15 23:25:38','admin','2022-03-15 23:25:38'),(1503754393558798337,'修改权限','BUTTON',1502863270971731970,'','permission:edit','',0,0,'','',0,2,'admin','2022-03-15 23:26:00','admin','2022-03-15 23:26:00'),(1503754468678782978,'删除权限','BUTTON',1502863270971731970,'','permission:del','',0,0,'','',0,3,'admin','2022-03-15 23:26:18','admin','2022-03-15 23:26:18'),(1507371326556450818,'字典管理','MENU',1501921151197130754,'dictionary','dict:list','dict',0,0,'Dict','system/dict/index',3,4,'money','2022-03-25 22:58:25','money','2022-03-25 22:58:25'),(1507371669973479425,'新增字典','BUTTON',1507371326556450818,'','dict:add','',0,0,'','',0,1,'money','2022-03-25 22:59:46','money','2022-03-25 22:59:46'),(1507371725170520065,'修改字典','BUTTON',1507371326556450818,'','dict:edit','',0,0,'','',0,2,'money','2022-03-25 23:00:00','money','2022-03-25 23:00:00'),(1507371776840151041,'删除字典','BUTTON',1507371326556450818,'','dict:del','',0,0,'','',0,3,'money','2022-03-25 23:00:12','money','2022-03-25 23:00:12'),(1629707272975482881,'商品管理','DIR',0,'gms','','gms',0,0,'','',2,4,'money','2023-02-26 12:57:47','money','2023-02-26 12:57:47'),(1629707539397672961,'品牌','MENU',1629707272975482881,'gms-brand','gmsBrand:list','brand',0,0,'Brand','gms/brand/index',3,1,'money','2023-02-26 12:58:51','money','2023-02-26 12:58:51'),(1629707621962547201,'新增','BUTTON',1629707539397672961,'','gmsBrand:add','',0,0,'','',0,1,'money','2023-02-26 12:59:10','money','2023-02-26 12:59:10'),(1629707668649345025,'修改','BUTTON',1629707539397672961,'','gmsBrand:edit','',0,0,'','',0,2,'money','2023-02-26 12:59:21','money','2023-02-26 12:59:21'),(1629707726832730113,'删除','BUTTON',1629707539397672961,'','gmsBrand:del','',0,0,'','',0,3,'money','2023-02-26 12:59:35','money','2023-02-26 12:59:35'),(1629731562059952129,'商品','MENU',1629707272975482881,'gms-goods','gmsGoods:list','goods',0,0,'Goods','gms/goods/index',1,2,'money','2023-02-26 14:34:18','money','2023-02-26 14:34:18'),(1629731649087565825,'新增','BUTTON',1629731562059952129,'','gmsGoods:add','',0,0,'','',0,1,'money','2023-02-26 14:34:39','money','2023-02-26 14:34:39'),(1629731729861472258,'修改','BUTTON',1629731562059952129,'','gmsGoods:edit','',0,0,'','',0,2,'money','2023-02-26 14:34:58','money','2023-02-26 14:34:58'),(1629731810069147650,'删除','BUTTON',1629731562059952129,'','gmsGoods:del','',0,0,'','',0,3,'money','2023-02-26 14:35:17','money','2023-02-26 14:35:17'),(1629732061718999041,'订单管理','DIR',0,'oms','','oms',0,0,'','',2,5,'money','2023-02-26 14:36:17','money','2023-02-26 14:36:17'),(1629732239595237378,'订单','MENU',1629732061718999041,'oms-order','omsOrder:list','order',0,0,'Order','oms/order/index',1,1,'money','2023-02-26 14:37:00','money','2023-02-26 14:37:00'),(1629732461629108226,'修改','BUTTON',1629732239595237378,'','omsOrder:edit','',0,0,'','',0,1,'money','2023-02-26 14:37:52','money','2023-02-26 14:37:52'),(1629767886267736065,'日常','DIR',0,'calendar','','pos',0,0,'','',1,2,'money','2023-02-26 16:58:38','money','2023-02-26 16:58:38'),(1629768001384603649,'收银台','MENU',1629767886267736065,'pos','pos:cashier','pos',0,0,'Pos','pos/index',0,1,'money','2023-02-26 16:59:06','money','2023-02-26 16:59:06'),(1634214613527801857,'订单详情','MENU',1629732061718999041,'oms','omsOrder:detail','order/detail/:id',0,1,'OrderDetail','oms/order/detail',0,2,'money','2023-03-10 23:28:21','money','2023-03-10 23:28:21'),(1702603000941023232,'支出管理','DIR',0,'skill','','ex',0,0,'','',2,1,'money','2023-09-15 16:39:23','money','2023-09-15 16:39:23'),(1702603937231310848,'支出','MENU',1702603000941023232,'pos','expenditure:list','expenditure',0,0,'expenditure','expenditure/index',0,1,'money','2023-09-15 16:43:06','money','2023-09-15 16:43:06');
/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint unsigned NOT NULL,
  `role_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
  `role_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `level` int NOT NULL COMMENT '角色级别',
  `description` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色描述',
  `count` bigint NOT NULL DEFAULT '0' COMMENT '角色人数',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可用状态：0-禁用；1-启用',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'SUPER_ADMIN','超级管理员',0,'拥有全部权限的人',1,1,'','2021-09-07 22:49:27','admin','2022-03-06 11:40:47'),(1502845638751055873,'ADMIN','管理员',1,'管理员',1,1,'admin','2022-03-13 11:14:56','admin','2022-03-13 11:14:56'),(1502845786646409218,'GUEST','游客',99,'只能查不能改',1,1,'admin','2022-03-13 11:15:32','admin','2022-03-13 11:15:42');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_permission_relation`
--

DROP TABLE IF EXISTS `sys_role_permission_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission_relation` (
  `id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL COMMENT '资源权限id',
  `role_id` bigint unsigned NOT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='角色资源权限关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_permission_relation`
--

LOCK TABLES `sys_role_permission_relation` WRITE;
/*!40000 ALTER TABLE `sys_role_permission_relation` DISABLE KEYS */;
INSERT INTO `sys_role_permission_relation` VALUES (1507375843830263810,1501921151197130754,1502845638751055873),(1507375843830263811,1502278787507806210,1502845638751055873),(1507375843830263812,1503753930130149377,1502845638751055873),(1507375843830263813,1503754468678782978,1502845638751055873),(1507375843830263814,1507371669973479425,1502845638751055873),(1507375843830263815,1503738104236822529,1502845638751055873),(1507375843830263816,1502863016289398785,1502845638751055873),(1507375843830263817,1507371776840151041,1502845638751055873),(1507375843830263818,1503754297878335489,1502845638751055873),(1507375843830263819,1503736683986800642,1502845638751055873),(1507375843830263820,1503754013445804034,1502845638751055873),(1507375843830263821,1507371725170520065,1502845638751055873),(1507375843830263822,1507371326556450818,1502845638751055873),(1507375843830263823,1503738191579009025,1502845638751055873),(1507375843830263824,1502863270971731970,1502845638751055873),(1507375843830263825,1503753702563991553,1502845638751055873),(1507375843830263826,1503754393558798337,1502845638751055873),(1507375871487504386,1501921151197130754,1502845786646409218),(1507375871487504387,1502278787507806210,1502845786646409218),(1507375871487504388,1507371326556450818,1502845786646409218),(1507375871487504389,1502863270971731970,1502845786646409218),(1507375871487504390,1502863016289398785,1502845786646409218);
/*!40000 ALTER TABLE `sys_role_permission_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tenant`
--

DROP TABLE IF EXISTS `sys_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant` (
  `id` bigint unsigned NOT NULL,
  `tenant_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租户code',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'https://wpimg.wallstcn.com/69a1c46c-eb1c-4b46-8bd4-e9e686ef5251.png' COMMENT 'logo',
  `ico` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'ico',
  `domain` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '域名',
  `tenant_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租户名称',
  `tenant_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '租户描述',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tenant`
--

LOCK TABLES `sys_tenant` WRITE;
/*!40000 ALTER TABLE `sys_tenant` DISABLE KEYS */;
INSERT INTO `sys_tenant` VALUES (0,'M','https://wpimg.wallstcn.com/69a1c46c-eb1c-4b46-8bd4-e9e686ef5251.png','','www.money.com','麦尼科技','主租户',0,'','2022-05-29 10:15:22','','2022-03-26 14:06:28');
/*!40000 ALTER TABLE `sys_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint unsigned NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif' COMMENT '头像',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可用状态：0-禁用；1-启用',
  `init_login` tinyint(1) NOT NULL DEFAULT '1' COMMENT '初次登录：0-不是；1-是',
  `last_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后登录时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'money','$2a$10$W6oaOSARIA3DsZy1DkdfUuqI3L7a885Ci7AYvpQK.9NGbeVhcZihi','money','https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif','18120800000','money@qq.com','俺是一个超级管理员！',1,1,'2023-09-15 15:51:54','','2022-03-03 23:12:57','money','2022-03-25 23:41:26'),(1502254138862391297,'admin','$2a$10$630Mdca6BcyUJpKC2LNT7eT93.k9pmpcQoes4qm/j2o.pnb725zE6','admin','https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif','18120803972','admin@qq.com','',1,1,'2022-09-03 12:07:07','admin','2022-03-11 20:04:32','money','2022-03-25 23:41:06'),(1504612500111388673,'guest','$2a$10$Nj/4Tn.cj2SEdoIUqMz7FOczatNV/AltEu07ieTpAO.5hEGV7lZqC','guest','https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif','18120800002','guest@qq.com','',1,1,'2022-09-03 12:07:24','001','2022-03-18 08:15:49','money','2022-03-25 23:41:00');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role_relation`
--

DROP TABLE IF EXISTS `sys_user_role_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role_relation` (
  `id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL COMMENT '用户id',
  `role_id` bigint unsigned NOT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role_relation`
--

LOCK TABLES `sys_user_role_relation` WRITE;
/*!40000 ALTER TABLE `sys_user_role_relation` DISABLE KEYS */;
INSERT INTO `sys_user_role_relation` VALUES (1507382045234470913,1504612500111388673,1502845786646409218),(1507382069087477762,1502254138862391297,1502845638751055873),(1507382155225899009,1,1);
/*!40000 ALTER TABLE `sys_user_role_relation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-15 17:24:53
