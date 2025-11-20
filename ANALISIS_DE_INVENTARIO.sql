-- SCRIPT COMPLETO DE INVENTARIO
-- 1. Gestionar base de datos
DROP DATABASE IF EXISTS mi_inventario_project;
CREATE DATABASE mi_inventario_project;
USE mi_inventario_project;

-- 2. Crear tabla
CREATE TABLE inventario (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    precio DECIMAL(10,2),
    stock_actual INT,
    stock_minimo INT
);

-- 3. Insertar datos de prueba
INSERT INTO inventario (id, nombre, precio, stock_actual, stock_minimo) VALUES
(11,'2P ANI T36',62000,0,1),
(12,'2P ANI T38',62000,14,1),
(13,'2P ANI T40',62000,14,1),
(14,'2P ANI T42',62000,15,1),
(15,'2P ANI T44',62000,4,1);

-- 4. Verificaciones finales
SELECT '=== BASE DE DATOS CREADA EXITOSAMENTE ===' as mensaje;
SHOW TABLES;
SELECT COUNT(*) as total_productos FROM inventario;
SELECT * FROM inventario;
##################################################################################
-- BLOQUE 2: Agregar más productos (ids 16-50)
INSERT INTO inventario (id, nombre, precio, stock_actual, stock_minimo) VALUES
(16,'2P ANI T46',62000,0,1),
(17,'2P Antifluido Azul TL',50000,10,1),
(18,'2P Antifluido Azul TM',50000,0,1),
(19,'2P Antifluido Azul TS',50000,0,1),
(20,'2P Antifluido Azul TXL',50000,6,1),
(21,'2P Antifluido Azul TXS',50000,0,1),
(22,'2P Antifluido Azul TXXL',50000,0,1),
(23,'2P Antifluido Blanco TL',50000,0,1),
(24,'2P Antifluido Blanco TM',50000,0,1),
(25,'2P Antifluido Blanco TS',50000,0,1),
(26,'2P Antifluido Blanco TXL',50000,0,1),
(27,'2P Antifluido Blanco TXS',50000,0,1),
(28,'2P Antifluido Blanco TXXL',50000,0,1),
(29,'2P IDU T36',56000,15,1),
(30,'2P IDU T38',56000,45,1),
(31,'2P IDU T40',56000,43,1),
(32,'2P IDU T42',56000,35,1),
(33,'2P IDU T44',56000,11,1),
(34,'2P IDU T46',56000,0,1),
(35,'2P T 36 AO',48000,0,1),
(36,'2P T 36 Gris',48000,0,1),
(37,'2P T 36 kaki',48000,0,1),
(38,'2P T 36 Negro',48000,0,1),
(39,'2P T 38 AO',48000,0,1),
(40,'2P T 38 Gris',48000,1,1),
(41,'2P T 38 kaki',48000,0,1),
(42,'2P T 38 Negro',48000,0,1),
(43,'2P T 40 AO',48000,0,1),
(44,'2P T 40 Gris',48000,0,1),
(45,'2P T 40 kaki',48000,0,1),
(46,'2P T 40 Negro',48000,0,1),
(47,'2P T 42 AO',48000,2,1),
(48,'2P T 42 Gris',48000,0,1),
(49,'2P T 42 kaki',48000,0,1),
(50,'2P T 42 Negro',48000,0,1);

SELECT 'Bloque 2 insertado' as mensaje;
SELECT COUNT(*) as total_registros FROM inventario;
#########################################################################################
-- CONSULTA 1: Resumen general del inventario
SELECT 
    COUNT(*) as total_productos,
    SUM(stock_actual) as unidades_totales,
    AVG(precio) as precio_promedio,
    SUM(stock_actual * precio) as valor_total_inventario
FROM inventario;
##################################################################################################
-- CONSULTA 2: Productos que necesitan reabastecimiento URGENTE
SELECT 
    id,
    nombre,
    stock_actual,
    stock_minimo,
    precio
