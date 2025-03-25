select * from emp;
-- LA MEJOR PRAXIS ES UTILIZAR EL NOMBRE DE LOS CAMPOS
-- CONTROL + ENTER, EJECUTA LA LINEA EN LA QUE ESTEMOS
select APELLIDO, OFICIO, SALARIO from EMP;
--------------------- ORDER BY ---------------------------------

-- LA ORDENACION SIEMPRE ES ASCEDENTE (asc)
-- EL ORDER BY SIEMPRE SE ESCRIBE ALFINAL Y AFECTA AL SELECT
select * from emp order by apellido;

-- LA ORDENACION DESCENDENTE (desc)
select * from emp order by apellido desc;

-- ORDENAR POR MAS DE UN CAMPO SEPARANDOLO POR COMAS
select * from emp order by dept_no, oficio;


------------------------ FILTRADO DE REGISTROS --------------------
/* OPERACIONES DE COMPARACION: 
   IGUAL -> =
   MAYOR O IGUAL -> >=
   MENOR O IGUAL -> <=
   MAYOR -> >
   MENOR -> <
   DISTINTO -> <>
*/

-- ORACLE, POR DEFECTO, DIFERENCIA ENTRE MAYUSCULAS Y MINUSUCLAS ENSUS TEXTOS (STRING,VARCHAR)
-- TODO LO QUE NO SEA UN NUMERO SE ESCRIBE ENTRE COMILLAS SIMPLES ' ' 
-- PARA FILTRAR SE UTILIZA LA PALABRA 'WHERE' Y SE ESCRIBE SOLAMENTE UNA VEZ EN TODA LA CONSULTA Y SE ESCRIBE DESPUES DEL FROM

-- EJEMPLO (TODOS LOS EMPLEADOS DEL DEPARTAMENTO 10)
select * from emp where dept_no = 10;

-- EJEMPLO (TODOS LOS EMPLEADOS CUYO OFICIO SEA DIRECTOR (DIRECTOR EN MAYUSCULAS POR QUE TIENE KEYSENSITIVE))
select * from emp where oficio = 'DIRECTOR';

-- EJEMPLO (TODOS LOS EMPLEADOS CUYO OFICIO SEA DISTINTO DE DIRECTOR)
select * from emp where oficio <> 'DIRECTOR';
-- PERMITE COMO EN JAVA EL DISTINTO != PERO EL ESTANDAR DE ANSI SQL ES <>
select * from emp where oficio != 'DIRECTOR';

--------------- OPERADORES RELACIONALES -------------------

--PERMITE REALIZAR MAS DE UNA PREGUNTA DENTRO DE UNA MISMA CONSULTA
/*

   OR -> DEBE CUMPLIRSE UNA DE LAS 2 CONDICIONES
   AND -> DEBE CUMPLIRSE AMBAS CONDICIONES
   NOT -> NEGACION DE UNA CONDICION

*/

-- EJEMPLO (MOSTRAR LOS EMPLEADOS DEL DEPARTAMENTO 10 Y QUE TENGAN OFICIO DIRECTOR)

select * from emp where dept_no = 10 and oficio = 'DIRECTOR';
 -- or
select * from emp where dept_no = 10 or oficio = 'DIRECTOR';

-- EJEMPLO (MOSTRAR LOS EMPLEADOS DEL DEPARTAMENTO 10 Y DEL DEPARTAMENTO 20)
select * from emp where dept_no = 10 or dept_no = 20;

-------------- OPERADORES ADEMAS DE LOS ESTANDARS ------------------

/*

   BETWEEN -> MUESTRA UN RANGO ENTRE 2 DATOS, LOS 2 INCLUIDOS

*/
-- EJEMPLO (MOSTRAR LOS EMPLEADOS CON SALARIO ENTRE 251000 Y 390000)
select * from emp where salario between 251000 and 390000 order by salario;

-- LA CONSULTA ES IGUAL DE EFICIENTE CON OPERADORES

select * from emp where salario >= 251000 and salario <= 390000 order by salario;

-- EVITAR SIEMPRE LA NEGACION
-- EJEMPLO (MOSTRAR LOS EMPLEADOS QUE NO SEA DIRECTOR)
select * from emp where not oficio = 'DIRECTOR';
-- ES MAS EFICIENTE CON OPERADOR (HACE 2 CONSULTAS EN NOT , PRIMERO LOS QUE SON Y LUEGO TE DEVUELVEN LOS QUE NO)
select * from emp where oficio <> 'DIRECTOR';

