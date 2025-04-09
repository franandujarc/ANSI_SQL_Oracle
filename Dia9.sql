-------------------- DIA 9 -------------------
-- MINISCULAS, MAYUSCULAS Y PRIMERA DE LA ORACION EN MAYUSCULAS Y EL RESTO EN MINUSCULAS

select * from emp where LOWER(oficio)='analista';

--ESTAMOS PONIENDO VALORES ESTATICOS: 'analista'
--PERO TAMBIE PODRIAMOS INCLUIR VALORES DINAMICOS, POR LO QUE TENDRIAMOS
--QUE CONVERTIR LAS DOS COMPARACIONES.

select * from emp where upper(oficio)=upper('&dato');

--EN ORACLE TENEMOS LA POSIBILIDAD DE CONCATENAR TEXTOS EN UNA SOLA COLUMNA (CAMPO CALCULADO)
-- SE UTILIZA EL SIMBOLO || PARA CONCATENAR
-- QUEREMOS MOSTRAR EN UNA SOLA COLUMNA EL APELLIDO Y OFICIO DE LOS EMPLEADOS
select apellido|| ' se dedica a ' || oficio as descripcionoficio from emp;

-- LA FUNCION INITCAP MUESTRA CADA PALABRA DE UNA FRASE CON LA PRIMERA LETRA EN MAYUSCULAS

select INITCAP (apellido|| ' se dedica a SER ' || oficio) as descripcionoficio from emp;
select INITCAP(apellido)|| LOWER(' se dedica a SER ') || LOWER(oficio) as descripcionoficio from emp;
-- CONCAT CONCATENA 2 STRING
select concat('nuestro empleado es ',apellido)as resultado from emp;

-- SUBSTR (CAD,X,N)RECUPERA UNA SUBCADENA DE UN TEXTO
-- EMPIEZA EN EL 1

select substr('florero',1,4) as dato from dual;
select substr('florero',2) as dato from dual; -- SI NO SE INDICA EL NUMERO HASTA EL FIN

-- mostrar los empleados cuyo apellido empiece por s

select * from emp where apellido like 's%';

-- mas eficiente que like
select *  from emp where substr(apellido,1,1) = 's';

select length('libro') as longitud from dual;

--mostrar los apellidos cuyo apellido sea de cuatro letras

select * from emp where apellido like '____';

select * from emp where length(apellido) = 4;

-- INSTR BUSCA UN TEXO Y DEVUELVE SU POSICION

select instr ( 'beninto' , 'n' ) as posicion from dual;


--si deseamos validar un mail

select * from dual where instr('m@ail','@') > 0;

-- LPAD INSERTA TANTOS CARACTERES HASTA LLEGAR A 5 POR LA IZQUIERDA
-- RPAD POR LA DERECHA
select * from emp;
select lpad(dept_no,4,'$') from emp;

---------------------- F. MATEMATICAS -----------------------

-- ROUND REDONDEA

select round(45.923) as redondeo from dual;
select round(45.928,1) as redondeo from dual;
select round(45.928,2) as redondeo from dual;
-- TRUNC TRUNCA
select TRUNC(45.923) as TRUNCA from dual;
select TRUNC(45.928,1) as TRUNCA from dual;
select TRUNC(45.928,2) as TRUNCA from dual;

-- MOD DEVUELVE EL RESTO DE LA DIVISION ENTRE 2 NUMEROS

select mod(23,5) as resto from dual;
select mod(78,2) as resto from dual; --par o impar

--mostrar empleados cuyo salario sea par

select * from emp where mod(salario,2) =0;

------------- FUNCIONES DE FECHA -------------------

-- TENEMOS UNA FUNCION PARA AVERIGUAR LA FECHA ACTUAL DE HOY EN EL SERVIDOR
--SYSDATe
select sysdate as fechactual from dual;
--SUMA NUMERO DE DIAS O RESTA
select sysdate + 10 as fecha from dual;
select sysdate + 53 as fecha from dual;
select sysdate - 10 as fecha from dual;

