/*
El tema 01 "manejo de permisos a nivel de usuarios de base de datos" y el tema 02 "procedimientos y funciones almacenadas" 
están estrechamente relacionados al garantizar control de acceso y seguridad. Los permisos definen quién puede 
ejecutar scripts específicos, mientras que los procedimientos y funciones encapsulan operaciones complejas, optimizando la 
ejecución y protegiendo datos críticos. Esta relación es clave para administrar bases de datos, ya que permite limitar el 
acceso a operaciones sensibles solo a usuarios autorizados, fortaleciendo la seguridad y estandarización de tareas.
*/
--------------------------------------------------------------------------------------------------------------------------
--A partir de aquí se resuelven las tareas asignadas al tema 

--Configurar la base de datos en modo mixto
--Se puede hacer con SQL
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Authentication Mode', 2; -- 2 habilita el modo mixto
RECONFIGURE;

--Creación de usuarios y asignación de permisos
--Crea los dos usuarios de base de datos y establece sus permisos
-- Crea usuarios
CREATE LOGIN db_user_read_only WITH PASSWORD = 'SecurePassword1!';
CREATE USER db_user_read_only FOR LOGIN db_user_read_only;

CREATE LOGIN db_admin_user WITH PASSWORD = 'SecurePassword2!';
CREATE USER db_admin_user FOR LOGIN db_admin_user;

-- Asigna permisos al usuario de solo lectura
GRANT SELECT ON SCHEMA::dbo TO db_user_read_only;

-- Asigna permisos de administrador al segundo usuario
GRANT CONTROL ON SCHEMA::dbo TO db_admin_user;


--Crea procedimientos almacenados
CREATE PROCEDURE AddMessage
  @message_name VARCHAR(80),
  @message_mail VARCHAR(80),
  @mail_subject VARCHAR(100),
  @mail_context VARCHAR(255)
AS
BEGIN
  INSERT INTO Message (message_name, message_mail, mail_subject, mail_context, mail_read, reply, id_user)
  VALUES (@message_name, @message_mail, @mail_subject, @mail_context, 0, 0, NULL);
END;
GO

--Asigna permisos de ejecución para el usuario de solo lectura
GRANT EXECUTE ON AddMessage TO db_user_read_only;


--Pruebas de inserción
--1.Intento de inserción directo con usuario de solo lectura**: Conéctate como `db_user_read_only` e intenta ejecutar un `INSERT` directo en la tabla `Message` para verificar que el acceso está restringido.
INSERT INTO Message (message_name, message_mail, mail_subject, mail_context, mail_read, reply, id_user)
VALUES ('User Test', 'test@example.com', 'Subject', 'Test message', 0, 0, NULL);
-- Esto debería generar un error de permisos.

--2. Inserción usando el procedimiento almacenado: Con el mismo usuario, realiza un `INSERT` a través del procedimiento `AddMessage`.
EXEC AddMessage 'User Test', 'test@example.com', 'Subject', 'Test message';
-- Esto debería completarse sin problemas.


-- 3. Inserción directa con el usuario administrador Conectate como `db_admin_user` y realiza un `INSERT` directo en la tabla.
INSERT INTO Message (message_name, message_mail, mail_subject, mail_context, mail_read, reply, id_user)
VALUES ('Admin Test', 'admin@example.com', 'Admin Subject', 'Admin test message', 0, 0, NULL);

-- Crear roles con permisos específicos
-- Crea un rol para otorgar permisos de lectura en una tabla específica y asigna este rol a uno de los usuarios.
-- Crear el rol y asignar permisos
CREATE ROLE read_only_role;
GRANT SELECT ON Product TO read_only_role;

-- Asignar el rol al usuario
ALTER ROLE read_only_role ADD MEMBER db_user_read_only;


--Para verificar el comportamiento:
--1. Usuario con permisos en el rol: Al conectarse como `db_user_read_only` y realizar una consulta en la tabla `Product` se  confirma que tiene acceso de lectura.
SELECT * FROM Product; -- Esto debería completarse correctamente.
   

--2. Al conectarse como otro usuario sin el rol `read_only_role` y   el acceso está denegado.
SELECT * FROM Product; -- Esto debería generar un error de permisos.

