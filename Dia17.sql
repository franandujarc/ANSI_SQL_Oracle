----------------PAQUETES-----------------
create or replace package pk_ejemplo
AS
    -- en el header solamente se incluyen las declaraciones
    procedure mostrarmensaje;
END;

create or replace package body pk_ejemplo
AS
    -- en el header solamente se incluyen las declaraciones
    procedure mostrarmensaje
    as
    BEGIN
        DBMS_OUTPUT.PUT_LINE('SOY UN PAQUETE');
    END mostrarmensaje;
END pk_ejemplo;

--vamos a realizar un paquete contenga acciones de eliminar sobre emp dept doctor enfermo

create or replace package pk_delete
AS
    procedure eliminarempleado(p_empno emp.emp_no%type);
    procedure eliminardepartamento(p_deptno dept.dept_no%type);
    procedure eliminardoctor(p_doctorno doctor.doctor_no%type);
    procedure eliminarenfermo(p_inscripcion enfermo.inscripcion%type);
end pk_delete;



create or replace package body pk_delete
AS
    procedure eliminarempleado(p_empno emp.emp_no%type)
    as
    BEGIN
        delete from emp where EMP_NO=p_empno;
        commit;
    end eliminarempleado;

    procedure eliminardepartamento(p_deptno dept.dept_no%type)
    as
    BEGIN
        delete from dept where dept_no = p_deptno;
        commit;
    end eliminardepartamento;

    procedure eliminardoctor(p_doctorno doctor.doctor_no%type)
    as
    BEGIN
        delete from DOCTOR where doctor_no = p_doctorno;
        commit;

    end eliminardoctor;

    procedure eliminarenfermo(p_inscripcion enfermo.inscripcion%type)
    as
    BEGIN
        delete from enfermo where inscripcion = p_inscripcion;
        commit;
    end eliminarenfermo;

end pk_delete;

BEGIN
    PK_DELETE.HOLAMUNDO;
end;

create or replace package pk_empleados_salarios
AS
    function salario_maximo return number;
    function salario_minimo return number;
    function salario_medio return number;
end;

create or replace package body pk_empleados_salarios
AS
    function salario_maximo return number
    as
        v_maximo number;
    BEGIN
        select max(salario) into v_maximo from emp;
        return v_maximo;

    end salario_maximo;

    function salario_minimo return number
    AS
        v_minimo number;
    BEGIN
        select min(salario) into v_minimo from emp;
        return v_minimo;
    END salario_minimo;

    function salario_medio return number
    as
        v_medio number;
    BEGIN
        v_medio:= salario_maximo-salario_minimo;
        return v_medio;
    END salario_medio;
end;

select pk_empleados_salarios.SALARIO_MAXIMO as maximo, PK_EMPLEADOS_SALARIOS.SALARIO_MINIMO as minimo , pk_empleados_salarios.SALARIO_MEDIO as medio from dual;

-- necesito un paquete para realizar update, insert y delete sobre departamentos 
-- pk_departamentos

select * from dept;

CREATE OR REPLACE PACKAGE pk_departamentos AS
    PROCEDURE insertar(
        p_dept     dept.dept_no%TYPE := 0,
        p_dnombre  dept.dnombre%TYPE := 'default',
        p_loc      dept.loc%TYPE := 'default'
    );

    PROCEDURE borrar(
        p_campo   VARCHAR2,
        p_cambio  VARCHAR2
    );

    PROCEDURE actualizar(
        p_campo   VARCHAR2,
        p_valor   VARCHAR2,
        p_filtro  VARCHAR2
    );
END pk_departamentos;


