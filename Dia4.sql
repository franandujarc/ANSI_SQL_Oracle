---------------------DIA 4 ---------------------

------- SUBCONSULTAS -------------------------

-- SON CONSULTAS QUE NECESITAN DEL RESULTADO DE OTRA CONSULTA PARA PODER SER EJEUCTADAS, NO SON INDEPENDIENTES.
-- NO IMPORTA EL NIVEL DE ANIDAMIENTO DE SUBCONSULTAS , AUNQUE PUEDEN REALENTIZAR LA RESPUESTA
-- GENERAN BLOQUEOS DE CONSULTAS SELECT, LO QUE TAMBIEN REALENTIZA LAS RESPUESTAS

-- EJEMPLO (QUIERO VISUALIZAR LOS DATOS DEL EMPLEADO QUE MAS COBRA DE LA EMPRESA EMP)

select max(salario) from emp;
-- resultado 650000
select * from emp where salario=650000;

-- SE JUNTAN LAS DOS CONSULTAS A LA VEZ SE ANIDA EL RESULTADO DE UNA CONSULTA CON LA IGUALDAD DE OTRA CONSULTA
-- LAS SUBCONSULTAS VAN ENTRE PARENTESIS
select * from emp where salario=(select max(salario) from emp);

--EJEMPLO (MOSTRAR LOS EMPELADOS QUE TIENEN EL MISMO OFICIO QUE EMPLEADO GIL Y COBRE MENOS QUE JIMENEZ)

select * from emp where oficio = (select oficio from emp where apellido ='gil') and salario < (select salario from emp where apellido ='jimenez');

-- EJEMPLO (OSTRAR LOS EMPELADOS QUE TIENEN EL MISMO OFICIO QUE EMPLEADO GIL Y JIMENEZ

select * from emp where oficio in((select oficio from emp where apellido ='gil'), (select oficio from emp where apellido ='jimenez'));
-- SI UNA CONSULTA DEVUELVE MAS DE UN VALOR, SE UTILIZA EL OPERADOR IN
select * from emp where oficio in(select oficio from emp where apellido ='gil' or apellido ='jimenez');

-- MOSTRAR EL APELLIDO Y EL OFICIO EN LOS EMPLEADOS DEL DEPARTAMENTO DE MADRID .
-- SERIA INCORRECTA NUNCA USAR SUBCONSULTAS SI SE PUEDE RELACIONAR CON JOIN .

select apellido, oficio from emp where dept_no=
(select dept_no from dept where loc='MADRID');

select e.apellido, e.oficio from emp e inner join dept d on e.dept_no = d.dept_no where d.loc ='MADRID';

----------------------- CONSULTAS DE UNION -------------------
-- MUESTRAN , EN UN MISMO CURSOR, UN MISMO CONJUNTO DE RESULTADOS
-- ESTAS CONSULTAS SE UTILIZAN COMO CONCEPTO, NO COMO RELACION
-- DEBEMOS SEGUIR TRES NORMAS:
--  1º LA PRIMERA CONSULTA ES LA JEFA (RESPETA EL NOMBRE DE COLUMNA / ALIAS DE LA PRIMERA CONSULTA)
--  2º TODAS LAS CONSULTAS DEBEN TENER EL MISMO NUMERO DE COLUMNAS
--  3º TODAS LAS COLUMNAS DEBEN TENER MISMO TIPO DE DATO ENTRE SI

-- EN NUESTRA BASE DE DATOS, TENEMOS DATOS DE PERSONAS EN DIFERENTES TABLAS
-- EMP,PLANTILLA Y DOCTOR
-- CONSULTAS UNION USAR NUMERANDO 1,2,3, ... SI PONEMOS ALIAS NO FUNCIONA
select apellido, oficio ,salario  from emp
union
select apellido,funcion, salario  from plantilla
union
select apellido, especialidad, salario  from doctor order by 3;

-- SE PUEDE FILTRAR DATOS DE LA CONSULTA (MOSTRAR DATOS DE LAS PERSONAS QUE COBREN MENOS DE 300.000)
select apellido, oficio ,salario  from emp where salario < 300000
union
select apellido,funcion, salario  from plantilla where salario < 300000
union
select apellido, especialidad, salario  from doctor where salario < 300000
order by 3 desc;

-- UNION ELIMINA LOS RESULTADOS REPETIDOS 
-- SI QUEREMOS REPETIIDOS 'UNION ALL'

select apellido,oficio from emp 
union all
select apellido,oficio from emp;