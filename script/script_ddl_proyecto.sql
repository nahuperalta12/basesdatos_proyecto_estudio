-- SCRIPT TEMA "nombre del tema"
-- DEFINNICIÓN DEL MODELO DE DATOS

CREATE DATATABLE nombre_base;

USE nombre_base;

CREATE TABLE User
(
  user_id INT NOT NULL,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  email VARCHAR(80) NOT NULL,
  active INT NOT NULL,
  usert_type INT NOT NULL,
  token_activation VARCHAR(100) NOT NULL,
  token_reset VARCHAR(100) NOT NULL,
  token_reset_expires_at DATE NOT NULL,
  created_at DATE NOT NULL,
  updated_at DATE NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE Product_category
(
  category_id INT NOT NULL,
  category_description VARCHAR(100) NOT NULL,
  PRIMARY KEY (category_id)
);

CREATE TABLE Message
(
  message_id INT NOT NULL,
  message_name VARCHAR(80) NOT NULL,
  message_mail VARCHAR(80) NOT NULL,
  mail_subject VARCHAR(100) NOT NULL,
  mail_context VARCHAR(255) NOT NULL,
  read INT NOT NULL,
  reply INT NOT NULL,
  id_user INT NOT NULL,
  PRIMARY KEY (message_id),
  FOREIGN KEY (id_user) REFERENCES User(user_id)
);

CREATE TABLE Payment_method
(
  method_id INT NOT NULL,
  method_name VARCHAR(25) NOT NULL,
  PRIMARY KEY (method_id)
);

CREATE TABLE Payment_status
(
  status_id INT NOT NULL,
  status_name VARCHAR(25) NOT NULL,
  PRIMARY KEY (status_id)
);

CREATE TABLE Country
(
  country_id INT NOT NULL,
  country_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (country_id)
);

CREATE TABLE Product
(
  product_id INT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  product_description VARCHAR(255) NOT NULL,
  product_price FLOAT NOT NULL,
  sold_count INT NOT NULL,
  product_status INT NOT NULL,
  id_category INT NOT NULL,
  PRIMARY KEY (product_id),
  FOREIGN KEY (id_category) REFERENCES Product_category(category_id)
);

CREATE TABLE Product_image
(
  imagen_id INT NOT NULL,
  imagen_rute VARCHAR(255) NOT NULL,
  id_product INT NOT NULL,
  PRIMARY KEY (imagen_id),
  FOREIGN KEY (id_product) REFERENCES Product(product_id)
);

CREATE TABLE Payment
(
  payment_id INT NOT NULL,
  payment_date DATE NOT NULL,
  status_id INT NOT NULL,
  method_id INT NOT NULL,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (status_id) REFERENCES Payment_status(status_id),
  FOREIGN KEY (method_id) REFERENCES Payment_method(method_id)
);

CREATE TABLE Province
(
  province_id INT NOT NULL,
  province_name VARCHAR(100) NOT NULL,
  id_country INT NOT NULL,
  PRIMARY KEY (province_id, id_country),
  FOREIGN KEY (id_country) REFERENCES Country(country_id)
);

CREATE TABLE City
(
  city_id INT NOT NULL,
  city_name VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20) NOT NULL,
  id_province INT NOT NULL,
  id_country INT NOT NULL,
  PRIMARY KEY (city_id, id_province, id_country),
  FOREIGN KEY (id_province, id_country) REFERENCES Province(province_id, id_country)
);

CREATE TABLE Billing_address
(
  billing_id INT NOT NULL,
  address_line1 VARCHAR(255) NOT NULL,
  adress_line2 VARCHAR(255) NOT NULL,
  created_at DATE NOT NULL,
  updated_at DATE NOT NULL,
  id_city INT NOT NULL,
  id_province INT NOT NULL,
  id_country INT NOT NULL,
  PRIMARY KEY (billing_id),
  FOREIGN KEY (id_city, id_province, id_country) REFERENCES City(city_id, id_province, id_country)
);

CREATE TABLE Sale
(
  sale_id INT NOT NULL,
  sale_date DATE NOT NULL,
  id_client INT NOT NULL,
  id_billing INT NOT NULL,
  payment_id INT NOT NULL,
  PRIMARY KEY (sale_id),
  FOREIGN KEY (id_client) REFERENCES User(user_id),
  FOREIGN KEY (id_billing) REFERENCES Billing_address(billing_id),
  FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);

CREATE TABLE Sale_detail
(
  sale_detail_id INT NOT NULL,
  quantity_detail INT NOT NULL,
  price_detail FLOAT NOT NULL,
  id_sale INT NOT NULL,
  id_product INT NOT NULL,
  PRIMARY KEY (sale_detail_id),
  FOREIGN KEY (id_sale) REFERENCES Sale(sale_id),
  FOREIGN KEY (id_product) REFERENCES Product(product_id)
);
