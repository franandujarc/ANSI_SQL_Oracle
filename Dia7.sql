------------------ DIA 7 ------------------

---------- CREACION DE TABLAS-----------

create table prueba (
    identificador integer,
    texto10 varchar2(10),
    textchar char(5)
);
 
describe prueba;
 
insert into prueba values(1,'asdfghjklo','aeiou');
insert into prueba values(1,'A','4');
  
select * from prueba;

drop table prueba;

rollback;
-- AGREGAMOS NUEVA COLUMNA DE TIPO TEXTO LLAMADA NUEVA
alter table prueba
add(nueva varchar2(3));

-- DEBE DE SER NO NULL (NO PERMITE SI HAY REGISTROS)
alter table prueba
add(sinnulos varchar2(7)not null);

-- ELIMINAR COLUMNA
alter table prueba
drop column nueva;

-- MODIFICAR COLUMNAS SI HAY DATOS NO PERMITE (NULL NO CUENTA COMO DATO)
alter table prueba
modify (nueva float);


-- RENOMBRAR UNA TABLA

rename prueba to pruebarename;
rename pruebarename to prueba;
-- TRUNCATE ELIMINA TODOS LOS REGISTROS DE LA TABLA SIN BORRAR LA TABLA
-- ELIMINAR QUE LOS USUARIOS PUEDAN HACER TRUNCATE

truncate table prueba;

-- COMENTARIOS PARA UNA TABLA

comment on table prueba
is 'es una prueba de comentario';

-- VISUALIZARLO 
-- user solo las del usuario y all si eres super usuario.

select * from user_tab_comments where table_name = 'PRUEBA' ;
select * from all_tab_comments where table_name = 'PRUEBA' ;
select * from user_tables;
select * from all_tables;

-- BORRAR EL COMENTARIO
comment on table prueba
is '';

-- MOSTRAR TODOS LOS OBJETOS MIOS

select distinct object_type from user_objects ;

-- OBJETOS  MIOS DE USUARIO / DE SYSTEM
select * from cat;

-- VALOR POR DEFECTO
select * from prueba;

describe prueba;

alter table prueba
add(test int);

alter table prueba
add(defecto int default -1 );

insert into prueba
(identificador,texto10,textchar)
values
(2,'AA','AA');

insert into prueba
(identificador,texto10,textchar,defecto)
values
(3,'BB','B',22);

insert into prueba
(identificador,texto10,textchar,defecto)
values
(4,'CC','C',null);

-- CREAR RESTRICCIONES PRIMARY KEY
-- AÑADIR PRIMARY KEY A DEPT
alter table dept
add constraint pk_dept
primary key (dept_no);
-- TODAS LAS RESTRICCIONES DEL USUARIO SE ENCUENTRAR EN 'USER_CONSTRAINTS'
select * from USER_CONSTRAINTS;
select * from USER_CONSTRAINTS where constraint_name like 'PK%';

-- INSERTAR UN DEPERTAMENTO REPETIDO
insert into dept values(10,'repe','repe'); -- da error por repetir la clave de departamento
-- ELIMINAMOS LA RESTRICCIO DE PK DEL DEPT
alter table dept
drop constraint pk_dept;


-- PK PARA EMPLEADOS

alter table emp
add constraint pk_emp
primary key (emp_no);

-- CREAMOS UNA RESTRICCION PARA COMPROBAR EL SALARIO SIEMPRE SEA POSITIVO (CHECK)
alter table emp
add constraint ck_emp_salario
check (salario >= 0);

--AGREGAMOS VALOR NEGATIVO
insert into emp (emp_no,salario) values(123,-5);
update emp set salario = -1 where emp_no = 7782;

alter table emp
drop constraint ck_emp_salario;


select * from enfermo;
describe enfermo;
rollback;

-- Agregamos pk y unique a la table enfermos

alter table enfermo
add constraint pk_enfermo
primary key (inscripcion);

alter table enfermo
add constraint u_enfermo_nss
unique (nss);

insert into enfermo (inscripcion,nss) values(10995,280862481);
insert into enfermo (inscripcion,nss) values(10996,280862482);
insert into enfermo (inscripcion,nss) values(10995,280862482);
rollback;

-- pk doble

alter table enfermo
drop constraint pk_enfermo;

alter table enfermo
drop constraint u_enfermo_nss;

alter table enfermo
add constraint pk_enfermo
primary key (inscripcion,nss);

-- INSERTAR ENFERMO QUE SE REPITA POR INSCRIPCION Y NSS

INSERT INTO ENFERMO values(88999,'languia','goya','16/05/1956','M','280862484');

-- FOREIGN KEY
--CREAMOS RELACION ENTRE EMPLEADOS Y DEPARTAMENTOS

alter table emp
add constraint fk_dept_emp
foreign key (dept_no)
references dept (dept_no);

select * from emp;
describe emp;

insert into emp values(1111,'apellido1','oficio1',4352,'02/02/1999',1,1,null);
rollback;

--VAMOS A PORBR LA ELIMINACION EN CASCADA Y SET NULL EN CASCADA

delete from dept where dept_no=10;

alter table emp
drop constraint fk_dept_emp;

alter table emp
add constraint fk_dept_emp
foreign key (dept_no)
references dept (dept_no)
on delete cascade;
-------------------------------
alter table emp
add constraint fk_dept_emp
foreign key (dept_no)
references dept (dept_no)
on delete set null;

rollback;