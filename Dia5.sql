--------------- DIA 5 -------------------

-- SELECT TO SELECT 

-- ES UNA CONSULTA SOBRE UN CURSOR 
-- CUANDO HACEMOS UN SELECT EN REALIDAD ESTAMOS RECUPERANDO DATOS DE UNA TABLA
-- ESTE TIPO DE CONSULTA NOS PERMITE RECUPERAR DATOS DE UN SELECT YA REALIZADO
-- LOS WHERE SE HACEN SOBRE EL CURSOR
/*
-- SINTAXIS:
SELECT * FROM
(SELECT TABLA 1.CAMPO1 as ALIAS , TABLA1.CAMPO2 FROM TABLA1 
 UNION   
 SELECT TABLA 2.CAMPO1, TABLA2.CAMPO2 FROM TABLA2) CONSULTA
 WHERE CONSULTA.ALIAS ='VALOR';
 
 */
-- EJEMPLO (QUEREMOS MOSTRAR LOS DATOS DE TODAS LAS PERSONAS DE MI BBDD EMP,PLANTILLA,DOCTOR QUE COBREN MENOS DE 300000)
select apellido, oficio ,salario from
(select apellido, oficio ,salario  from emp
union
select apellido,funcion, salario  from plantilla 
union
select apellido, especialidad, salario  from doctor ) consulta where consulta.salario < 300000 order by consulta.salario desc;

-- CONSULTAS A NIVEL DE FILA

-- CONSULTAS CREADAS PARA DAR FORMATO A LA SALIDA DE DATOS.
-- NO MODIFICA LOS DATOS DE LA TABLA, LOS MUESTRAN DE OTRA FORMA SEGUN YO LO NECESITE
-- VAN CON PREGUNTASEN LA COSULTA
-- SINTAXIS:

/*
SELECT CAMPO 1,CAMPO 2, 
CASE CAMPO3 
 WHEN 'DATO1' THEN 'VALOR1'
 WHEN 'DATO2' THEN 'VALOR2'
 ELSE 'VALOR3'
END AS ALIAS FROM TABLA;

*/

select * from plantilla;

select apellido, funcion,
case turno 
when 'T' then 'TARDE'
when 'M' then 'MAÑANA'
when 'N' then 'NOCHE'
END AS TURNOMODIFICADO from plantilla;

-- EVALUAR POR UN OPERADOR (MAYOR , MENOR , DISTINTO, BEEWTEN)
/*
SELECT CAMPO 1,CAMPO 2, 
CASE  
 WHEN CAMPO3 <= 800 THEN 'VALOR1'
 WHEN  CAMPO3 > 800 THEN 'VALOR2'
 ELSE 'VALOR3'
END AS FORMATO FROM TABLA;

*/
select apellido, funcion,salario,case  
when salario >= 250000 then 'salario correcto'
when salario >= 170000 and salario < 250000 then 'MEDIA SALARIAL'
else 'BECARIO'
END AS rango_salarial
from plantilla;



select * from dept;
select * from emp;
-- MOSTRAR LA SUMA SALARIAL DE LOS EMPLEADOS POR SU NOMBRE DE DEPARTAMENTO.
select sum(e.salario) as sumasalarial, d.dnombre as nombredepartamento from emp e inner join dept d on e.dept_no = d.dept_no group by d.dnombre;

select * from plantilla;
select * from hospital;
-- MOSTRAR LA SUMA SALARIAL DE LOS DOCTORES POR SU HOSPITAL.
select sum(p.salario) as sumasalarial, h.nombre as nombrehospital from plantilla p inner join hospital h on p.hospital_cod = h.hospital_cod group by h.nombre;
-- ME GUSTARIA PODER VER TODO JUNTO E UNA MISMA COSULTA.
select sum(e.salario) as sumasalarial, d.dnombre as departamento_o_hospital from emp e inner join dept d on e.dept_no = d.dept_no group by d.dnombre
union
select sum(p.salario) as sumasalarial, h.nombre as nombrehospital from plantilla p inner join hospital h on p.hospital_cod = h.hospital_cod group by h.nombre;

