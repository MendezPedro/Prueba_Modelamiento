\c postgres

DROP DATABASE biblioteca;
CREATE DATABASE biblioteca;

\c biblioteca

create table socios (
    rut varchar(15),
    nombre varchar(10),
    apellido varchar(10),
    direccion varchar(50),
    telefono int
);

create table libros (
    isbn varchar(15),
    titulo varchar(30),
    pagina int,
    cod_autor int,
    nombre_autor varchar(10),
    apellido_autor varchar(10),
    nacimiento_muerte  varchar(10),
    tipo_autor varchar(10),
    dias_prestamo int
);

create table prestamos (
    socio varchar(25),
    libro varchar(25),
    fecha_prestamo varchar(10),
    fecha_devolucion varchar(10)
);

\copy socios from 'socios.csv' csv header;
\copy libros from 'libros.csv' csv header;
\copy prestamos from 'historial_de_prestamos.csv' csv header;

select * from socios;
select * from libros;
select * from prestamos;