FROM inventario 
WHERE stock_actual < stock_minimo
ORDER BY stock_actual ASC;
####################################################################################################
-- CONSULTA 3: Productos más valiosos en stock
SELECT 
    nombre,
    stock_actual,
    precio,
    (stock_actual * precio) as valor_total
FROM inventario 
WHERE stock_actual > 0
ORDER BY valor_total DESC
LIMIT 10;
##############################################################################################
-- CONSULTA 4: Análisis por categorías de productos
SELECT 
    CASE 
        WHEN nombre LIKE '%2P%' THEN 'Overoles'
        WHEN nombre LIKE '%Bata%' THEN 'Batas'
        WHEN nombre LIKE '%Guante%' THEN 'Guantes'
        WHEN nombre LIKE '%Casco%' THEN 'Cascos'
        WHEN nombre LIKE '%Chaleco%' THEN 'Chalecos'
        WHEN nombre LIKE '%Pantalon%' THEN 'Pantalones'
        ELSE 'Otros'
    END as categoria,
    COUNT(*) as cantidad_productos,
    SUM(stock_actual) as stock_total,
    SUM(stock_actual * precio) as valor_inventario
FROM inventario
GROUP BY categoria
ORDER BY valor_inventario DESC;
##############################################################################################
-- CONSULTA 5: Porcentaje de productos con stock bajo
SELECT 
    ROUND(
        (COUNT(CASE WHEN stock_actual < stock_minimo THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) as porcentaje_stock_bajo,
    COUNT(CASE WHEN stock_actual < stock_minimo THEN 1 END) as productos_stock_bajo,
    COUNT(*) as productos_totales
FROM inventario;
####################################################################################################
-- CONSULTA 6: Top 10 productos más caros
SELECT 
    nombre,
    precio,
    stock_actual
FROM inventario 
ORDER BY precio DESC 
LIMIT 10;
##############################################################################################
-- CONSULTA 7: Productos sin stock (stock = 0)
SELECT 
    COUNT(*) as productos_sin_stock,
    SUM(precio) as valor_perdido_potencial
FROM inventario 
WHERE stock_actual = 0;
######################################################################################
-- ANÁLISIS 1: Severidad del stock bajo
SELECT 
    CASE 
        WHEN stock_actual = 0 THEN 'Sin stock (0 unidades)'
        WHEN stock_actual < stock_minimo THEN 'Stock bajo crítico'
        ELSE 'Stock suficiente'
    END as estado_stock,
    COUNT(*) as cantidad_productos,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM inventario)), 2) as porcentaje
FROM inventario
GROUP BY estado_stock
ORDER BY cantidad_productos DESC;
#################################################################################
-- ANÁLISIS 2: Valor del inventario por estado de stock
SELECT 
    CASE 
        WHEN stock_actual = 0 THEN 'Sin stock'
        WHEN stock_actual < stock_minimo THEN 'Stock bajo'
        ELSE 'Stock suficiente'
    END as estado,
    COUNT(*) as productos,
    SUM(stock_actual * precio) as valor_inventario,
    ROUND(AVG(precio), 2) as precio_promedio
