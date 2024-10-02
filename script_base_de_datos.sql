--CREATE DATABASE BD3DBitStore
--USE BD3DBitStore

CREATE TABLE User
(
  user_id INT IDENTITY(1,1) NOT NULL, -- ID auto-incremental para usuarios
  username VARCHAR(50) NOT NULL, -- Nombre de usuario único
  password VARCHAR(255) NOT NULL, -- Contraseña del usuario
  name VARCHAR(50) NOT NULL,  -- Nombre del usuario
  surname VARCHAR(50) NOT NULL, -- Apellido del usuario
  email VARCHAR(80) NOT NULL, -- Email único del usuario
  active INT NOT NULL, -- Indica si el usuario está activo (0 o 1)
  user_type INT NOT NULL, -- Tipo de usuario
  token_activation VARCHAR(100) NULL, -- Token de activación opcional
  token_reset VARCHAR(100) NULL, -- Token de reseteo opcional
  token_reset_expires_at DATE NULL, -- Fecha de expiración del token de reseteo
  created_at DATE NOT NULL DEFAULT GETDATE(), -- Fecha de creación por defecto actual
  updated_at DATE NOT NULL DEFAULT GETDATE(), -- Fecha de última actualización
  PRIMARY KEY (user_id), -- Clave Primaria
  CONSTRAINT UQ_User_Username UNIQUE (username),  -- Constraint para username único
  CONSTRAINT UQ_User_Email UNIQUE (email),        -- Constraint para email único
  CONSTRAINT CK_User_Active CHECK (active IN (0, 1)),  -- Solo permite valores 0 o 1 para "active"
  CONSTRAINT CK_User_Type CHECK (user_type IN (1, 2, 3, 4)) -- Valores permitidos para "user_type" 
);

CREATE TABLE Product_category
(
  category_id INT NOT NULL,
  category_description VARCHAR(100) NOT NULL,
  PRIMARY KEY (category_id),
  CONSTRAINT UQ_Product_Category UNIQUE (category_description)  -- La descripción debe ser única
);

CREATE TABLE Message
(
  message_id INT IDENTITY(1,1) NOT NULL,
  message_name VARCHAR(80) NOT NULL,
  message_mail VARCHAR(80) NOT NULL,
  mail_subject VARCHAR(100) NOT NULL,
  mail_context VARCHAR(255) NOT NULL,
  read INT NOT NULL,
  reply INT NOT NULL,
  id_user INT, -- Se agrega como NULL por que usuarios sin registrar pueden dejar un mensaje
  PRIMARY KEY (message_id),
  FOREIGN KEY (id_user) REFERENCES User(user_id) ON DELETE CASCADE,  -- Borra mensajes si se elimina el usuario
  CONSTRAINT CK_Message_Read CHECK (read IN (0, 1)),  -- Solo valores 0 o 1 para "read"
  CONSTRAINT CK_Message_Reply CHECK (reply IN (0, 1)) -- Solo valores 0 o 1 para "reply"
);

CREATE TABLE Payment_method
(
  method_id INT IDENTITY(1,1) NOT NULL,
  method_name VARCHAR(25) NOT NULL,
  CONSTRAINT PK_method_id PRIMARY KEY (method_id),
  CONSTRAINT UQ_Payment_Method UNIQUE (method_name),  -- Nombre del método debe ser único  
);

CREATE TABLE Payment_status
(
  status_id INT IDENTITY(1,1) NOT NULL,
  status_name VARCHAR(25) NOT NULL,
  CONSTRAINT PK_status_id PRIMARY KEY (status_id),
  CONSTRAINT UQ_Payment_Status UNIQUE (status_name),  -- Nombre del estado debe ser único
);

CREATE TABLE Country
(
  country_id INT IDENTITY(1,1) NOT NULL,
  country_name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_country_id PRIMARY KEY (country_id)
);

CREATE TABLE Product
(
  product_id INT IDENTITY(1,1) NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  product_description VARCHAR(255) NOT NULL,
  product_price FLOAT NOT NULL,
  sold_count INT NOT NULL,
  product_status INT NOT NULL,
  id_category INT NOT NULL,
  CONSTRAINT PK_product_id PRIMARY KEY (product_id),
  CONSTRAINT FK_product_id_id_category FOREIGN KEY (id_category) REFERENCES Product_category(category_id)
);