--MONTHS_BETWEEN(FECHA1,FECHA2) FECHA1 DEBE SER MAYOR , CUANTOS MESES HAY ENTRE 2 FECHAS

--MOSTRAR CUANTOS MESES LLEVAN LOS EMPLEADOS DE ALTA EN LA EMPRESA

select apellido, trunc(months_between(sysdate,fecha_alt)) as meses from emp;

-- ADD_MONTHS(FECHA1,N) AGREGA N MESES A LA FECHA QUE DIGAMOS

select add_months(sysdate + 53,5) as dentro5 from dual;

--NEXT_DAY AGREGA EL PROXIMO DIA

-- MOSTRAR CUANDO ES EL PROXIMO LUNES
select next_day(sysdate,'LUNES')as proximolunes from dual;
select next_day(sysdate,1)as proximolunes from dual;

-- LAST_DAY DEVUELVE EL ULTIMO DIA DEL MES

select last_day(sysdate) as findemes from dual;

-- ROUND puede redondear mm o yy 

--EMPLEADOS REDONDEADOS LA FECHA AL MES

select apellido,fecha_alt, round(fecha_alt,'MM') as roundmes from emp;

--EMPLEADOS REDONDEADOS LA FECHA AL AÑO
select apellido,fecha_alt, round(fecha_alt,'YY') as roundmes from emp;


-- TRUNC

--EMPLEADOS TRUNCA LA FECHA AL MES

select apellido,fecha_alt, trunc(fecha_alt,'MM') as roundmes from emp;

--EMPLEADOS TRUNCA LA FECHA AL AÑO
select apellido,fecha_alt, trunc(fecha_alt,'YY') as roundmes from emp;


------------- FUNCIONES DE CONVERSIÓN----------------

select apellido , fecha_alt from emp;
select apellido , to_char(fecha_alt, 'dd/mm/yyyy') from emp;
select apellido , to_char(fecha_alt, 'day / dd month yyyy') from emp;

select to_char(7458, '00000L')as tocharnumero from dual;

--- HORA DEL SISTEMA
select to_char(sysdate,'HH24:MI:SS')as horasistema from dual;

-- SI DESEAMOS INCLUIR TEXTO ENTRE TO_CHAR Y LOS FORMATOS SE REALIZA CON COMILLAS DOBLES " SOBRE LAS SIMPRES

select to_char (sysdate,'"hoy es" dd " de " month') as formato from dual;
select to_char (sysdate,'"hoy es" dd " de " month', 'nls_date_language = italian') as formato from dual;

select to_date('08/04/2025') + 10 as fecha from dual;

select to_number('55852')+20 as numero from dual;

select apellido , fecha_alt,to_char(fecha_alt,'HH24:MI:SS')as horafechaalta from emp;


----------- FUNCIONES GENERALES-------------------
--NVL SIRVE PARA EVITAR LOS LUNOS Y SUSTITUIRLOS
--SI ENCUENTRA UN NULO LO SUSTITUYE , SINO, MUESTRA EL VALOR


--MOSTRAR APELLIDO,SALARIO Y COMISION DE TODOS LOS EMPLEADOS

select apellido,salario , nvl(comision,-1)as comision from emp;

select apellido, nvl(salario,0) + nvl(comision,0) as total from emp;


--MOSTRAR EL TURNO EN PALABRA (MAÑANA,TARDE O NOCHE)DE LA PLANTILLA

select apellido, turno from plantilla;
select apellido, decode(turno,'M','MAÑANA','N','NOCHE','AQUI EL ELSE')as turno from plantilla; -- SI HAY UNO SOLO ALFINAL , ES EL ELSE

--QUIERO SABER LA FECHA DEL PROXIMO MIERCOLES QUE JUEGA EL MADRID

select next_day(sysdate+2,3)+2 as champions from dual;
-- quiero ver la fecha completa que no me entero



select to_char(next_day(sysdate+2,3),'"El" day dd "de" month "juega el madrid"') as champions from dual;






