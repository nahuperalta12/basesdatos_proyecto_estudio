-- Lote de prueba para la tabla User
-- Correcto
INSERT INTO User (username, password, name, surname, email, active, user_type, token_activation, token_reset, token_reset_expires_at)
VALUES 
('jlopez', 'password123', 'Juan', 'Lopez', 'jlopez@mail.com', 1, 1, NULL, NULL, NULL),
('mgarcia', 'segura456', 'Maria', 'Garcia', 'mgarcia@mail.com', 1, 2, NULL, NULL, NULL);

-- Incorrecto (username duplicado y valor incorrecto para 'active')
INSERT INTO User (username, password, name, surname, email, active, user_type, token_activation, token_reset, token_reset_expires_at)
VALUES 
('jlopez', 'password789', 'Ana', 'Perez', 'aperez@mail.com', 2, 3, NULL, NULL, NULL); 

-- Lote de prueba para la tabla Product_category
-- Correcto
INSERT INTO Product_category (category_id, category_description)
VALUES 
(1, 'Archivos STL'),
(2, 'Archivos OBJ');

-- Incorrecto (descripción duplicada)
INSERT INTO Product_category (category_id, category_description)
VALUES 
(3, 'Archivos STL');

-- Lote de prueba para la tabla Message
-- Correcto
INSERT INTO Message (message_name, message_mail, mail_subject, mail_context, read, reply, id_user)
VALUES 
('Consulta sobre el producto', 'cliente1@mail.com', 'Problema con el archivo', 'El archivo STL no se abre', 0, 0, 1);

-- Incorrecto (valores fuera de rango para 'read' y 'reply')
INSERT INTO Message (message_name, message_mail, mail_subject, mail_context, read, reply, id_user)
VALUES 
('Reclamo de pago', 'cliente2@mail.com', 'Error en el pago', 'No puedo completar el pago', 2, 3, NULL);

-- Lote de prueba para la tabla Payment_method
-- Correcto
INSERT INTO Payment_method (method_name)
VALUES 
('Tarjeta de Crédito'),
('Transferencia Bancaria');

-- Incorrecto (nombre de método duplicado)
INSERT INTO Payment_method (method_name)
VALUES 
('Tarjeta de Crédito');

-- Lote de prueba para la tabla Payment_status
-- Correcto
INSERT INTO Payment_status (status_name)
VALUES 
('Pendiente'),
('Completado');

-- Incorrecto (nombre de estado duplicado)
INSERT INTO Payment_status (status_name)
VALUES 
('Completado');

-- Lote de prueba para la tabla Country
-- Correcto
INSERT INTO Country (country_name)
VALUES 
('Argentina');

-- Incorrecto (nombre vacío)
INSERT INTO Country (country_name)
VALUES 
('');

-- Lote de prueba para la tabla Product
-- Correcto
INSERT INTO Product (product_name, product_description, product_price, sold_count, product_status, id_category)
VALUES 
('Archivo STL de figura 3D', 'Archivo STL para impresión 3D de una figura', 100.50, 0, 1, 1);

-- Incorrecto (precio negativo)
INSERT INTO Product (product_name, product_description, product_price, sold_count, product_status, id_category)
VALUES 
('Archivo OBJ de juguete', 'Archivo OBJ para impresión de juguete', -50, 0, 1, 1);

-- Lote de prueba para la tabla Product_image
-- Correcto
INSERT INTO Product_image (imagen_rute, id_product)
VALUES 
('ruta_imagen1.jpg', 1);

-- Incorrecto (producto inexistente)
INSERT INTO Product_image (imagen_rute, id_product)
VALUES 
('ruta_imagen2.jpg', 999);

-- Lote de prueba para la tabla Payment
-- Correcto
INSERT INTO Payment (payment_date, id_status, id_method)
VALUES 
('2024-01-01', 1, 1);

-- Incorrecto (fecha inválida y método inexistente)
INSERT INTO Payment (payment_date, id_status, id_method)
VALUES 
('2024-13-01', 1, 999);

-- Lote de prueba para la tabla Province
-- Correcto
INSERT INTO Province (id_country, province_name)
VALUES 
(1, 'Buenos Aires');

-- Incorrecto (país inexistente)
INSERT INTO Province (id_country, province_name)
VALUES 
(999, 'Córdoba');

-- Lote de prueba para la tabla City
-- Correcto
INSERT INTO City (postal_code, city_name, id_province, id_country)
VALUES 
('1000', 'CABA', 1, 1);

-- Incorrecto (provincia no existente)
INSERT INTO City (postal_code, city_name, id_province, id_country)
VALUES 
('2000', 'Rosario', 999, 1);

-- Lote de prueba para la tabla Billing_address
-- Correcto
INSERT INTO Billing_address (address_line1, address_line2, created_at, updated_at, id_city, id_province, id_country)
VALUES 
('Av. Siempreviva 123', '', GETDATE(), GETDATE(), 1, 1, 1);

-- Incorrecto (ciudad inexistente)
INSERT INTO Billing_address (address_line1, address_line2, created_at, updated_at, id_city, id_province, id_country)
VALUES 
('Calle Falsa 123', '', GETDATE(), GETDATE(), 999, 1, 1);

-- Lote de prueba para la tabla Sale
-- Correcto
INSERT INTO Sale (sale_date, id_client, id_billing, id_payment)
VALUES 
('2024-01-01', 1, 1, 1);

-- Incorrecto (cliente inexistente)
INSERT INTO Sale (sale_date, id_client, id_billing, id_payment)
VALUES 
('2024-01-01', 999, 1, 1);

-- Lote de prueba para la tabla Sale_detail
-- Correcto
INSERT INTO Sale_detail (quantity_detail, price_detail, id_sale, id_product)
VALUES 
(1, 100.50, 1, 1);

-- Incorrecto (precio negativo)
INSERT INTO Sale_detail (quantity_detail, price_detail, id_sale, id_product)
VALUES 
(1, -100.50, 1, 1);