CREATE OR REPLACE PACKAGE BODY pk_departamentos AS

    PROCEDURE insertar(
        p_dept     dept.dept_no%TYPE,
        p_dnombre  dept.dnombre%TYPE,
        p_loc      dept.loc%TYPE
    ) AS
        v_departamento dept.dept_no%TYPE := p_dept;
    BEGIN
        IF v_departamento = 0 THEN
            SELECT NVL(MAX(dept_no), 0) + 10 INTO v_departamento FROM dept;
        END IF;

        INSERT INTO dept (dept_no, dnombre, loc)
        VALUES (v_departamento, p_dnombre, p_loc);
    END insertar;

    PROCEDURE borrar(
        p_campo   VARCHAR2,
        p_cambio  VARCHAR2
    ) AS
        v_sql VARCHAR2(1000);
    BEGIN
        IF UPPER(p_campo) NOT IN ('DEPT_NO', 'DNOMBRE', 'LOC') THEN
            RAISE_APPLICATION_ERROR(-20001, 'Campo no permitido.');
        END IF;

        -- Si es número (DEPT_NO), no se necesitan comillas
        IF UPPER(p_campo) = 'DEPT_NO' THEN
            v_sql := 'DELETE FROM dept WHERE ' || p_campo || ' = ' || p_cambio;
        ELSE
            v_sql := 'DELETE FROM dept WHERE ' || p_campo || ' = ''' || p_cambio || '''';
        END IF;

        EXECUTE IMMEDIATE v_sql;
    END borrar;

    PROCEDURE actualizar(
        p_campo   VARCHAR2,
        p_valor   VARCHAR2,
        p_filtro  VARCHAR2
    ) AS
        v_sql VARCHAR2(1000);
    BEGIN
        IF UPPER(p_campo) NOT IN ('DEPT_NO', 'DNOMBRE', 'LOC') THEN
            RAISE_APPLICATION_ERROR(-20002, 'Campo a actualizar no permitido.');
        END IF;

        -- Solo como ejemplo, aplicamos el filtro sobre DEPT_NO
        v_sql := 'UPDATE dept SET ' || p_campo || ' = ';

        IF UPPER(p_campo) = 'DEPT_NO' THEN
            v_sql := v_sql || p_valor;
        ELSE
            v_sql := v_sql || '''' || p_valor || '''';
        END IF;

        -- Supongamos que el filtro es siempre por DEPT_NO
        v_sql := v_sql || ' WHERE DEPT_NO = ' || p_filtro;

        EXECUTE IMMEDIATE v_sql;
    END actualizar;

END pk_departamentos;

-- NECESITO UNA FUNCIONALIDAD QUE NOS DEVUELVA EL APELLIDO ,EL TRABAJA,SALARIO Y LUGAR DE TRABAJO de todas las personas de nuestra bbdd
-- y otra dependiendo del salario

create or replace view V_UNION_EMP_DOC_PLANTILLA
AS
select e.apellido, e.oficio ,e.salario,d.dnombre from emp e natural join dept d
union
select p.apellido,p.funcion, p.salario,h.NOMBRE  from plantilla p natural join hospital h
union
select d.apellido, d.especialidad, d.salario , h.NOMBRE  from doctor d natural join hospital h
order by 3 desc;

select * from V_UNION_EMP_DOC_PLANTILLA;

CREATE OR REPLACE PACKAGE pk_union_empleados
as
    procedure devolver_all_empleados;
    procedure devolver_all_empleados_salario_mayorde(salarioRecibido number);
END;

CREATE OR REPLACE PACKAGE body pk_union_empleados
as
    procedure devolver_all_empleados
    AS
        cursor cursor_union is select * from V_UNION_EMP_DOC_PLANTILLA;
    BEGIN
        FOR v_fila in cursor_union LOOP
          DBMS_OUTPUT.PUT_LINE('APELLIDO: ' || v_fila.apellido || ', OFICIO: ' || v_fila.oficio || ', DNOMBRE: ' || v_fila.dnombre || ', SALARIO: ' || v_fila.salario );
        END LOOP;
    END;
    procedure devolver_all_empleados_salario_mayorde(salarioRecibido number)
    as
        cursor cursor_union is select * from V_UNION_EMP_DOC_PLANTILLA where salario > salarioRecibido ;
    BEGIN
        FOR v_fila in cursor_union LOOP
          DBMS_OUTPUT.PUT_LINE('APELLIDO: ' || v_fila.apellido || ', OFICIO: ' || v_fila.oficio || ', DNOMBRE: ' || v_fila.dnombre || ', SALARIO: ' || v_fila.salario );
        END LOOP;
    END;
END;

BEGIN
    PK_UNION_EMPLEADOS.DEVOLVER_ALL_EMPLEADOS_SALARIO_MAYORDE(400000);
END;


-- dbms_random.value(1,500)
create or replace package pk_subida_salario_doctor
as
    procedure subir_salario_random(numero number);
    procedure subir_salario_salario;
    function f_obtener_limite_ramdom(numero number) return number;
END;


create or replace package body pk_subida_salario_doctor
as
    procedure subir_salario_random(numero number)
    AS
        cursor doctores is select * from doctor;
    BEGIN  
        FOR v_fila in doctores LOOP
            UPDATE doctor set salario = salario + trunc(dbms_random.value(1,numero)) where doctor_no = v_fila.doctor_no ;
        END LOOP;
    END;

    procedure subir_salario_salario
    AS
        cursor doctores is select * from doctor;
    BEGIN
        FOR v_fila in doctores LOOP
            UPDATE doctor set salario = salario + trunc(dbms_random.value(1,f_obtener_limite_ramdom(nvl(v_fila.salario,0)))) where doctor_no = v_fila.doctor_no ;
        END LOOP;
    END;

    function f_obtener_limite_ramdom(numero number) return number
    AS
    BEGIN
        IF numero < 200000 THEN RETURN 500; END IF;
        if numero >= 200000 and numero <= 300000 THEN RETURN 300;  END IF;
        if numero > 300000 THEN RETURN 50;  END IF;
        RETURN 0;
    END;

END pk_subida_salario_doctor;

select * from doctor;
DECLARE
v_ramdom number;
BEGIN
--pk_subida_salario_doctor.subir_salario_salario;
v_ramdom := trunc(dbms_random.value(1,50));
DBMS_OUTPUT.PUT_LINE('There are number random ' || v_ramdom );
END;