FROM inventario
GROUP BY estado;
#################################################################################################
-- BLOQUE 3: Más productos (ids 51-100)
INSERT INTO inventario (id, nombre, precio, stock_actual, stock_minimo) VALUES
(51,'2P T 44 AO',48000,0,1),
(52,'2P T 44 Gris',48000,0,1),
(53,'2P T 44 kaki',48000,0,1),
(54,'2P T 44 Negro',48000,1,1),
(55,'2P T 46 AO',48000,2,1),
(56,'2P T 46 Gris',48000,0,1),
(57,'2P T 46 kaki',48000,1,1),
(58,'2P T 46 Negro',48000,0,1),
(59,'Alerones Azul',13000,20,1),
(60,'Alerones Kaki',13000,10,1),
(61,'Barbuquejos 2 puntos',4500,9,1),
(62,'Barbuquejos 3 puntos',4500,8,1),
(63,'Bata 3/4 AO S',32000,1,1),
(64,'Bata 3/4 AO TL',32000,13,1),
(65,'Bata 3/4 AO TM',32000,12,1),
(66,'Bata 3/4 AO TXL',32000,5,1),
(67,'Bata 3/4 AO TXS',32000,0,1),
(68,'Bata 3/4 AO TXXL',32000,0,1),
(69,'Bata 3/4 Blanco T L',32000,3,1),
(70,'Bata 3/4 Blanco T M',32000,0,1),
(71,'Bata 3/4 Blanco T S',32000,0,1),
(72,'Bata 3/4 Blanco T XL',32000,1,1),
(73,'Bata 3/4 Blanco T XS',32000,0,1),
(74,'Bata 3/4 Blanco T XXL',32000,0,1),
(75,'Bata 3/4 Kaki T L',32000,0,1),
(76,'Bata 3/4 Kaki T M',32000,0,1),
(77,'Bata 3/4 Kaki T S',32000,0,1),
(78,'Bata 3/4 Kaki T XL',32000,0,1),
(79,'Bata 3/4 Kaki T XS',32000,0,1),
(80,'Bata 3/4 Kaki T XXL',32000,0,1),
(81,'Bata 3/4 Negro T L',32000,0,1),
(82,'Bata 3/4 Negro T M',32000,0,1),
(83,'Bata 3/4 Negro T S',32000,0,1),
(84,'Bata 3/4 Negro T XL',32000,1,1),
(85,'Bata 3/4 Negro T XS',32000,0,1),
(86,'Bata 3/4 Negro T XXL',32000,0,1),
(87,'Botas No 34',52000,3,1),
(88,'Botas No 35',52000,3,1),
(89,'Botas No 36',52000,3,1),
(90,'Botas No 37',52000,7,1),
(91,'Botas No 38',52000,10,1),
(92,'Botas No 39',52000,9,1),
(93,'Botas No 40',52000,5,1),
(94,'Botas No 41',52000,4,1),
(95,'Botas No 42',52000,5,1),
(96,'Botas No 43',52000,5,1),
(97,'Botas No 44',52000,2,1),
(98,'Botas No 45',52000,2,1),
(99,'Brazaletes',2500,0,1),
(100,'Camisa drill  AO TL',30000,0,1);

SELECT 'Bloque 3 insertado - 50 nuevos productos' as mensaje;
SELECT COUNT(*) as total_registros FROM inventario;
##################################################################################
-- RESUMEN ACTUALIZADO
SELECT 
    COUNT(*) as total_productos,
    SUM(stock_actual) as unidades_totales,
    ROUND(AVG(precio), 2) as precio_promedio,
    SUM(stock_actual * precio) as valor_total_inventario,
    COUNT(CASE WHEN stock_actual < stock_minimo THEN 1 END) as productos_stock_bajo,
    ROUND((COUNT(CASE WHEN stock_actual < stock_minimo THEN 1 END) * 100.0 / COUNT(*)), 2) as porcentaje_stock_bajo
FROM inventario;
########################################################################################################
-- ANALISIS
SELECT 
    'Gestión de Inventarios' as habilidad,
    'SQL para análisis de stock' as herramienta,
    'Identificación de productos críticos' as logro,
    CONCAT(ROUND((COUNT(CASE WHEN stock_actual < stock_minimo THEN 1 END) * 100.0 / COUNT(*)), 1), '% de productos requieren reabastecimiento') as resultado
FROM inventario;
##################################################################################################
-- Análisis por rango de precios
SELECT 
    CASE 
        WHEN precio < 10000 THEN 'Económico (<10k)'
        WHEN precio BETWEEN 10000 AND 50000 THEN 'Medio (10k-50k)'
        WHEN precio BETWEEN 50000 AND 100000 THEN 'Alto (50k-100k)'
        ELSE 'Muy Alto (>100k)'
    END as rango_precio,
    COUNT(*) as productos,
    SUM(stock_actual) as unidades,
    ROUND(AVG(precio), 2) as precio_promedio_rango
FROM inventario
GROUP BY rango_precio
ORDER BY precio_promedio_rango DESC;
####################################################################################################

