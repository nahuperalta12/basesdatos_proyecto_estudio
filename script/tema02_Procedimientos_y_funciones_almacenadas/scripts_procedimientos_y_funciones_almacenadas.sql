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

Procedimiento de insercion en tabla Product:


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

