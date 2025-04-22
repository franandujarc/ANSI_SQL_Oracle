------------ DIA 13 ----------------

-- INSERTAR 6 DEPARTAMENTOS EN UN BLOQUE PL/SQL DINAMICO

DECLARE
    v_nombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;
BEGIN

    FOR i in 1..5 LOOP
        v_nombre := 'Departamento '||i;
        v_loc := 'Localidad '||i;
        insert into dept values((select max(DEPT_NO)+1 from dept),v_nombre,v_loc);
    END LOOP;
    dbms_output.put_line('Fin del programa');
END;

-- realizar un bloque pl sql que pedira un numero al usuario y mostrara el departamento con dicho numero

DECLARE
    v_id dept.DEPT_NO%TYPE;
BEGIN
    v_id := &numero;

    select * from dept where dept_no = v_id;
END;

---------- CURSORES -----------------

--IMPLICITO (1 SOLA FILA)
-- RECUPERAR EL OFICIO DEL EMPLEDO REY
DECLARE
    v_oficio emp.OFICIO%TYPE;
BEGIN
    select oficio into v_oficio from emp where apellido ='rey';
    DBMS_OUTPUT.PUT_LINE('El oficio de rey es ' || v_oficio );
END;
-- RECUPERAR EL OFICIO DEL EMPLEDO REY Y SU SALARIO
DECLARE
    v_oficio emp.OFICIO%TYPE;
    v_salario emp.SALARIO%TYPE;
BEGIN
    select oficio,salario into v_oficio,v_salario from emp where apellido ='rey';
    DBMS_OUTPUT.PUT_LINE('El oficio de rey es ' || v_oficio || ' y cobra ' || v_salario);
END;

select * from emp;
rollback;

-- CURSOR EXPLICITO PUEDE DEVOLVER MAS DE 1 FILA Y ES NECESARIO DECLARLOS
-- MOSTRAR EL APELLIDO  Y EL SALARIO DE TODOS LOS EMPLEADOS
DECLARE
    v_apellido emp.APELLIDO%TYPE;
    v_salario emp.SALARIO%TYPE;
    cursor c_emp_apellido_salario is select apellido,salario from emp ;
BEGIN

    open c_emp_apellido_salario;

    LOOP
        fetch c_emp_apellido_salario into v_apellido,v_salario;
        EXIT WHEN c_emp_apellido_salario%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('El trabajador con apellido ' || v_apellido || ' cobra ' || v_salario );
    END LOOP;   

    close c_emp_apellido_salario;

END;

-- ATRIBUTO ROWCOUNT PARA LAS CONSULTAS DE ACCION
--INCREMENTAR EN 1 EL SALARIO DE LOS EMPLEADOS DEL DEPARTAMENTO 10
-- MOSTRAR EL NUMEOR DE EMPLEADOS MODIFICADOS
--SQL COGE LOS DATOS DE LA ULTIMA CONSULTA DE ACCION
BEGIN
    update emp set salario = salario + 1 where dept_no = 10;
    DBMS_OUTPUT.PUT_LINE('EMPLEADOS MODIFICADOS ' || SQL%ROWCOUNT );

END;

--INCREMENTAR EN 10000 AL EMPLEADO QUE MENOS COBRE EN LA EMPRESA
select * from emp;

BEGIN
    update emp set salario = salario + 10000 where salario = (select min(salario) from emp);
END;

DECLARE
    v_salario emp.SALARIO%TYPE;
BEGIN
    select min(salario) into v_salario from emp ;
    DBMS_OUTPUT.PUT_LINE('El trabajador que menos cobra es ' || v_salario);
    update emp set salario = salario + 10000 where salario =v_salario;
     DBMS_OUTPUT.PUT_LINE('EMPLEADOS MODIFICADOS ' || SQL%ROWCOUNT );
END;

-- pedir el numero ,nombre localidad de un departamento , si el departamento existe modificamos su nombre y localidad
--y si no existe lo insertamos. 

DECLARE
    v_dept_no dept.DEPT_NO%TYPE;
    v_dnombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;
    v_departamento_recuperado dept.DEPT_NO%TYPE;
    v_existe BOOLEAN:= false ;
    cursor cursordepartamento is select dept_no from dept;
    
BEGIN
    v_dept_no := &dato1;
    v_dnombre := '&dato2';
    v_loc := '&dato3';

    open cursordepartamento;

    LOOP
        FETCH cursordepartamento into v_departamento_recuperado;
        if (v_departamento_recuperado = v_dept_no) THEN 
            v_existe:=true;
        END IF;
        EXIT WHEN cursordepartamento%NOTFOUND;

    END LOOP;

    close cursordepartamento;

        if v_existe THEN 
            update dept set dnombre = v_dnombre, loc=v_loc  where dept_no =v_dept_no;
            DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO MODIFICADO ' || SQL%ROWCOUNT  );
        ELSE
            insert into dept values(v_dept_no,v_dnombre,v_loc);
            DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO INSERTADO ' ||  SQL%ROWCOUNT  );
        END IF;

END;
-- ALTERNATIVA 2 
DECLARE
    v_dept_no dept.DEPT_NO%TYPE;
    v_dnombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;
    cursor cursordepartamento is select dept_no from dept where dept_no = v_dept_no ;
    v_existe dept.DEPT_NO%TYPE;
    
BEGIN
    v_dept_no := &dato1;
    v_dnombre := '&dato2';
    v_loc := '&dato3';

    open cursordepartamento;
    FETCH cursordepartamento into v_existe;

    if cursordepartamento%FOUND THEN 
        update dept set dnombre = v_dnombre, loc=v_loc  where dept_no =v_dept_no;
        DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO MODIFICADO ' || SQL%ROWCOUNT  );
    ELSE
        insert into dept values(v_dept_no,v_dnombre,v_loc);
        DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO INSERTADO ' ||  SQL%ROWCOUNT  );
    END IF;

    close cursordepartamento;

END;
-- ALTERNATIVA 3 
DECLARE
    v_dept_no dept.DEPT_NO%TYPE;
    v_dnombre dept.DNOMBRE%TYPE;
    v_loc dept.LOC%TYPE;

    
BEGIN
    v_dept_no := &dato1;
    v_dnombre := '&dato2';
    v_loc := '&dato3';

    update dept set dnombre = v_dnombre, loc=v_loc  where dept_no =v_dept_no;
    --DBMS_OUTPUT.PUT_LINE('SQL%ROWCOUNT ' || SQL%ROWCOUNT );
    if SQL%ROWCOUNT = 0 THEN 
        insert into dept values(v_dept_no,v_dnombre,v_loc);
    END IF;
END;

select dept_no from dept;

-- realizar un codigo pl/sql para modificar el salario del empleado arroyo
--si el empleado cobra mas de 250.000 le bajamos en 10.000 y si no le subimos el sueldo en 10.000
select * from emp where apellido = 'arroyo';
DECLARE
    v_salario emp.SALARIO%TYPE;
BEGIN
    select salario into v_salario from emp where APELLIDO = 'arroyo';
    IF v_salario>250000 THEN
        UPDATE emp set salario = salario - 10000 where apellido = 'arroyo';
    ELSE
        UPDATE emp set salario = salario + 10000 where apellido = 'arroyo';
    END IF;
END;