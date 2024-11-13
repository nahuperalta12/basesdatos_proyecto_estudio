# Tema 4: "Triggers en Bases de Datos"

Un **trigger** o disparador es una estructura de código almacenado en una base de datos que se ejecuta automáticamente al detectarse un evento específico en una tabla. Estos eventos pueden ser operaciones de inserción, actualización o eliminación de datos y permiten realizar acciones adicionales de forma automática, tales como validaciones, auditorías, o replicación de información. Los triggers se configuran para responder a ciertos cambios en las tablas, asegurando la consistencia de los datos, y son ampliamente utilizados para reforzar reglas de negocio o mejorar la seguridad de la base de datos.

## Tipos y Ejecución de Triggers en SQL

Los triggers en SQL se dividen en dos categorías principales, cada una con sus propios escenarios de uso:

1. **Triggers DML (Data Manipulation Language)**: Se activan con eventos de manipulación de datos como las declaraciones `INSERT`, `UPDATE` o `DELETE`. Este tipo es el más utilizado, ya que permite monitorear y reaccionar ante cambios en los datos de una tabla.
   
2. **Triggers DDL (Data Definition Language)**: Se ejecutan en respuesta a eventos que modifican la estructura de la base de datos, tales como la creación, modificación o eliminación de tablas y otros objetos. También pueden activarse ante ciertos eventos del servidor, como cambios en la seguridad.

Cada tipo de trigger DML se configura para ejecutarse en diferentes momentos respecto al evento que lo desencadena. Estos tipos son:

- **AFTER [INSERT, UPDATE, DELETE]**: Se ejecutan después de que se complete la instrucción principal. Esto permite que el trigger acceda a los datos finales, ideales para tareas de auditoría o registro.
  
- **INSTEAD OF [INSERT, UPDATE, DELETE]**: Este tipo reemplaza el evento que lo activa, es decir, no se realiza el cambio original. Estos triggers son muy útiles en vistas complejas o en escenarios de integridad referencial entre bases de datos, donde se debe controlar más estrictamente el flujo de operaciones.

## Creación de Triggers: Pasos y Sintaxis

Para definir un trigger en SQL, se deben seguir dos pasos fundamentales:

1. **Definir la función disparadora**: Este es el código que contiene las instrucciones que se ejecutarán al activarse el trigger. La función disparadora debe incluir todas las acciones o reglas que se deseen aplicar cuando se cumpla el evento específico.

2. **Crear el trigger propiamente dicho**: Utilizando el comando `CREATE TRIGGER`, se asocia la función disparadora al trigger y se configuran los parámetros que especifican cuándo y cómo debe activarse el trigger.

La sintaxis básica para crear un trigger en SQL es la siguiente:

-- Creación del trigger en SQL
```sql
CREATE
    [DEFINER = { usuario | CURRENT_USER }]  -- Especifica el usuario que define el trigger
    TRIGGER nombre_del_trigger              -- Nombre que se asignará al trigger
    momento_evento evento_disparo          -- El momento en que se ejecutará el trigger (BEFORE o AFTER)
    ON nombre_tabla FOR EACH ROW           -- La tabla en la que se activa el trigger
    [orden_trigger]                        -- Orden de ejecución en caso de múltiples triggers
    cuerpo_del_trigger                     -- El bloque de código que contiene las acciones del trigger
```
## Eventos que Desencadenan Triggers

Un trigger puede responder a los siguientes eventos en una tabla:

- **INSERT**: Cuando se inserta una nueva fila en la tabla.
- **UPDATE**: Cuando se actualizan una o más columnas de una fila existente.
- **DELETE**: Cuando se elimina una fila de la tabla.

Al activarse un trigger en uno de estos eventos, puede llevar a cabo acciones de auditoría, verificación de permisos, cálculo de valores derivados y otras tareas automatizadas.

## Ventajas de Usar Triggers en Bases de Datos

El uso de triggers en una base de datos aporta una serie de beneficios que facilitan la administración de los datos y la implementación de reglas de negocio. Algunas de las principales ventajas son:

- **Automatización de valores derivados**: Permiten calcular automáticamente ciertos valores de columnas, lo cual reduce la intervención manual.
  
- **Aplicación de integridad referencial**: Los triggers pueden garantizar que se respeten las relaciones entre tablas, evitando datos inconsistentes.
  
- **Registro de eventos**: Capturan información sobre accesos y modificaciones en la base de datos, útil para auditoría y trazabilidad.
  
- **Sincronización de datos**: Permiten replicar información en tiempo real entre tablas, asegurando que los datos se mantengan actualizados de forma automática.
  
- **Control de acceso y seguridad**: Ayudan a establecer restricciones sobre ciertas operaciones, mejorando la protección de los datos sensibles.
  
- **Prevención de transacciones no válidas**: Los triggers pueden bloquear operaciones no permitidas, minimizando el riesgo de errores de usuario.

## Conclusión sobre el Uso de Triggers

En las pruebas realizadas, los triggers demostraron ser efectivos para garantizar la integridad y la seguridad de la base de datos. Los triggers de auditoría registraron adecuadamente el estado previo de los datos en cada operación de modificación, incluyendo detalles como el tipo de cambio, usuario, fecha y hora. Esto proporciona un nivel de control detallado y fiable sobre las operaciones en la base de datos.

Los triggers de seguridad, por otro lado, mostraron ser efectivos al impedir eliminaciones no autorizadas en tablas sensibles. Este mecanismo ofrece un nivel adicional de protección en las tablas críticas, y el sistema permite desactivar temporalmente los triggers cuando sea necesario para realizar operaciones excepcionales. Esta flexibilidad es esencial para situaciones imprevistas y contribuye a una gestión más segura y controlada de los datos.

