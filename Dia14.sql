------ DIA 14 --------
select * from doctor;
select * from hospital;
select * from doctor natural join hospital where nombre = 'la paz';
DECLARE
    v_doctor doctor.DOCTOR_NO%TYPE;
    v_salario number;
    v_num_doctores_ricos int :=0;
    v_num_doctores_pobres int :=0;

    cursor doctores_paz is select doctor_no from doctor natural join hospital where nombre = 'la paz';
BEGIN
    select sum(salario) as sumasalarial into v_salario from doctor natural join hospital where nombre = 'la paz';
    open doctores_paz;

    LOOP
        FETCH doctores_paz into v_doctor;
        EXIT WHEN doctores_paz%NOTFOUND;
        if (v_salario > 1000000) THEN 
            update doctor set salario=salario-10000 where DOCTOR_NO =v_doctor;
            v_num_doctores_ricos := v_num_doctores_ricos+1;
            DBMS_OUTPUT.PUT_LINE('ENTRA EN RICOS ' ||v_doctor);
        ELSE
            update doctor set salario=salario+10000 where DOCTOR_NO =v_doctor;
            v_num_doctores_pobres := v_num_doctores_pobres+1;
            DBMS_OUTPUT.PUT_LINE('ENTRA EN POBRES ' ||v_doctor );
        END IF;

    END LOOP;

    close doctores_paz;
    DBMS_OUTPUT.PUT_LINE('DOCTORES CON SUERTE: ' || v_num_doctores_ricos || ', DOCTORES MAS POBRES :' ||v_num_doctores_pobres);
END;

select doctor_no from doctor natural join hospital where nombre = 'la paz';

-- REALIZAREMOS LA DECLARACION CON DEPARTAMENTOS

DESCRIBE DEPT;

DECLARE
    v_fila dept%rowtype;
    cursor cursor_dept is select * from dept;
BEGIN
    open cursor_dept;
    LOOP
        FETCH cursor_dept into v_fila;
        EXIT WHEN cursor_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_fila.dept_no || ', Nombre: ' || v_fila.dnombre || ', LOCALIDAD: ' || v_fila.loc );
        

    END LOOP;
    close cursor_dept;
END;

-- FOR CON CURSOR

DECLARE
    cursor cursor_dept is select * from dept;
BEGIN
    FOR v_fila_dept in cursor_dept LOOP
          DBMS_OUTPUT.PUT_LINE('ID: ' || v_fila_dept.dept_no || ', Nombre: ' || v_fila_dept.dnombre || ', LOCALIDAD: ' || v_fila_dept.loc );
    END LOOP;
END;