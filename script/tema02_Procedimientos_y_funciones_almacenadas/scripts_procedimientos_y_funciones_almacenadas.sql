Acontinuacion se mostrara como crear distintos procedimientos que utilizaran distintos usuarios con distintos roles, por ejemplo 
el usuario con el rol de Visitante podra insertar consultas en la tabla Message solo mediante la utilizacion de un procedimiento, un 
administrador de prodcuto solo podra insertar productos nuevos a travez de otro procedimiento, y asi.

    
Procedimiento de insercion en tabla Product:
CREATE PROCEDURE insert_product
    @product_name VARCHAR(100),
    @product_description VARCHAR(255),
    @product_price DECIMAL(10, 2),
    @sold_count INT,
    @product_status INT,
    @id_category INT
AS
BEGIN
    -- Inserta un nuevo producto en la tabla Product
    INSERT INTO Product (product_name, product_description, product_price, sold_count, product_status, id_category)
    VALUES (@product_name, @product_description, @product_price, @sold_count, @product_status, @id_category);
    
    -- Mensaje de éxito
    PRINT 'Producto insertado correctamente.';
END;


Procedimiento de actualizacion en la tabla Product:
CREATE PROCEDURE update_product
    @product_id INT,
    @product_name VARCHAR(100),
    @product_description VARCHAR(255),
    @product_price DECIMAL(10, 2),
    @sold_count INT,
    @product_status INT,
    @id_category INT
AS
BEGIN
    -- Actualiza el producto con el ID especificado
    UPDATE Product
    SET 
        product_name = @product_name,
        product_description = @product_description,
        product_price = @product_price,
        sold_count = @sold_count,
        product_status = @product_status,
        id_category = @id_category
    WHERE 
        product_id = @product_id;
    
    -- Mensaje de éxito
    PRINT 'Producto actualizado correctamente.';
END;

Procedimiento para modificar es estado logico de un producto
CREATE PROCEDURE modify_product_status
    @product_id INT
AS
BEGIN
    -- Verifica si el producto existe antes de intentar actualizarlo
    IF EXISTS (SELECT 1 FROM Product WHERE product_id = @product_id)
    BEGIN
        -- Alterna el estado entre 0 (inactivo) y 1 (activo)
        DECLARE @current_status INT;
        
        -- Obtiene el estado actual del producto
        SELECT @current_status = product_status FROM Product WHERE product_id = @product_id;

        -- Cambia el estado
        IF @current_status = 0
        BEGIN
            UPDATE Product
            SET product_status = 1  -- Cambia a activo
            WHERE product_id = @product_id;
            PRINT 'Estado del producto actualizado a activo.';
        END
        ELSE
        BEGIN
            UPDATE Product
            SET product_status = 0  -- Cambia a inactivo
            WHERE product_id = @product_id;
            PRINT 'Estado del producto actualizado a inactivo.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Producto no encontrado.';
    END
END;

Procedimiento de insercion en tabla Message
CREATE PROCEDURE insert_proc
    @product_name VARCHAR(100),
    @product_description VARCHAR(255),
    @product_price DECIMAL(10, 2),
    @sold_count INT,
    @product_status INT,
    @id_category INT
AS
BEGIN
    -- Inserta un nuevo producto en la tabla Product
    INSERT INTO Product (product_name, product_description, product_price, sold_count, product_status, id_category)
    VALUES (@product_name, @product_description, @product_price, @sold_count, @product_status, @id_category);
    
    -- Mensaje de éxito
    PRINT 'Producto insertado correctamente.';
END;