----------------------------------------------------------------------------------------------------------------------------
-- Pruebas de funciones para permisos

--Creación de Funciones para Asignar Permisos
  --Función para Asignar Permisos a un Usuario No Registrado (Visitante):
CREATE PROCEDURE AsignarPermisosVisitante(@user_id INT)
AS
BEGIN
    -- Asignar permisos para usuarios no registrados (visitantes)
    GRANT SELECT ON Product TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT ON Product_image TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT ON Product_category TO [User_table] WHERE user_id = @user_id;
    GRANT INSERT ON Message TO [User_table] WHERE user_id = @user_id;
END;


    --Función para Asignar Permisos a un Usuario Registrado:
CREATE PROCEDURE AsignarPermisosRegistrado(@user_id INT)
AS
BEGIN
    -- Asignar permisos heredados de visitante
    EXEC AsignarPermisosVisitante @user_id;

    -- Permisos adicionales para usuarios registrados
    GRANT SELECT ON Sale TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT ON Sale_detail TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT ON Payment TO [User_table] WHERE user_id = @user_id;
    GRANT INSERT ON Sale TO [User_table] WHERE user_id = @user_id;
    GRANT INSERT ON Sale_detail TO [User_table] WHERE user_id = @user_id;
END;

    --Función para Asignar Permisos a un Administrador de Productos:
CREATE PROCEDURE AsignarPermisosAdminProductos(@user_id INT)
AS
BEGIN
    -- Permisos para administrar productos
    GRANT SELECT, INSERT, UPDATE, DELETE ON Product TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT, INSERT, UPDATE, DELETE ON Product_image TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT, INSERT, UPDATE, DELETE ON Product_category TO [User_table] WHERE user_id = @user_id;
END;


    --Función para Asignar Permisos a un Administrador de Consultas:
CREATE PROCEDURE AsignarPermisosAdminConsultas(@user_id INT)
AS
BEGIN
    -- Permisos para administrar consultas de los usuarios
    GRANT SELECT, UPDATE ON Message TO [User_table] WHERE user_id = @user_id;
END;


    --Función para Asignar Permisos a un Administrador de Usuarios:
CREATE PROCEDURE AsignarPermisosAdminUsuarios(@user_id INT)
AS
BEGIN
    -- Permisos para gestionar usuarios
    GRANT SELECT, INSERT, UPDATE, DELETE ON User_table TO [User_table] WHERE user_id = @user_id;
    GRANT UPDATE ON User_table TO [User_table] WHERE user_id = @user_id;
    GRANT SELECT ON Message TO [User_table] WHERE user_id = @user_id;
END;


--2. Función para Asignar Roles
CREATE PROCEDURE AsignarRolAUsuario(@user_id INT, @user_type INT)
AS
BEGIN
    -- Asignar el rol al usuario en la tabla User_table
    UPDATE User_table
    SET user_type = @user_type
    WHERE user_id = @user_id;

    -- Asignar permisos según el tipo de usuario
    IF @user_type = 1  -- Usuario No Registrado (Visitante)
    BEGIN
        EXEC AsignarPermisosVisitante @user_id;
    END
    ELSE IF @user_type = 2  -- Usuario Registrado
    BEGIN
        EXEC AsignarPermisosRegistrado @user_id;
    END
    ELSE IF @user_type = 3  -- Administrador de Productos
    BEGIN
        EXEC AsignarPermisosAdminProductos @user_id;
    END
    ELSE IF @user_type = 4  -- Administrador de Consultas
    BEGIN
        EXEC AsignarPermisosAdminConsultas @user_id;
    END
    ELSE IF @user_type = 5  -- Administrador de Usuarios
    BEGIN
        EXEC AsignarPermisosAdminUsuarios @user_id;
    END
END;


--3. Asignación de Roles en la Base de Datos
-- Asignar el rol de "Usuario Registrado" a un usuario con user_id 5
EXEC AsignarRolAUsuario @user_id = 5, @user_type = 2;

-- Asignar el rol de "Administrador de Productos" a un usuario con user_id 7
EXEC AsignarRolAUsuario @user_id = 7, @user_type = 3;
-------------------------------------------------------------------------
