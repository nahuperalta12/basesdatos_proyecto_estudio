
La mayoría de los SGBD permiten escribir procedimientos y funciones en un lenguaje de programación de propósito general. 
De forma global, para declarar un procedimiento se realizará dela siguiente manera


    CREATE PROCEDURE <nombre_procedimiento> (<parámetros>) 
    <declaraciones locales> 
    <cuerpo del procedimiento>;
  
Los parámetros y las declaraciones tienen carácter opcional, especificandose únicamente cuando sea necesario. 
Por otro lado, las funciones necesitan que se determine algún tipo de devolución. 
Esta se refleja con el comando RETURNS a la hora de crear la función. 
La declaración de una función se realiza de la siguiente forma:

~~~
CREATE FUNCTION <nombre_función> (<parámetros>) 
RETURNS (tipo de devolución> 
<declaraciones locales> 
<cuerpo de la función>;
~~~
  
En ocasiones el procedimiento o función se escribe en un lenguaje de programación de propósito general.
En estos casos hay que especificar el nombre del fichero donde se va a almacenar el código del programa, además del lenguaje de programación empleado.
La sintaxis sería:


    CREATE PROCEDURE <nombre del procedimiento o función> (<parámetros>)
    LANGUAGE <nombre del lenguaje de programacióm 
    EXTERNAL NAME <ruta del fichero>;
  

Para llamar a un procedimiento o función se puede utilizar la sentencia CALL que invoca un procedimiento almacenado. La sentencia tiene la siguiente forma:

    CALL <nombre del procedimiento o función> (<argumentos>);