-- CONSULTAS DE ACCION

-- CONSULTAS PARA MODIFICAR  LOS REGISTROS DE LA BASE DE DATOS
-- EN ORACLE, LAS CONSULTAS DE ACCION SON TRANSACCIONALES, ES DECIR, SE ALMACENAN DE FORMA TEMPORAL POR SESION.
-- PARA DESHACER LOS CAMBIOS O PARA HACERLOS PERMANENTES TENEMOS DOS PALABRAS.
-- COMMIT : HACE LOS CAMBIOS PERMANENTES.
-- ROLLBACK : DESHACE LOS CAMBIOS REALIZADOS.

--TENEMOS 3 TIPOS DE CONSULTAS DE ACCION
-- 1º INSERT (INSERTA UN NUEVO REGISTRO EN UNA TABLA)
-- 2º UPDATE (ACTUALIZA UNO O VARIOS REGISTROS DE UNA TABLA)
-- 3º DELETE (ELIMINA UNO O VARIOS REGISTROS DE UNA TABLA)

------------------------------------------------------------------------

-- INSERT 
-- CADA REGISTRO A INSERTAR ES UNA INSTRUCCION INSERT, ES DECIR , SI QUEREMOS INSERTAR 5 REGISTROS SON 5 INSERT.
-- TENEMOS DOS TIPOS DE SINTAXIS:
-- 1º INSERTAR TODOS LOS DATOS DE LA TABLA : debemos indicar todas las columnas/campos de la tabla y en el mismo orde de la propia tabla.
-- insert into tabla values (valor1,valor2,valor3,valo4,valor...);
select * from dept; 
--insert into dept VALUES(50,'ORACLE','BERNABEU');
--rollback;
insert into dept VALUES(50,'ORACLE','BERNABEU');
commit;
insert into dept VALUES(51,'ORACLE','BERNABEU2');
rollback;
-- 2º INSERTAR SOLAMENTE ALGUNOS DATOS DE LA TABLA: debemos indicar el nombre de las columnas que deseamos insertar y los valores iran en dicho orden
--, la tabla no tiene nada que ver
--insert into tabla (campo3,campo7) values (valor3,valor7);

insert into dept (dept_no,loc) values (100,'hola');
rollback;

-- LAS SUSBCONSULTAS SON SUPER UTILIES PARA LAS CONSULTAS DE ACCION

-- NECESITO UN DEPARTAMENTO DE SIDRA EN GIJON.
-- GENERAR EL SIGUIENTE NUMERO DISPONIBLE EN LA CONSULTA DE ACCION
insert into dept VALUES((select max(dept_no)+ 1 from dept),'SIDRA','GIJON');

-- DELETE 
-- ELIMINA UNA O VARIAS FILAS DE UNA TABLA .
-- SI NO EXISTE PARA ELIMINAR NO HACE NADA.
-- SINTAXIS:
-- delete from TABLA
-- LA SINTAXIS ANTERIOR ELIMINA TODO LOS REGISTROS DE LA TABLA.
-- OPCIONAL, INCLUIR WHERE

delete from dept where dept_no = 50;

-- UTILIZAR SUBCONSULTAR PARA DELETE

-- ELIMINAR TODO LOS EMPLEADOS DE GRANADA
select * from emp;
delete from emp where dept_no = 40 ;
delete from emp where dept_no = (select dept_no from dept where loc='GRANADA') ;

-- UPDATE
-- MODIFICA UNA O VARIAS FILAS DE UNA TABLA, PUEDE MODIFICAR VARIAS COLUMNAS A LA VEZ
-- SINTAXIS:
-- update tabla set campo1 = valor1, campo2=valor2
-- ESTA CONSULTA MODIFICA TODA LAS FILAS DE LA TABLA POR LO TANTO USAR WHERE.