Funcion para encontrar el producto mas vendido en un intervalo de tiempo
CREATE FUNCTION get_top_selling_product
(
    @start_date DATE,
    @end_date DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @top_product_id INT;

    -- Selecciona el id del producto con mayor cantidad de unidades vendidas en el intervalo de fechas
    SELECT TOP 1 @top_product_id = sd.id_product
    FROM Sale s
    JOIN Sale_detail sd ON s.sale_id = sd.id_sale
    WHERE s.sale_date BETWEEN @start_date AND @end_date
    GROUP BY sd.id_product
    ORDER BY SUM(sd.quantity_detail) DESC;

    RETURN @top_product_id;
END;

Funcion para calcular el valor de las ventas entre dos fechas
CREATE FUNCTION calculate_revenue
(
    @start_date DATE,
    @end_date DATE
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @total_revenue FLOAT;

    -- Calcula la ganancia total en el intervalo de fechas
    SELECT @total_revenue = SUM(sd.quantity_detail * sd.price_detail)
    FROM Sale s
    JOIN Sale_detail sd ON s.sale_id = sd.id_sale
    WHERE s.sale_date BETWEEN @start_date AND @end_date;

    -- Retorna el valor total de las ganancias
    RETURN ISNULL(@total_revenue, 0);
END;

Funcion para encontrar el usuario que mas invirtio en la tienda
CREATE FUNCTION find_max_spender()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        s.id_client AS user_id,
        SUM(sd.quantity_detail * sd.price_detail) AS total_spent
    FROM 
        Sale s
    INNER JOIN 
        Sale_detail sd ON s.sale_id = sd.id_sale
    GROUP BY 
        s.id_client
    ORDER BY 
        total_spent DESC
);

--Tarea:
--Procedimientos

--Tabla Producto
INSERT INTO Product (product_name, product_description, product_price, sold_count, product_status, id_category)
VALUES 
('Archivo OBJ de escultura 3D', 'Archivo OBJ para impresión 3D de una escultura', 150.75, 0, 1, 2);

DECLARE @product_id INT = SCOPE_IDENTITY();
INSERT INTO Product_image (imagen_rute, id_product) 
VALUES 
('ruta/a/imagen_archivo_obj_1.jpg', @product_id),
('ruta/a/imagen_archivo_obj_2.jpg', @product_id);

--Utilizacion de el procedimiento insertar producto
EXEC insert_proc
    @product_name = 'Archivo OBJ de modelo arquitectónico',
    @product_description = 'Archivo OBJ para impresión 3D de un modelo arquitectónico detallado',
    @product_price = 200.00,
    @sold_count = 0,
    @product_status = 1,
    @id_category = 2;

DECLARE @product_id INT = SCOPE_IDENTITY();
INSERT INTO Product_image (imagen_rute, id_product) 
VALUES 
('ruta/a/imagen_archivo_obj_3.jpg', @product_id),  -- Imagen para el producto
('ruta/a/imagen_archivo_obj_4.jpg', @product_id);  -- Otra imagen para el producto
--Utilizacion de el procedimiento insertar mensaje
EXEC insert_message
    @message_name = 'Juan Pérez',
    @message_mail = 'juanperez@example.com',
    @mail_subject = 'Consulta sobre producto',
    @mail_context = 'Estoy interesado en más información sobre el producto.',
    @mail_read = 0,
    @reply = 0,
    @id_user = 1;

--Utilizacion de el procedimiento modificar estado del producto
EXEC modify_product_status @product_id = 1;

--Funciones
--Calculo de ganancias entre dos fechas
SELECT dbo.calculate_revenue('2024-01-01', '2024-12-31') AS total_revenue;

--Obtencion del producto mas vendido entre dos fechas
SELECT dbo.get_top_selling_product('2024-01-01', '2024-12-31') AS top_selling_product_id;

--Obtencion del usuario que gasto mas en la tienda
SELECT * FROM dbo.find_max_spender();

Comparacion de eficiencia
--Consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT TOP 1
    s.id_client AS user_id,
    SUM(sd.quantity_detail * sd.price_detail) AS total_spent
FROM 
    Sale s
INNER JOIN 
    Sale_detail sd ON s.sale_id = sd.id_sale
GROUP BY 
    s.id_client
ORDER BY 
    total_spent DESC;
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Funcion
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SELECT * FROM find_max_spender();
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;













