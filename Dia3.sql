-----------------DIA 3----------------------

-- EJERCICIOS
select * from emp where oficio = 'EMPLEADO';
-- 2º Encontrar el salario más alto, mas bajo y la diferencia entre ambos de todos los empleados con oficio EMPLEADO.
select  max(salario) as maximo,min(salario) as minimo,(max(salario)- min(salario)) as diferencia, oficio from emp group by oficio having oficio = 'EMPLEADO';

select * from emp ;
-- 4º Visualizar el número de personas que realizan cada oficio en cada departamento ordenado por departamento.
select dept_no,oficio,count(*) as numtrabajadores from emp group by oficio,dept_no order by dept_no;
-- 5º Buscar aquellos departamentos con cuatro o más personas trabajando.
select dept_no,count(*) as numtrabajadores from emp group by dept_no having count(*) >= 4 order by dept_no;

select * from plantilla ;
-- 7º Visualizar el número de enfermeros, enfermeras e interinos que hay en la plantilla, ordenados por la función.
select count(*),funcion from plantilla group by funcion  having funcion in('ENFERMERA','ENFERMERO','INTERINO') order by funcion;

select * from emp;
-- 8º Visualizar departamentos, oficios y número de personas, para aquellos departamentos que tengan dos o más personas trabajando en el mismo oficio.
select dept_no,oficio,count(*)as numtrabajadores from emp group by dept_no,oficio having count(*)>=2;

select * from sala;
-- 10º Calcular el valor medio de las camas que existen para cada nombre de sala. Indicar el nombre de cada sala y el número de cada una de ellas.
select sum(num_cama)as totalcamas, avg(num_cama) as mediacamas, nombre, count(*) as numsalas from sala group by nombre;


select * from plantilla;
-- 11º Calcular el salario medio de la plantilla de la sala 6, según la función que realizan. Indicar la función y el número de empleados.

select avg(salario)as salariomedio ,funcion,count(*) as numempleados from plantilla where sala_cod = 6 group by sala_cod,funcion ;

select * from emp;
-- 12º Averiguar los últimos empleados que se dieron de alta en la empresa en cada uno de los oficios, ordenados por la fecha.

select max(fecha_alt) AS FECHAMAXIMA, Oficio from emp group by oficio order by 1;

select * from enfermo;
-- 13º Mostrar el número de hombres y el número de mujeres que hay entre los enfermos.
select count(*) as numenfermos,sexo from enfermo group by sexo ;


select * from sala ;
-- 15º Calcular el número de salas que existen en cada hospital.

select hospital_cod,count(*)as numsalas from sala group by hospital_cod;

select * from plantilla;
-- 16º Mostrar el número de enfermeras que existan por cada sala.

select  sala_cod,count(*) as numenfermeras from plantilla where funcion= 'ENFERMERA' group by sala_cod ;


------------ TEORIA-----------------------

-- CONSULTAS DE CONBINACION

-- NOS PERMITEN MOSTRAR DATOS DE VARIAS TABLAS QUE DEBEN DE ESTAR RELACIONADAS ENTRE SI MEDIANTE ALGUNA CLAVE

-- 1º NECESITAMOS CAMPO/S RELACION ENTRE LAS TABLAS
-- 2º DEBEMOS PONER EL NOMBRE DE CADA TABLA Y DE CADA CAMPO EN LA CONSULTA

-- SINTAXIS:

-- select tabla1.campo1, tabla1.campo2, tabla2.campo1, tabla2.campo2 from tabla1 inner join tabla2 on tabla1.campo_relacion = tabla2.campo_relacion;
-- EJEMPLO (MOSTRAR EL APELLIDO, EL OFICIO DE LOS EMPLEADOS JUNTO AL NOMBRE DE DEPARTAMENTO Y LOCALIDAD )

select emp.apellido, emp.oficio , dept.dnombre, dept.loc from emp inner join dept on emp.dept_no = dept.dept_no;

-- DENTRO DE ORACLE TENEMOS OTRA SINTAXIS PARA LOS JOIN ( NO ES EFICIENTE ESTA CONSULTA)

select emp.apellido, emp.oficio , dept.dnombre, dept.loc from emp,dept where emp.dept_no = dept.dept_no;

-- PODEMOS REALIZAR, POR SUPUESTO NUESTROS WHERE

select emp.apellido, emp.oficio , dept.dnombre, dept.loc from emp inner join dept on emp.dept_no = dept.dept_no where dept.loc = 'MADRID';

-- NO ES OBLIGATORIO INCLUIR EL NOMBRE DE LA TABLA ANTES DEL CAMPO A MOSTRAR EN EL SELECT
-- PERO PERMITE SABER DE QUE TABLA VIENE Y SI UNA COLUMNA CON EL MISMO NOMBRE ROMPE POR AMBIGUO.

-- PERMITE INCLUIR ALIAS A LAS TABLAS
select e.apellido, e.oficio , d.dnombre, d.loc from emp e inner join dept d on e.dept_no = e.dept_no;

-- TENEMOS MULTIPLES TIPOS DE JOIN EN LAS BASES DE DATOS 

/*
        TIPOS DE JOIN  : 
    INNER JOIN   -> COMBINA LOS RESULTADOS DE LAS 2 TABLAS
    LEFT JOIN    -> COMBINA LAS 2 TABLAS Y TAMBIEN LA TABLA IZQUIERDA
    RIGHT JOIN   -> COMBINA LAS 2 TABLAS Y TAMBIEN LA TABLA DERECHA
    FULL JOIN    -> COMBINA LAS 2 TABLAS Y  FUERZA LAS 2 TABLAS
    CROSS JOIN   -> PRODUCTO CARTESIANO, COMBINA CADA DATO DE UNA TABLA CON LOS OTROS DATOS DE LA TABLA (NO USA ON)
   
*/


select distinct dept_no from emp;
select * from emp;

select e.apellido, e.oficio , d.dnombre, d.loc from emp e inner join dept d on e.dept_no = d.dept_no order by d.loc;

--INSERT INTO emp VALUES('1111', 'sin dept', 'EMPLEADO', 7919, TO_DATE('06-02-1995', 'DD-MM-YYYY'), 171000, 0, 50);

select e.apellido, d.dnombre, d.loc from emp e cross join dept d  order by d.loc;

-- EJEMPLO (MEDIA SALARIAL DE LOS DOCTORES POR HOSPITAL MOSTRANDO EL NOMBRE )

select * from doctor;
select * from hospital;

select avg(d.salario) as salariomedio, h.nombre from doctor d inner join hospital h on d.hospital_cod = h.hospital_cod  group by  h.nombre ;


-- EJEMPLO (MOSTRAR EL NUMERO DE EMPLEADOS QUE EXISTEN POR CADA LOCALIDAD )
select * from emp;
select * from dept;
select *  from emp e inner join dept d on e.dept_no = d.dept_no ;
select count(e.emp_no) as numeroempleados, d.loc from emp e inner join dept d on e.dept_no = d.dept_no  group by  d.loc;