--EXISTEN UN OPERADOR PARA BUSCAR COINCIDENCIAS EN TEXTOS 'LIKE'
-- NOS PERMITE, MEDIANTE CARACTERES ESPECIALES HACER FILTROS EN TEXTOS

/*
        CARACTERES ESPECIALES : 
    %   -> BUSCA CUALQUIER CARACTER Y LONGITUD
    _   -> 1 CARACTER CUALQUIERA
    ?   -> 1 CARACTER NUMERICO
*/

-- EJEMPLO (MOSTRAR LOS EMPLEADOS CUYO APELLIDO COMIENZA EN S )
select * from emp where apellido like 's%';
-- EJEMPLO (MOSTRAR LOS EMPLEADOS CUYO APELLIDO COMIENZA EN S FINALIZA EN A)
select * from emp where apellido like 's%a';
-- EJEMPLO (MOSTRAR LOS EMPLEADOS CUYO APELLIDO COMIENZA 4 LETRAS )
select * from emp where apellido like '____';

--EXISTE OTRO OPERADOR PAR ABUSCAR COINCIDENCIAS DE IGUALDAD DENTRO DE UNA MISMA TABLA

-- CAMPO in(valor1,valor2)

-- EJEMPLO (MOSTRAR LOS EMPLEADOS DEL DEPARTAMENTO 10 , DEL 20 y del 30 )
-- IGUAL DE EFICIENTES IN QUE CONCATENAR ORs
select * from emp where dept_no in(10,20,30);

-- CAMPO not in(valor1,valor2)DEVUELVE LOS QUE NO COINCIDEN
-- EJEMPLO (MOSTRAR LOS EMPLEADOS QUE NO ESTEN EN EL DEPARTAMENTO 10 , DEL 20 y del 30 )

select * from emp where dept_no not in(10,20);

------------------ CAMPOS CALCULADOS -----------------

-- UN CAMPO CALCULADO SIRVE PARA GENERAR CAMPOS QUE NO EXISTAN EN LA TABLA Y LOS PODEMOS CALCULAR

-- EJEMPLO (MOSTRAR EL APLLEIDO, EL SALARIO, COMISION Y EL TOTAL DE (SALARIO+COMISION) )

select apellido,salario,comision,(salario+comision) from emp;

--SIEMPTE DEBE DE TENER UN ALIAS  (AS)
-- UN CAMPO CALCULADO SOLAMENTE ES PARA EL CURSOR
select apellido,salario,comision,(salario+comision)as total from emp;

-- EJEMPLO (MOSTRAR EL APLLEIDO, EL SALARIO, COMISION Y EL TOTAL DE (SALARIO+COMISION) CUYO SALARIO SEA MAYOR 344500)

-- select apellido,salario,comision,(salario+comision)as total from emp where total >= 344500 ; NO FUNCIONA

select apellido,salario,comision,(salario+comision)as total from emp where (salario+comision) >= 344500 ;

-- ORDENAR POR UN CAMPO CALCULADO (FUNCIONA) 
-- LO DICHO ANTES ORDER BY FUNCIONA SOBRE EL SELECT SOBRE LOS DATOS MOSTRADOS PERO WHERE NO PUEDE POR QUE ES SOBRE LA TABLA Y EL ALIAS NO FUNCIONA
select apellido,salario,comision,(salario+comision)as total from emp order by total;

-- CLAUSULA DISTINC SE UTILIZA PARA EL SELECT Y LO QUE REALIZA ES ELIMINAR REPETIDOS DE LA CONSULTA

--EJEMPLO (MOSTRAR EL OFICIO DE LOS EMPLEADOS )

select distinct oficio from emp ;

/* EJERCICIOS */
 select * from enfermo;
--EJERCICIO 6 (Mostrar todos los enfermos nacidos antes del 11/01/1970.)
 select * from enfermo where fecha_nac <= '11/01/1970'  order by fecha_nac desc;
--EJERCICIO 7 (Igual que el anterior, para los nacidos antes del 1/1/1970 ordenados por número de inscripción.)
 select * from enfermo where fecha_nac <= '11/01/1970'  order by inscripcion ;
 
select * from plantilla;
--EJERCICIO 8 (Listar todos los datos de la plantilla del hospital del turno de mañana)
select * from plantilla where turno = 'M';
--EJERCICIO 9 (Idem del turno de noche..)
select * from plantilla where turno = 'N';

select * from doctor;
--EJERCICIO 10 (Listar los doctores que su salario anual supere 3.000.000 €.)
select * from doctor where (salario*12) > 3000000;

select (salario*12)as total from plantilla order by total;
--EJERCICIO 11 (Visualizar los empleados de la plantilla del turno de mañana que tengan un salario entre 200.000 y 250.000.)
select * from plantilla where (salario*12) between 200000 and 225000 and turno = 'M' order by salario;

