---------- DIA 15 --------------
-- CAPTURAR EXCEPCIONES
-- CAPTURAR LA EXCEPCION DEL SISTEMA DIVIDIR ENTRE CERO
DECLARE
    v_numero1 number :=&dato1;
    v_numero2 number :=&dato2;
    v_division number;
BEGIN
    v_division := v_numero1/v_numero2;
    DBMS_OUTPUT.PUT_LINE('La division es: ' ||v_division);

EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR AL DIVIDIR ENTRE 0 ');
END;
undefine dato1;
undefine dato2;

-- LANZAREMOS UNA EXCEPCION TENDREMOS UNA TABLA DONDE ALMACENAREMOS EMPLEADO CON COMISION MAYOR A CERO
create table emp_comision(apellido varchar2(50),comision number(9));
select * from emp_comision;
DECLARE
    cursor cursor_emp is select apellido, comision from emp order by comision desc;
    exception_comision exception;
BEGIN
    FOR v_record in cursor_emp LOOP
        insert into emp_comision values(v_record.apellido,v_record.comision);
        IF(v_record.comision = 0) THEN
            --DBMS_OUTPUT.PUT_LINE('APELLIDO ' || v_record.apellido || ', COMISION ' || v_record.comision);
            raise exception_comision;
        END IF;
    END LOOP;
EXCEPTION
    WHEN exception_comision THEN
        DBMS_OUTPUT.PUT_LINE('ERROR exception_comision ');
END;

select apellido, comision from emp order by comision desc;

-- PRAGMA EXCEPTION_INIT
describe dept;
DECLARE
    exceptions_nulos EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptions_nulos,-1400);
BEGIN
    insert into dept values(null,'DEPARTAMENTO','PRAGMA');
EXCEPTION
    WHEN exceptions_nulos then
    DBMS_OUTPUT.PUT_LINE('ERROR exceptions_nulos ');

END;

-- OTHERS

DECLARE
    v_id number;
BEGIN
    select dept_no into v_id from dept where upper(dnombre) ='BENTAS';
    DBMS_OUTPUT.PUT_LINE('ventas es el numero ' || v_id );
EXCEPTION
    WHEN TOO_MANY_ROWS then
        DBMS_OUTPUT.PUT_LINE('DEMASIADAS FILAS EN CURSOR');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Codigo de sqlcode  :'||to_char(SQLCODE) || ' DESCRIPCION DEL ERROR ' || SQLERRM);

END;

--RAISE_APPLICATION_ERROR (20000 - 20999)

DECLARE
    v_id number;
BEGIN
    RAISE_APPLICATION_ERROR(-20400, 'puedo hacer esto con excepcion');
    select dept_no into v_id from dept where upper(dnombre) ='BENTAS';
    DBMS_OUTPUT.PUT_LINE('ventas es el numero ' || v_id );
/*
EXCEPTION
  WHEN TOO_MANY_ROWS then
        DBMS_OUTPUT.PUT_LINE('DEMASIADAS FILAS EN CURSOR');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Codigo de sqlcode  :'||to_char(SQLCODE) || ' DESCRIPCION DEL ERROR ' || SQLERRM);*/

END;

------ PROCEDIMIENTOS ALMACEADOS ------------

-- CREATE dura 1 sesion

-- CREATE OR REPLACE es persistente

-- EJEMPLO PROCEDIMIETO PARA MOSTRAR UN MENSAJE
-- STORE PROCEDURE (SP)
CREATE OR REPLACE PROCEDURE sp_mensaje
as 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hoy es juernes con musica!!');
    SYS.DBMS_OUTPUT.PUT_LINE(' sys Hoy es juernes con musica!!');
END;

-- LLAMADAS AL PROCEDIMIENTO
exec SP_MENSAJE;

BEGIN
    SP_MENSAJE;
END;

CREATE OR REPLACE PROCEDURE sp_ejemplo_plsql
as
BEGIN
    DECLARE
        v_numero number:=14;
    BEGIN
        IF (v_numero>0) THEN
            DBMS_OUTPUT.PUT_LINE('POSITIVO');
        ELSE
            DBMS_OUTPUT.PUT_LINE('NEGATIVO');
        END IF;
    END;
END;


-- tenemos otra sintaxis para tener variables dentro de un procedimiento.
-- no se usa la palabra declare.

create or replace procedure sp_ejemplo_plsql2
AS
    v_numero number:=14;
BEGIN
    IF (v_numero>0) THEN
        DBMS_OUTPUT.PUT_LINE('POSITIVO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NEGATIVO');
    END IF;
END;

-- PARAMETROS

create or replace procedure sp_ejemplo_plsql4_sumar_numeros(numero number,numero2 number)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('La suma del numero ' || numero || ' y el numero ' || numero2 || ' es ' || (numero + numero2));
END;


-- procedimiento para dividir 2 numeros se llamara sp_dividir_numeros

create or replace procedure sp_dividir_numeros(numero number,numero2 number)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('La division de ' || numero || ' / ' || numero2 || ' es ' || (numero / numero2));
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR AL DIVIDIR ENTRE 0 ');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('La division no puedo llevarse a cabo Cod_error: '|| to_char(SQLCODE) || ' , motivo : '|| SQLERRM);

END;

BEGIN
    sp_dividir_numeros(10.4,'5');
end;