--MODIFICAR EL SALARO DE LA PLANTILLA DEL TURNO DE NOCHE TODOS COBRARA 315.000

select * from plantilla ;
update plantilla set salario=315000 where turno = 'N';
rollback;

-- MODIFICAR LA CIUDAD Y EL NOMBRE DEL DEPARTAMENTO 10.
-- SE LLAMARA CUENTAS Y OS VAMOS A TOLEDO
update dept set dnombre='CUENTAS',loc='TOLEDO' where dept_no =10;
select * from dept;
rollback;

-- PODEMOS MANTENER EL VALOR DE UNA COLUMANA Y ASIGNAR "ALGO" CON OPERACIONES MATEMATICAS,
--INCREMENTAR EN 1 EL SALARIO DE TODOS LOS EMPLEADOS
update emp set salario = salario+1;
-- PODEMOS UTILIZAR SUBCONSULTAS ESTAN EN EL SET, SOLAMENTE DEBEN DEVOLVER UN DATO
-- ARROYO ESTA ENVIDIOSO DE SALA, PONER EL MISMO SALARIO A ARROYO QUE SALA
update emp set salario = (select salario from emp where apellido = 'sala') where apellido = 'arroyo';
-- LOS CATALANES ESTAN SUBIDOS Y LES BAJAMOS EL SUELDO A LA MITAD
update emp set salario= salario/2 where  dept_no = (select dept_no from dept where loc = 'BARCELONA');

------------------- EJERCICIOS 5 ---------------
select * from emp;
select * from dept;
select dept_no from dept where dnombre = 'PRODUCCIÓN';
--1º Dar de alta con fecha actual al empleado José Escriche Barrera como programador perteneciente al departamento de producción.  Tendrá un salario base de 70000 pts/mes y no cobrará comisión. 
insert into emp(apellido,fecha_alt,oficio,dept_no,salario,comision,emp_no) values ('José Escriche Barrera','31/03/2025','programador',(select dept_no from dept where dnombre = 'PRODUCCIÓN'),7000,0,1789);
--2º Se quiere dar de alta un departamento de informática situado en Fuenlabrada (Madrid).
insert into dept values((select max(dept_no)+10 from dept),'INFORMATICA','FUENLABRADA'); 
--3º El departamento de ventas, por motivos peseteros, se traslada a Teruel, realizar dicha modificación.
update dept set loc = 'TERUEL' where dnombre = 'VENTAS';
--4º En el departamento anterior (ventas), se dan de alta dos empleados: Julián Romeral y Luis Alonso. 
--Su salario base es el menor que cobre un empleado, y cobrarán una comisión del 15% de dicho salario.
insert into emp(apellido,salario,comision,emp_no) values('Julián Romeral',(select min(salario) from emp),(select min(salario)* 0.15 from emp),9542);
insert into emp(apellido,salario,comision,emp_no) values('Luis Alonso',(select min(salario) from emp),(select min(salario)* 0.15 from emp),7895);
--5º Modificar la comisión de los empleados de la empresa, de forma que todos tengan un incremento del 10% del salario.
update emp set salario = (salario *1.1) ;
--6º Incrementar un 5% el salario de los interinos de la plantilla que trabajen en el turno de noche.
select * from plantilla;
update plantilla set salario = salario * 1.05 where funcion = 'INTERINO' and turno ='N';

select * from emp;
--7º Incrementar en 5000 Pts. el salario de los empleados del departamento de ventas y del presidente,
--tomando en cuenta los que se dieron de alta antes que el presidente de la empresa.
update emp set salario = salario + 5000 where 
oficio = 'EMPLEADO'
and 
(
dept_no = (select dept_no from dept where dnombre = 'VENTAS')
or
dept_no = (select dept_no from emp where oficio = 'PRESIDENTE') 
)
and
fecha_alt < (select fecha_alt from emp where oficio = 'PRESIDENTE');

