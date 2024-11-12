/* Optimización de consultas a través de índices */

USE indices_db;

-- Crear tabla de ventas con índices optimizados
CREATE TABLE Sales (
    sale_id INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,  -- Clave primaria no agrupada para optimizar índices
    sale_date DATE,
    total_amount DECIMAL(10, 2)
);

-- Inserción masiva de 1 millón de registros de ventas
DECLARE @EndDate DATETIME = '2024-12-31';
DECLARE @StartDate DATETIME = DATEADD(DAY, -365, @EndDate);
DECLARE @RecordCount INT = 1000000;

-- Tabla temporal para generación masiva de datos
CREATE TABLE #TempSales (sale_date DATE, total_amount DECIMAL(10, 2));

-- Bucle para generar datos aleatorios
DECLARE @i INT = 1;
WHILE @i <= @RecordCount  
BEGIN
    DECLARE @RandomDays INT = FLOOR(RAND() * DATEDIFF(DAY, @StartDate, @EndDate));
    DECLARE @SaleDate DATE = DATEADD(DAY, @RandomDays, @StartDate);
    DECLARE @TotalAmount DECIMAL(10, 2) = ROUND(RAND() * 20000, 2);
    
    INSERT INTO #TempSales (sale_date, total_amount) VALUES (@SaleDate, @TotalAmount);
    SET @i = @i + 1;
END;

-- Insertar datos de la tabla temporal en la tabla principal de ventas
INSERT INTO Sales (sale_date, total_amount)
SELECT sale_date, total_amount FROM #TempSales;

DROP TABLE #TempSales;

-- Índices y consulta optimizada
-- 1. Crear índice agrupado en sale_date para optimizar consultas por rango de fechas
CREATE CLUSTERED INDEX IDX_Sales_SaleDate ON Sales(sale_date);

-- 2. Habilitar estadísticas en la consulta para medir el impacto del índice
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT sale_id, sale_date, total_amount
FROM Sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY sale_date ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Eliminar el índice agrupado y crear un índice no agrupado con columnas incluidas
DROP INDEX IDX_Sales_SaleDate ON Sales;

CREATE NONCLUSTERED INDEX IDX_Sales_SaleDate_Included
ON Sales(sale_date)
INCLUDE (sale_id, total_amount);

-- Ejecutar nuevamente la consulta optimizada para evaluar el impacto del índice
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT sale_id, sale_date, total_amount
FROM Sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY sale_date ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
