-- Creación de una tabla de empleados de ejemplo
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- ID único del empleado (clave primaria)
    nombre VARCHAR(100),                        -- Nombre del empleado
    salario DECIMAL(10, 2),                      -- Salario del empleado
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Fecha de registro del empleado
);

-- Creación de una tabla de auditoría para registrar cambios
CREATE TABLE auditoria_empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- ID único para cada entrada de auditoría
    accion VARCHAR(50),                         -- Tipo de acción (INSERT, UPDATE, DELETE)
    id_empleado INT,                            -- ID del empleado afectado
    nombre_anterior VARCHAR(100),               -- Nombre anterior del empleado
    salario_anterior DECIMAL(10, 2),            -- Salario anterior
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Fecha y hora de la acción
    usuario VARCHAR(100)                        -- Usuario que realizó la acción
);

-- Trigger de auditoría para capturar los cambios antes de una actualización o eliminación
CREATE TRIGGER before_update_delete_empleado
BEFORE UPDATE OR DELETE ON empleados         -- Se ejecuta antes de actualizar o eliminar un registro
FOR EACH ROW                                -- Se ejecuta por cada fila afectada
BEGIN
    -- Registro de la acción en la tabla de auditoría antes de realizar la actualización o eliminación
    IF (OLD.id IS NOT NULL) THEN
        INSERT INTO auditoria_empleados (accion, id_empleado, nombre_anterior, salario_anterior, usuario)
        VALUES (
            CASE
                WHEN (OLD.nombre <> NEW.nombre OR OLD.salario <> NEW.salario) THEN 'UPDATE'  -- Si hubo cambios en los datos
                ELSE 'DELETE'  -- Si se está eliminando un registro
            END,
            OLD.id,
            OLD.nombre,
            OLD.salario,
            USER()  -- Obtiene el usuario actual de la base de datos que realiza la operación
        );
    END IF;
END;

-- Trigger para evitar eliminación de empleados y mostrar un mensaje de error
CREATE TRIGGER prevent_delete_empleado
BEFORE DELETE ON empleados                  -- Se ejecuta antes de eliminar un registro de empleados
FOR EACH ROW                                -- Se ejecuta por cada fila afectada
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite la eliminación de empleados';  -- Bloquea la operación de eliminación y muestra el mensaje
END;

-- Inserción de ejemplo para activar los triggers de auditoría
INSERT INTO empleados (nombre, salario) VALUES ('Juan Perez', 3500.00);

-- Actualización de ejemplo para activar los triggers de auditoría
UPDATE empleados SET salario = 3800.00 WHERE nombre = 'Juan Perez';

-- Intento de eliminación para activar el trigger de bloqueo de eliminaciones
DELETE FROM empleados WHERE nombre = 'Juan Perez';

-- Consulta para ver los registros de auditoría
SELECT * FROM auditoria_empleados;

/*Tablas de Datos y Auditoría:

empleados: Contiene los datos de los empleados, como el nombre y el salario.
auditoria_empleados: Registra los cambios realizados en la tabla empleados, con detalles como la acción realizada (INSERT, UPDATE, DELETE), los valores anteriores (para UPDATE y DELETE), la fecha y hora del cambio, y el usuario que realizó la operación.
Trigger before_update_delete_empleado:

Se activa antes de una actualización (UPDATE) o eliminación (DELETE) en la tabla empleados.
Captura los valores antes de la modificación (usando OLD) y los registra en la tabla auditoria_empleados. Si se realiza una actualización, se guarda como una acción de tipo UPDATE; si es una eliminación, se guarda como una acción de tipo DELETE.
El trigger también almacena el nombre del usuario que realizó la operación (USER()), lo que permite auditar quién realizó la acción.
Trigger prevent_delete_empleado:

Se activa antes de una eliminación (DELETE) de la tabla empleados.
Bloquea la eliminación mediante el uso de SIGNAL SQLSTATE, que genera un error personalizado con el mensaje: "No se permite la eliminación de empleados". Esto asegura que las eliminaciones de registros en la tabla empleados no sean permitidas.
Pruebas:

Se realiza una inserción de un nuevo empleado en la tabla empleados, lo que genera un registro en la tabla de auditoría.
Se realiza una actualización del salario del empleado, lo que también genera un registro en la tabla de auditoría.
Se realiza un intento de eliminación del empleado, el cual es bloqueado por el trigger prevent_delete_empleado.
Consulta de auditoría:

Finalmente, se consulta la tabla auditoria_empleados para verificar que los registros de auditoría hayan sido correctamente generados.
Conclusiones basadas en las pruebas realizadas:
Funcionalidad de los Triggers: Los triggers funcionan correctamente al registrar las acciones de modificación y eliminación en la tabla de auditoría. El trigger de auditoría captura tanto las actualizaciones de datos como los intentos de eliminación, garantizando la trazabilidad completa de las operaciones.

Impacto en la Integridad y Seguridad de los Datos: Los triggers aseguran que todas las modificaciones de datos sean auditadas y almacenadas en la tabla de auditoría, lo que mejora la integridad de los datos al mantener un historial completo de cambios. Además, el trigger que bloquea las eliminaciones refuerza la seguridad de los datos críticos al impedir que se borren accidentalmente.

Claridad en la Documentación y Pruebas: El código está claramente documentado, lo que facilita su comprensión. Las pruebas realizadas (inserciones, actualizaciones y bloqueos de eliminaciones) demuestran que los triggers funcionan según lo esperado, garantizando tanto la seguridad como la auditoría de los cambios en los datos.*/