--8º El empleado Sanchez ha pasado por la derecha a un compañero.  
--Debe cobrar de comisión 12.000 ptas más que el empleado Arroyo y su sueldo se ha incrementado un 10% respecto a su compañero.
update emp set comision = comision + 12000, salario = ( select salario * 1.1 from emp where apellido = 'arroyo') where apellido = 'sanchez';

select * from hospital;
--9º Se tienen que desplazar cien camas del Hospital SAN CARLOS para un Hospital de Venezuela.  
--Actualizar el número de camas del Hospital SAN CARLOS.
update hospital set num_cama= num_cama - 100 where nombre = 'san carlos';

--10º Subir el salario y la comisión en 100000 pesetas y veinticinco mil pesetas respectivamente a los empleados 
--que se dieron de alta en este año.
update emp set salario = salario + 100000, comision = comision + 25000 where fecha_alt >= '01/01/2025';

select * from dept ;
--11º Ha llegado un nuevo doctor a la Paz.  Su apellido es House y su especialidad es Diagnostico.   
--Introducir el siguiente número de doctor disponible.
insert into doctor (hospital_cod,doctor_no,apellido,especialidad) values ((select hospital_cod from hospital where nombre = 'la paz'),(select max(doctor_no)+1 from doctor),'House','Diagnostico');
--12º Borrar todos los empleados dados de alta entre las fechas 01/01/80 y 31/12/82.
delete from emp where fecha_alt between '01/01/80' and '31/12/82';
--13º Modificar el salario de los empleados trabajen en la paz y estén destinados a Psiquiatría.  
--Subirles el sueldo 20000 Ptas. más que al señor Amigo R.
update plantilla set salario = salario + 20000 where hospital_cod = (select hospital_cod from hospital where nombre = 'la paz') and sala_cod ;
--14º Insertar un empleado con valores null (por ejemplo la comisión o el oficio), 
--y después borrarlo buscando como valor dicho valor null creado.
insert into emp values(1245,'apellidoprueba',null,8888,'01/01/2024',100999,null,20);
delete from emp where oficio is null and comision is null ;

--15º Borrar los empleados cuyo nombre de departamento sea producción.
delete from emp where dept_no = (select  dept_no from dept where dnombre = 'PRODUCCIÓN');

--16º Borrar todos los registros de la tabla Emp sin delete.

truncate table emp;
-- o 

drop table emp;

CREATE TABLE EMP
  (EMP_NO NUMBER(9)
  ,APELLIDO VARCHAR2(50)
  ,OFICIO VARCHAR2(50)
  ,DIR NUMBER(9)
  ,FECHA_ALT DATE
  ,SALARIO NUMBER(9)
  ,COMISION NUMBER(9)
  ,DEPT_NO NUMBER(9)
);

--17º Volver a ejecutar los SCRIPTS de BBDD para dejar la base de datos intacta para el siguiente módulo.
DROP TABLE DEPT;
DROP TABLE EMP;
DROP TABLE HOSPITAL;
DROP TABLE SALA;
DROP TABLE DOCTOR;
DROP TABLE PLANTILLA;
DROP TABLE ENFERMO;
DROP TABLE OCUPACION;

CREATE TABLE DEPT
  (DEPT_NO NUMBER(9)
  ,DNOMBRE VARCHAR2(50)
  ,LOC VARCHAR2(50)
);

CREATE TABLE EMP
  (EMP_NO NUMBER(9)
  ,APELLIDO VARCHAR2(50)
  ,OFICIO VARCHAR2(50)
  ,DIR NUMBER(9)
  ,FECHA_ALT DATE
  ,SALARIO NUMBER(9)
  ,COMISION NUMBER(9)
  ,DEPT_NO NUMBER(9)
);

CREATE TABLE HOSPITAL(
  HOSPITAL_COD NUMBER(9)
  ,NOMBRE VARCHAR2(50)
  ,DIRECCION VARCHAR2(100),
  TELEFONO VARCHAR2(9),
  NUM_CAMA NUMBER(9)
);

CREATE TABLE SALA(
  HOSPITAL_COD NUMBER(9)
  ,SALA_COD NUMBER(9)
  ,NOMBRE VARCHAR2(60)
  ,NUM_CAMA NUMBER(9)
);

CREATE TABLE DOCTOR(
  HOSPITAL_COD NUMBER(9)
  ,DOCTOR_NO NUMBER(9)
  ,APELLIDO VARCHAR2(60)
  ,ESPECIALIDAD VARCHAR2(60),
  SALARIO NUMBER(9)
);

CREATE TABLE PLANTILLA(
  HOSPITAL_COD NUMBER(9)
  ,SALA_COD NUMBER(9)
  ,EMPLEADO_NO NUMBER(9)
  ,APELLIDO VARCHAR2(60)
  ,FUNCION VARCHAR2(60)
  ,TURNO VARCHAR2(1)
  ,SALARIO NUMBER(9)
);

CREATE TABLE ENFERMO(
  INSCRIPCION NUMBER(9)
  ,APELLIDO VARCHAR2(60)
  ,DIRECCION VARCHAR2(100)
  ,FECHA_NAC DATE
  ,SEXO VARCHAR2(1)
  ,NSS NUMBER(9)
);

CREATE TABLE OCUPACION(
  INSCRIPCION NUMBER(9)
  ,HOSPITAL_COD NUMBER(9)
  ,SALA_COD NUMBER(9)
  ,CAMA NUMBER(9)
);

ALTER TABLE EMP
ADD CONSTRAINT PK_EMP
PRIMARY KEY (EMP_NO);

ALTER TABLE DEPT
ADD CONSTRAINT PK_DEPT
PRIMARY KEY (DEPT_NO);

ALTER TABLE HOSPITAL
ADD CONSTRAINT PK_HOSPITAL
PRIMARY KEY (HOSPITAL_COD);

ALTER TABLE DOCTOR
ADD CONSTRAINT PK_DOCTOR
PRIMARY KEY (DOCTOR_NO);

ALTER TABLE PLANTILLA
ADD CONSTRAINT PK_PLANTILLA
PRIMARY KEY (EMPLEADO_NO);

ALTER TABLE ENFERMO
ADD CONSTRAINT PK_ENFERMO
PRIMARY KEY (INSCRIPCION);

insert into hospital values(19,'provincial','o donell 50','964-4264',502);
insert into hospital values(18,'general','Atocha s/n','595-3111',987);
insert into hospital values(22,'la paz','castellana 1000','923-5411',412);
insert into hospital values(45,'san carlos','ciudad universitaria','597-1500',845);
insert into hospital values(17,'ruber','juan bravo 49','914027100',217);
/
insert into sala values(19,3,'cuidados intensivos',21);
insert into sala values(19,6,'psiquiatria',67);
insert into sala values(18,3,'cuidados intensivos',10);
insert into sala values(18,4,'cardiologia',53);
insert into sala values(22,1,'recuperacion',10);
insert into sala values(22,6,'psiquiatria',118);
insert into sala values(22,2,'maternidad',34);
insert into sala values(45,4,'cardiologia',55);
insert into sala values(45,1,'recuperacion',17);
insert into sala values(45,2,'maternidad',24);
insert into sala values(17,2,'maternidad',19);
insert into sala values(17,6,'psiquiatria',20);
insert into sala values(17,3,'cuidados intensivos',21);
/
insert into plantilla values(19,6,3754,'diaz b.','ENFERMERO','T',226200);
insert into plantilla values(19,6,3106,'hernandez j.','ENFERMERO','T',275500);
insert into plantilla values(18,4,6357,'karplus w.','INTERINO','T',337900);
insert into plantilla values(22,6,1009,'higueras d.','ENFERMERA','T',200500);
insert into plantilla values(22,6,8422,'bocina g.','ENFERMERO','M',163800);
insert into plantilla values(22,2,9901,'nuñez c.','INTERINO','M',221000);
insert into plantilla values(22,1,6065,'rivera g.','ENFERMERA','N',162600);
insert into plantilla values(22,1,7379,'carlos r.','ENFERMERA','T',211900);
insert into plantilla values(45,4,1280,'amigo r.','INTERINO','N',221000);
insert into plantilla values(45,1,8526,'frank h.','ENFERMERO','T',252200);
insert into plantilla values(17,2,8519,'chuko c.','ENFERMERO','T',252200);
insert into plantilla values(17,6,8520,'palomo c.','INTERINO','M',219210);
insert into plantilla values(17,6,8521,'cortes v.','ENFERMERA','N',221200);