CREATE TABLE Product_image
(
  imagen_id INT IDENTITY(1,1) NOT NULL,
  imagen_rute VARCHAR(255) NOT NULL,
  id_product INT NOT NULL,
  CONSTRAINT PK_imagen_id PRIMARY KEY (imagen_id),
  CONSTRAINT FK_imagen_id_id_product FOREIGN KEY (id_product) REFERENCES Product(product_id)
);

CREATE TABLE Payment
(
  payment_id INT IDENTITY(1,1) NOT NULL,
  payment_date DATE NOT NULL,
  id_status INT NOT NULL,
  id_method INT NOT NULL,
  CONSTRAINT PK_payment_id PRIMARY KEY (payment_id),
  CONSTRAINT FK_status_FOREIGN KEY (id_status) REFERENCES Payment_status(status_id),
  CONSTRAINT FK_status_id_id_method FOREIGN KEY (id_method) REFERENCES Payment_method(method_id)
);

CREATE TABLE Province
(
  province_id INT IDENTITY(1,1) NOT NULL,
  id_country INT NOT NULL,
  province_name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_province_id_id_country PRIMARY KEY (province_id, id_country),
  CONSTRAINT FK__province_id_id_country_id_country FOREIGN KEY (id_country) REFERENCES Country(country_id)
);

CREATE TABLE City
(
  city_id INT IDENTITY(1,1) NOT NULL,
  postal_code VARCHAR(20) NOT NULL,
  city_name VARCHAR(100) NOT NULL,
  id_province INT NOT NULL,
  id_country INT NOT NULL,
  CONSTRAINT PK_city_id_id_province_id_country PRIMARY KEY (city_id, id_province, id_country),
  CONSTRAINT FK_city_id_id_province_id_country FOREIGN KEY (id_province, id_country) REFERENCES Province(province_id, id_country)
);

CREATE TABLE Billing_address
(
  billing_id INT IDENTITY(1,1) NOT NULL,
  address_line1 VARCHAR(255) NOT NULL,
  address_line2 VARCHAR(255) NOT NULL,
  created_at DATE NOT NULL,
  updated_at DATE NOT NULL,
  id_city INT NOT NULL,
  id_province INT NOT NULL,
  id_country INT NOT NULL,
  CONSTRAINT PK_billing_id PRIMARY KEY (billing_id),
  CONSTRAINT FK_billing_id_id_city_id_province_id_country FOREIGN KEY (id_city, id_province, id_country) REFERENCES City(city_id, id_province, id_country)
);

CREATE TABLE Sale
(
  sale_id INT IDENTITY(1,1) NOT NULL,
  sale_date DATE NOT NULL,
  id_client INT NOT NULL,
  id_billing INT NOT NULL,
  id_payment INT NOT NULL,
  CONSTRAINT PK_sale_id PRIMARY KEY (sale_id),
  CONSTRAINT FK_sale_id_id_client FOREIGN KEY (id_client) REFERENCES User(user_id),
  CONSTRAINT FK_sale_id_id_billing FOREIGN KEY (id_billing) REFERENCES Billing_address(billing_id),
  CONSTRAINT FK_sale_id_id_payment FOREIGN KEY (id_payment) REFERENCES Payment(id_payment)
);

CREATE TABLE Sale_detail
(
  sale_detail_id INT IDENTITY(1,1) NOT NULL,
  quantity_detail INT NOT NULL,
  price_detail FLOAT NOT NULL,
  id_sale INT NOT NULL,
  id_product INT NOT NULL,
  CONSTRAINT PK_sale_detail_id PRIMARY KEY (sale_detail_id),
  CONSTRAINT FK_sale_detail_id_id_sale FOREIGN KEY (id_sale) REFERENCES Sale(sale_id),
  CONSTRAINT FK_sale_detail_id_id_product FOREIGN KEY (id_product) REFERENCES Product(product_id)
);
