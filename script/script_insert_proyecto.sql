-- SCRIPT "nombre del proyecto"
-- INSERCIÓN DEL LOTE DE DATOS

--Lote de datos correctos:

-- Insertar datos en la tabla User
INSERT INTO User (user_id, username, password, name, surname, email, active, usert_type, token_activation, token_reset, token_reset_expires_at, created_at, updated_at)
VALUES
(1, 'john_doe', 'hashed_password_123', 'John', 'Doe', 'john.doe@example.com', 1, 1, 'token123', 'reset_token123', '2024-12-01', '2024-01-01', '2024-01-01'),
(2, 'jane_doe', 'hashed_password_456', 'Jane', 'Doe', 'jane.doe@example.com', 1, 2, 'token456', 'reset_token456', '2024-12-01', '2024-02-01', '2024-02-01');

-- Insertar datos en la tabla Product_category
INSERT INTO Product_category (category_id, category_description)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');

-- Insertar datos en la tabla Message
INSERT INTO Message (message_id, message_name, message_mail, mail_subject, mail_context, read, reply, id_user)
VALUES
(1, 'Support Request', 'support@example.com', 'Issue with product', 'The product has a defect.', 0, 0, 1),
(2, 'Feedback', 'feedback@example.com', 'Product review', 'The product works great.', 1, 1, 2);

-- Insertar datos en la tabla Payment_method
INSERT INTO Payment_method (method_id, method_name)
VALUES
(1, 'Credit Card'),
(2, 'PayPal'),
(3, 'Bank Transfer');

-- Insertar datos en la tabla Payment_status
INSERT INTO Payment_status (status_id, status_name)
VALUES
(1, 'Pending'),
(2, 'Completed'),
(3, 'Failed');

-- Insertar datos en la tabla Country
INSERT INTO Country (country_id, country_name)
VALUES
(1, 'United States'),
(2, 'Canada'),
(3, 'Mexico');

-- Insertar datos en la tabla Product
INSERT INTO Product (product_id, product_name, product_description, product_price, sold_count, product_status, id_category)
VALUES
(1, 'Laptop', 'High performance laptop', 999.99, 10, 1, 1),
(2, 'T-Shirt', 'Cotton T-shirt', 19.99, 50, 1, 2),
(3, 'Book', 'Programming in C#', 29.99, 100, 1, 3);

-- Insertar datos en la tabla Product_image
INSERT INTO Product_image (imagen_id, imagen_rute, id_product)
VALUES
(1, '/images/laptop.png', 1),
(2, '/images/tshirt.png', 2),
(3, '/images/book.png', 3);

-- Insertar datos en la tabla Payment
INSERT INTO Payment (payment_id, payment_date, status_id, method_id)
VALUES
(1, '2024-09-20', 2, 1),
(2, '2024-09-21', 2, 2),
(3, '2024-09-22', 1, 3);

-- Insertar datos en la tabla Province (corregida)
INSERT INTO Province (province_id, province_name, id_country)
VALUES
(1, 'California', 1),
(2, 'Ontario', 2),
(3, 'Mexico City', 3);

-- Insertar datos en la tabla City (corregida)
INSERT INTO City (city_id, city_name, postal_code, id_province, id_country)
VALUES
(1, 'Los Angeles', '90001', 1, 1),
(2, 'Toronto', 'M5H 2N2', 2, 2),
(3, 'Coyoacan', '04000', 3, 3);

-- Insertar datos en la tabla Billing_address
INSERT INTO Billing_address (billing_id, address_line1, adress_line2, created_at, updated_at, id_city, id_province, id_country)
VALUES
(1, '123 Main St', 'Apt 4B', '2024-01-01', '2024-01-02', 1, 1, 1),
(2, '456 Park Ave', 'Suite 900', '2024-02-01', '2024-02-02', 2, 2, 2);

-- Insertar datos en la tabla Sale
INSERT INTO Sale (sale_id, sale_date, id_client, id_billing, payment_id)
VALUES
(1, '2024-09-25', 1, 1, 1),
(2, '2024-09-26', 2, 2, 2);

-- Insertar datos en la tabla Sale_detail
INSERT INTO Sale_detail (sale_detail_id, quantity_detail, price_detail, id_sale, id_product)
VALUES
(1, 1, 999.99, 1, 1),
(2, 3, 59.97, 2, 2);

-- Lote de datos erroneos:

