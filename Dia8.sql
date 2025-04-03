-------------- DIA 8 ------------

-- OBJETOS SECUENCIA
-- CREAR UNA SECUENCIA PARA DEPARTAMENTOS
create sequence sec_dept_no
increment by 10
start with 50;

-- UNA SECUENCIA NO SE PUEDE MODIFICAR SOLO ELIMINAR Y CREAR DE NUEVO.
-- TODAVIA O HEMOS UTILIZADO AL SECUENCIA.

select sec_dept_no.nextval as siguiente from dual;

select sec_dept_no.currval as actual from dual;
-- SI LO QUEREMOS PARA INSERTAR DEBEMOS LLAMARLO DE FORMA EXPLICITA
insert into dept values(sec_dept_no.nextval,'Nuevo','Nuevo');
insert into dept values(sec_dept_no.nextval/10,'Nuevo','Nuevo');
select * from dept;
rollback;

drop sequence sec_dept_no;

select * from prueba;

alter table prueba
add(defectosecuencia int default sec_dept_no.nextval );

insert into prueba
(identificador,texto10,textchar)
values
(13,'ee','ee');

rollback;

----
--1º NECESITAMOS UNA CLAVE PRIMARIA EN HOSPITAL
alter table hospital
add constraint pk_hospital
primary key (hospital_cod);

--2º NECESITO UNA CLAVE PRIMARIA EN DOCTOR

alter table doctor
add constraint pk_doctor
primary key (doctor_no);

--3º NECESITO RELACIONAR DOCTORES CON HOSPITAL

alter table doctor
add constraint fk_hospital_doctor
foreign key (hospital_cod)
references hospital (hospital_cod);

--4º LAS PERSONAS DE LA PLANTILLA SOLAMENTE PUEDEN TRABAJAR EN UN TURNOS DE MAÑANA ,TARDE O NOCHE
select * from plantilla;

alter table plantilla
add constraint ck_plantilla_turno
check (turno = 'M' or turno = 'T' or turno = 'N');

alter table dept
add constraint pk_dept
primary key (dept_no);

--------- EJERCICIOS CREAR TABLAS-------------

create table colegios(
cod_colegio integer,
nombre varchar2(20) not null,
localidad varchar2(15),
provincia varchar2(15),
ano_construccion date,
coste_construccion integer,
cod_region integer,
unico integer
);

alter table colegios
add constraint pk_colegios
primary key (cod_colegio);

alter table colegios 
add constraint u_colegios_unico
unique (unico);


create table profesores(
cod_profe varchar(50),
nombre varchar(50) not null,
apellido1 varchar(50),
apellido2 varchar(50),
dni varchar(10),
edad integer,
localidad varchar(50),
provincia varchar(50),
salario integer,
cod_colegio integer
);

alter table profesores
add constraint pk_profesores
primary key (cod_profe);

alter table profesores 
add constraint u_profesores_dni
unique (dni);

alter table profesores 
add constraint ck_profesores_dni
check (dni like '_________');

alter table profesores
add constraint fk_colegios_profesores
foreign key (cod_colegio)
references colegios (cod_colegio);

create table regiones(
cod_region integer,
regiones varchar2(20) not null
);

alter table regiones
add constraint pk_regiones
primary key (cod_region);

create table alumnos(
dni varchar2(10),
nombre varchar2(50) not null,
apellidos varchar2(50),
fecha_ingreso date,
fecha_nac date,
localidad varchar2(15),
provincia varchar2(30),
cod_colegio integer
);

alter table alumnos
add constraint pk_alumnos
primary key (dni);

alter table alumnos
add constraint fk_colegios_alumnos 
foreign key (cod_colegio)
references colegios (cod_colegio);

-- Crear una nueva relación entre el campo Cod_Region de la tabla REGIONES
--y Cod_Region de la tabla colegios.


alter table colegios
add constraint fk_regiones_colegios
foreign key (cod_region)
references regiones (cod_region);
/*
me confundi en el nombre
alter table colegios
rename column cod_regios to cod_region;
*/

-- Añadir el campo Sexo, Fecha de nacimiento y Estado Civil a la tabla Profesores.

alter table profesores
add(Sexo varchar2(10),fecha_nac date,estado_civil varchar2(50));

--    • Eliminar el campo Edad de la tabla Profesores.

alter table profesores
drop column edad ;

--Añadir el campo Sexo, Dirección y Estado Civil a la tabla Alumnos.

alter table alumnos
add(Sexo varchar2(10), direccion varchar2(50) ,estado_civil varchar2(50));

-- Borrar la relación existente entre la tabla profesores y Colegios.

alter table profesores
drop constraint fk_colegios_profesores;

-- Crear de nuevo la relación borrada en el ejercicio anterior que tenga eliminación en cascada.