select * from emp order by fecha_alt desc;
--EJERCICIO 12 (Visualizar los empleados de la tabla emp que no se dieron de alta entre el 01/01/1980 y el 12/12/1982.)
select * from emp where fecha_alt < '01/01/1980' or fecha_alt > '12/12/1982' ;

select * from dept;
--EJERCICIO 13 (Mostrar los nombres de los departamentos situados en Madrid o en Barcelona.)
select distinct dnombre from dept where loc in ('MADRID','BARCELONA');

--------------- CONSULTAR DE AGRUPACION ----------------
--ESTE TIPO DE CONSULTAS NO PERMITE MOSTRAR ALGUN RESUMEN DOBRE UN GRUPO DETERMINADO DE LOS DATOS.
-- UTILIZA FUNCIONES DE AGRUPACION PARA CONSEGUIR EL RESUMEN
-- LAS FUNCIONES DEBEN DE TENER ALIAS

/*
        FUNCIONES DE AGRUPACION  : 
    COUNT(*)        -> CUENTA EL NUMERO DE REGISTROS, INCLUYENDO NULOS
    COUNT(CAMPO)    -> CUENTA EL NUMERO DE REGISTROS SIN NULOS
    SUM(NUMERO)     -> SUMA EL TOTAL DE UN CAMPO NUMERO
    AVG(NUMERO)     -> RECUPERA LA MEDIA DE UN CAMPO NUMERICO
    MAX(CAMPO)      -> DEVUELVE EL VALOR MAXIMO DE UN CAMPO
    MIN(CAMPO)      -> DEVUELVE EL VALOR MINIMO DE UN CAMPO
*/

-- EJEMPLO (MOSTRAR EL NUMERO DE REGISTROS DE LA TABLA DOCTOR)

select count(*) as numdoc from doctor;
select count(apellido) as numdoc from doctor;

-- EJEMPLO (MOSTRAR EL NUMERO DE REGISTROS DE LA TABLA DOCTOR y el maximo de salario)

select count(*) as numdoc,max(salario) as maximo from doctor;

-- LOS DATOS RESULTANTES DE LAS FUNCIONES PODEMOS AGRUPARLOS POR ALGUN CAMPO/S DE LA TABLA
-- CUANDO QUEREMOS AGRUPAR USAMOS 'GROUP BY' DESPUES DEL FROM
-- TRUCO: DEBEMOS AGRUPAR POR CADA CAMPO QUE NO SEA UNA FUNCION

-- EJEMPLO (MOSTRAR DOCTORES EXISTEN POR CADA ESPECIALIDAD)

select count(*) as doctores,especialidad from doctor group by especialidad order by doctores;

-- EJEMPLO (MOSTRAR NUMERO DE PERSONAS Y MAXIMO SALARIO DE LOS EMPLEADO POR CADA DEPARTAMENTOY OFICIO)

select count(*) as personas, max(salario) as maximo_salario, dept_no, oficio from emp group by dept_no,oficio order by dept_no;

-- FILTRADO EN CONSUKLTAS DE AGRUPACION
-- TENEMOS DOS POSIBILIDADES
-- WHERE : ANTES DE GROUP BY Y PARA FILTRAR SOBRE LA TABLA
-- HAVING: DESPUES DE GROUP BY Y PARA FILTRAR SOBRE EL CONJUNTO

-- EJEMPLO (MOSTRAR CUANTOS EMPLEADOS TENEMOS POR CADA OFICIO QUE COBREN MAS DE 200.000)

select count(*) as empleados,oficio from emp where salario > 200000 group by oficio;

-- EJEMPLO (MOSTRAR CUANTOS EMPLEADOS TENEMOS POR CADA OFICIO Y QUE SEAN ANALISTAS O VENDEDORES)

select count(*) as empleados,oficio from emp group by oficio having oficio in('ANALISTA','VEDEDOR');

-- COMO OFICIO PERTENECE A LA TABLA PUEDE SER WHERE SE RECOMIENDA HAVING ES MAS RAPIDO EN GRANDES CANTIDADES

select count(*) as empleados,oficio from emp where oficio in('ANALISTA','VEDEDOR') group by oficio ;

-- EJEMPLO (MOSTRAR SOLAMENTE TENGAMOS 2 O MAS EMPLEADOS DEL MISMO OFICIO)
-- OBLIGADO A USAR HAVING (SI QUEREMOS FILTRAR POR UNA FUNCION DE AGRUPACION)
select count(*) as empleados,oficio from emp group by oficio having count(*) >=2 ;