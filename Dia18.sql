--------------- DIA 18 --------------------

--------- REGISTROS ---------------

DECLARE
    TYPE type_empleado is record(v_apellido VARCHAR2(50), v_oficio emp.oficio%type , v_salario number);
    v_tipo_empleado type_empleado;
BEGIN
    select apellido,oficio,salario into v_tipo_empleado.v_apellido,v_tipo_empleado.v_oficio,v_tipo_empleado.v_salario from emp where emp_no = 7839;

    DBMS_OUTPUT.PUT_LINE('APELLIDO: ' || v_tipo_empleado.v_apellido || ' ,OFICIO :'|| v_tipo_empleado.v_oficio || ' ,SALARIO :' || v_tipo_empleado.v_salario);

END;

create or replace package pk_variables
AS
    numero number;
END;

DECLARE
    numero pk_variables.numero;
BEGIN 
    numero := 100;
    DBMS_OUTPUT.PUT_LINE('numero:  ' || numero );
END;

-------------- ARRAYS -----------------
--- table  arrays dinamicos
declare
    -- un tipo array para numero
    type array_number is table of number index by BINARY_INTEGER;
    -- objeto con el tipo de dato array_number

    lista_numeros array_number;
BEGIN
    --almacenamos datos en su interior
    lista_numeros(1):= 88;
    lista_numeros(2):= 99;
    lista_numeros(3):= 222;

    DBMS_OUTPUT.PUT_LINE('numero de elementos ' || lista_numeros.count );

    for i in 1..lista_numeros.count LOOP

        DBMS_OUTPUT.PUT_LINE('NUMERO '|| i || ' = ' || lista_numeros(i) );
    end loop;
end;

-- almacenamos a la vez

-- guardamos un tipo fila de departamento

DECLARE
    type array_dept is table of dept%rowtype index by BINARY_INTEGER;
    lista_departamentos array_dept;
BEGIN
    select * into lista_departamentos(1) from dept where DEPT_NO=10;
    select * into lista_departamentos(2) from dept where DEPT_NO=20;
     for i in 1..lista_departamentos.count LOOP

        DBMS_OUTPUT.PUT_LINE('DNOMBRE: ' || lista_departamentos(i).dnombre||' ,LOCALIDAD: '|| lista_departamentos(i).loc );
    end loop;
END;
-- varrays estaticos y se inicializan
DECLARE
    CURSOR cursorempleados is select apellido from emp;
    type c_lista is varray (20) of emp.APELLIDO%TYPE;
    lista_empleados c_lista := c_lista();
    contador integer := 0;
BEGIN
    FOR empleado in cursorempleados LOOP
        contador := contador + 1;
        lista_empleados.extend; -- siempre se pone si se añade
        lista_empleados(contador):= empleado.apellido;
        DBMS_OUTPUT.PUT_LINE('EMPLEADO ( ' || contador || '):' ||lista_empleados(contador) );
    END LOOP;
END;

--------------------- TRIGERS -----------------------
-----INSERT
create or replace trigger tr_dept_before_insert
before INSERT
on dept
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before insert row');
    DBMS_OUTPUT.PUT_LINE('VENDRA SOLO NEW : '|| :new.dept_no || ' , '||:new.dnombre || ' , '||:new.loc);
END;

insert into dept values(111,'NUEVO','TOLEDO');

----- DELETE
create or replace trigger tr_dept_before_delete
before DELETE
on dept
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before delete row');
    DBMS_OUTPUT.PUT_LINE('SE BORRO : '|| :old.dept_no || ' , '||:old.dnombre || ' , '||:old.loc);
END;

delete from dept where dept_no = 111;

-- update

create or replace trigger tr_dept_before_update
before update
on dept
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before update row');
    DBMS_OUTPUT.PUT_LINE('ANTIGUA : '|| :old.dept_no || ' , '||:old.dnombre || ' , '||:old.loc);
    DBMS_OUTPUT.PUT_LINE('NUEVA : '|| :new.dept_no || ' , '||:new.dnombre || ' , '||:new.loc);
END;

update dept set loc = 'cambio' where dept_no =111;

--- control del doctor
create or replace trigger tr_doctor_control_salario_update
before update
on doctor
for each ROW
    WHEN(new.salario>250000)
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger doctor before update row');
    DBMS_OUTPUT.PUT_LINE('EL DOCTOR : '|| :old.apellido || ' ,COBRABA '||:old.salario);
    DBMS_OUTPUT.PUT_LINE('AHORA QUIERE COBRAR : '|| :new.salario || ' SE PASO DE COBRAR ');
END;

UPDATE doctor set salario = 125000 where doctor_no = 386;
--- no se puede tener 2 trigger del mismo tipo en la tabla

drop trigger tr_dept_before_insert;

create or replace trigger tr_dept_before_insert
before INSERT
on dept
for each ROW
    when(upper(:new.loc) = 'BARCELONA')
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger control barcelola before insert row');
    --if(upper(:new.loc) = 'BARCELONA')THEN
        DBMS_OUTPUT.PUT_LINE('NO SE ADMITEN DEPARTAMENTOS EN BARCELONA');
        RAISE_APPLICATION_ERROR(-20001, 'NO SE PERMITE EL BARCELONA');
    --END IF;
END;

insert into dept values(66,'MILAN','BARCELONA');

create or replace trigger tr_dept_control_localidades
before INSERT
on dept
for each ROW
DECLARE
    v_num number;
BEGIN
    select count(dept_no) into v_num from dept where upper(loc) = upper(:new.loc);
    if v_num > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'solo un departamento por ciudad');
    END IF;
END;
insert into dept values(6,'MILAN','TERUEL');