alter table profesores
add constraint fk_colegios_profesores
foreign key (cod_colegio)
references colegios (cod_colegio)
on delete cascade;
--Agregar un valor por defecto con la fecha actual al campo Fecha_Ingreso de la tabla alumnos.
alter table alumnos
modify(fecha_ingreso date default '03/04/2025');


INSERT INTO regiones (cod_region, regiones) 
VALUES (1, 'Comunidad Valenciana');

INSERT INTO regiones (cod_region, regiones) 
VALUES (2, 'Madrid');

INSERT INTO regiones (cod_region, regiones) 
VALUES (3, 'Cataluña');

select * from alumnos;
-- Suponiendo que los colegios tienen códigos consecutivos de 1 a 3 y el año de construcción es 2000 para todos.

INSERT INTO colegios (cod_colegio, nombre, localidad, provincia, ano_construccion, coste_construccion, cod_region, unico)
VALUES (1, 'Colegio San Juan', 'Madrid', 'Madrid', TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1000000, 2, 12345);

INSERT INTO colegios (cod_colegio, nombre, localidad, provincia, ano_construccion, coste_construccion, cod_region, unico)
VALUES (2, 'Colegio El Sol', 'Arenales', 'Alicante', TO_DATE('2000-01-01', 'YYYY-MM-DD'), 800000, 1, 67890);

INSERT INTO colegios (cod_colegio, nombre, localidad, provincia, ano_construccion, coste_construccion, cod_region, unico)
VALUES (3, 'Colegio Llobregat', 'Llobregat', 'Barcelona', TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1200000, 3, 11223);


-- Suponiendo que los profesores tienen códigos consecutivos y que la relación con los colegios es mediante cod_colegio.
select * from profesores;
INSERT INTO profesores (cod_profe, nombre, apellido1, apellido2, dni, salario, localidad, provincia, cod_colegio, Sexo, fecha_nac, estado_civil)
VALUES ('P001', 'Juan', 'Pérez', 'Gómez', '23456789C', 1500, 'Madrid', 'Madrid', 1, 'Masculino', TO_DATE('1980-05-10', 'YYYY-MM-DD'), 'Soltero');

INSERT INTO profesores (cod_profe, nombre, apellido1, apellido2, dni, salario, localidad, provincia, cod_colegio, Sexo, fecha_nac, estado_civil)
VALUES ('P002', 'María', 'González', 'Ruiz', '23456789B', 1400, 'Arenales', 'Alicante', 2, 'Femenino', TO_DATE('1985-03-20', 'YYYY-MM-DD'), 'Casada');

INSERT INTO profesores (cod_profe, nombre, apellido1, apellido2, dni, salario, localidad, provincia, cod_colegio, Sexo, fecha_nac, estado_civil)
VALUES ('P003', 'Carlos', 'Torres', 'López', '34567890C', 1600, 'Llobregat', 'Barcelona', 3, 'Masculino', TO_DATE('1978-08-15', 'YYYY-MM-DD'), 'Viudo');


-- Insertando a los tres alumnos con sus respectivos datos.

INSERT INTO alumnos (dni, nombre, apellidos, fecha_ingreso, fecha_nac, localidad, provincia, cod_colegio, Sexo, direccion, estado_civil)
VALUES ('123456789A', 'Ana Ortiz Ortega', 'Ortiz Ortega', TO_DATE('2025-04-03', 'YYYY-MM-DD'), TO_DATE('2005-04-12', 'YYYY-MM-DD'), 'Madrid', 'Madrid', 1, 'Femenino', 'Calle Falsa 123', 'Soltera');

INSERT INTO alumnos (dni, nombre, apellidos, fecha_ingreso, fecha_nac, localidad, provincia, cod_colegio, Sexo, direccion, estado_civil)
VALUES ('234567890B', 'Javier Chuko Palomo', 'Chuko Palomo', TO_DATE('2025-04-03', 'YYYY-MM-DD'), TO_DATE('2004-06-25', 'YYYY-MM-DD'), 'Arenales', 'Alicante', 2, 'Masculino', 'Avenida Sol 45', 'Soltero');

INSERT INTO alumnos (dni, nombre, apellidos, fecha_ingreso, fecha_nac, localidad, provincia, cod_colegio, Sexo, direccion, estado_civil)
VALUES ('345678901C', 'Miguel Torres Tormo', 'Torres Tormo', TO_DATE('2025-04-03', 'YYYY-MM-DD'), TO_DATE('2006-02-10', 'YYYY-MM-DD'), 'Llobregat', 'Barcelona', 3, 'Masculino', 'Carrer Major 88', 'Soltero');

-- Borrar la tabla Regiones.  
drop table regiones;

--