/
insert into doctor values(19,435,'Lopez A.','Cardiologia',350000);
insert into doctor values(18,585,'Miller G.','Ginecologia',250000);
insert into doctor values(18,982,'Cajal R','Cardiologia',290000);
insert into doctor values(22,453,'Galo C.','Pediatria',250000);
insert into doctor values(22,398,'Best K.','Urologia',150000);
insert into doctor values(22,386,'Cabeza D.','Psiquiatria',125000);
insert into doctor values(45,607,'Niqo P.','Pediatria',240000);
insert into doctor values(45,522,'Adams C.','Neurologia',450000);
insert into doctor values(17,521,'Nino P.','Neurologia',390000);
insert into doctor values(17,120,'Curro F.','Urologia',250000);
/
INSERT INTO ENFERMO VALUES(10995, 'Languia M.', 'Goya 20', TO_DATE('16-05-1956', 'DD-MM-YYYY'), 'M', 280862482);
INSERT INTO ENFERMO VALUES(18004, 'Serrano V.', 'Alcala 12', TO_DATE('21-05-1960', 'DD-MM-YYYY'), 'F', 284991452);
INSERT INTO ENFERMO VALUES(14024, 'Fernandez N.', 'Recoletos 5', TO_DATE('23-07-1967', 'DD-MM-YYYY'), 'F', 321790059);
INSERT INTO ENFERMO VALUES(36658, 'Domin S.', 'Mayor 71', TO_DATE('01-01-1942', 'DD-MM-YYYY'), 'M', 160657471);
INSERT INTO ENFERMO VALUES(38702, 'Neal R.', 'Orense 21', TO_DATE('18-07-1940', 'DD-MM-YYYY'), 'F', 380010217);
INSERT INTO ENFERMO VALUES(39217, 'Cervantes M.', 'Perón 38', TO_DATE('29-02-1952', 'DD-MM-YYYY'), 'M', 440294390);
INSERT INTO ENFERMO VALUES(59076, 'Miller G.', 'Lopez de Hoyos 2', TO_DATE('16-09-1945', 'DD-MM-YYYY'), 'F', 311969044);
INSERT INTO ENFERMO VALUES(63827, 'Ruiz P.', 'Esquerdo 103', TO_DATE('26-12-1980', 'DD-MM-YYYY'), 'M', 200973253);
INSERT INTO ENFERMO VALUES(64882, 'Fraser A.', 'Soto 3', TO_DATE('10-07-1980', 'DD-MM-YYYY'), 'F', 285201776);
INSERT INTO ENFERMO VALUES(74835, 'Benitez E.', 'Argentina 5', TO_DATE('05-10-1956', 'DD-MM-YYYY'), 'M', 154811767);
/
INSERT INTO OCUPACION VALUES(10995,19,6,1);
INSERT INTO OCUPACION VALUES(18004,19,3,2);
INSERT INTO OCUPACION VALUES(14024,19,6,3);
INSERT INTO OCUPACION VALUES(36658,18,4,1);
INSERT INTO OCUPACION VALUES(38702,18,4,2);
INSERT INTO OCUPACION VALUES(39217,22,1,1);
INSERT INTO OCUPACION VALUES(59076,22,6,2);
INSERT INTO OCUPACION VALUES(63827,22,6,3);
INSERT INTO OCUPACION VALUES(64882,22,2,1);
/
insert into dept values(10,'CONTABILIDAD','SEVILLA');
insert into dept values(20,'INVESTIGACIÓN','MADRID');
insert into dept values(30,'VENTAS','BARCELONA');
insert into dept values(40,'PRODUCCIÓN','GRANADA');
/
INSERT INTO emp VALUES('7839', 'rey', 'PRESIDENTE', NULL, TO_DATE('17-11-1995', 'DD-MM-YYYY'), 650000, NULL, 10);
INSERT INTO emp VALUES('7698', 'negro', 'DIRECTOR', 7839, TO_DATE('01-05-1995', 'DD-MM-YYYY'), 370500, 0, 30);
INSERT INTO emp VALUES('7566', 'jimenez', 'DIRECTOR', 7839, TO_DATE('02-04-1995', 'DD-MM-YYYY'), 386750, 0, 20);
INSERT INTO emp VALUES('7782', 'cerezo', 'DIRECTOR', 7839, TO_DATE('09-06-1995', 'DD-MM-YYYY'), 318500, 0, 10);
INSERT INTO emp VALUES('7499', 'arroyo', 'VENDEDOR', 7698, TO_DATE('20-02-1994', 'DD-MM-YYYY'), 208000, 39000, 30);
INSERT INTO emp VALUES('7521', 'sala', 'VENDEDOR', 7698, TO_DATE('22-02-1995', 'DD-MM-YYYY'), 162500, 65000, 30);
INSERT INTO emp VALUES('7654', 'martin', 'VENDEDOR', 7698, TO_DATE('29-07-1995', 'DD-MM-YYYY'), 162500, 182000, 30);
INSERT INTO emp VALUES('7844', 'tovar', 'VENDEDOR', 7698, TO_DATE('08-07-1995', 'DD-MM-YYYY'), 195000, 0, 30);
INSERT INTO emp VALUES('7900', 'jimeno', 'EMPLEADO', 7698, TO_DATE('03-12-1995', 'DD-MM-YYYY'), 123500, 0, 30);
INSERT INTO emp VALUES('7902', 'fernandez', 'ANALISTA', 7566, TO_DATE('03-12-1995', 'DD-MM-YYYY'), 390000, 0, 20);
INSERT INTO emp VALUES('7788', 'gil', 'ANALISTA', 7566, TO_DATE('09-11-1995', 'DD-MM-YYYY'), 390000, 0, 20);
INSERT INTO emp VALUES('7369', 'sanchez', 'EMPLEADO', 7902, TO_DATE('17-12-1994', 'DD-MM-YYYY'), 104000, 0, 20);
INSERT INTO emp VALUES('7876', 'alonso', 'EMPLEADO', 7788, TO_DATE('23-07-1995', 'DD-MM-YYYY'), 143000, 0, 20);
INSERT INTO emp VALUES('7934', 'muñoz', 'EMPLEADO', 7782, TO_DATE('23-01-1996', 'DD-MM-YYYY'), 169000, 0, 10);
INSERT INTO emp VALUES('7919', 'serra', 'DIRECTOR', 7839, TO_DATE('11-12-1997', 'DD-MM-YYYY'), 395000, 0, 20);
INSERT INTO emp VALUES('7907', 'campayo', 'ANALISTA', 7919, TO_DATE('04-06-1994', 'DD-MM-YYYY'), 251000, 25000, 20);
INSERT INTO emp VALUES('7917', 'nino', 'VENDEDOR', 7919, TO_DATE('06-02-1995', 'DD-MM-YYYY'), 171000, 0, 20);
INSERT INTO emp VALUES('7904', 'ford', 'EMPLEADO', 7907, TO_DATE('04-04-1996', 'DD-MM-YYYY'), 162500, 0, 20);
INSERT INTO emp VALUES('7914', 'gutierrez', 'ANALISTA', 7919, TO_DATE('20-10-1986', 'DD-MM-YYYY'), 258500, 50000, 20);
commit;
