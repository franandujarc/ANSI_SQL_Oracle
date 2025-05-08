----------- DIA 19 -----------------

create or replace trigger pk_update_referencial_deptno
before UPDATE
on dept
for EACH ROW
    when(new.dept_no <> old.dept_no)
DECLARE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('NUMERO DE DEPARTAMENTO CAMBIADO');
    update emp set dept_no = new.dept_no where dept_no = old.dept_no;
END;

-- IMPEDIR INSERTAR UN NUEVO PRESIDENTE SI YA EXISTE UNO EN LA TABLA EMP
drop trigger pk_update_presidente;
create or replace trigger pk_update_presidente
before INSERT
on emp
for EACH ROW
    when(upper(new.oficio) = 'PRESIDENTE')
DECLARE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('CAMBIADO OFICIO A DIRECTOR');
    update emp set oficio = 'DIRECTOR' where oficio = :new.oficio;
END;

INSERT INTO emp (
  EMP_NO, APELLIDO, OFICIO, DIR, FECHA_ALT, SALARIO, COMISION, DEPT_NO
) VALUES (
  1001, 'García', 'PRESIDENTE', 101, TO_DATE('2025-05-08', 'YYYY-MM-DD'), 50000, 5000, 10
);

select * from emp;
rollback;

drop trigger tr_dept_control_localidades;

create or replace package pk_variable_triggers
as
    v_loc_new dept.LOC%TYPE;

end pk_variable_triggers;

create or replace trigger tr_dept_control_localidades_row
before update
on dept
for each ROW
DECLARE
BEGIN
    -- almacenamos el valor de la nueva localidad
    PK_VARIABLE_TRIGGERS.v_loc_new := :new.loc;
END;


create or replace trigger tr_dept_control_localidades_after
after update
on dept
DECLARE
    v_num number;
BEGIN
    select count(dept_no) into v_num from dept where upper(loc) = upper(PK_VARIABLE_TRIGGERS.v_loc_new);
    if v_num > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'solo un departamento por ciudad');
    END IF;
END;


insert into dept values(6,'MILAN','TERUEL');

update dept set loc = 'CADIZ' where dept_no = 111 ;
select * from dept;


-- creamos una vista de todos los datos de dapartamento

create or replace view vista_departamentos
as select * from dept;

insert into vista_departamentos values(124,'MILAN','TERUEL');

select * from emp;

create or replace trigger tr_vista_departamentos
instead of insert
on vista_departamentos
DECLARE
BEGIN
     DBMS_OUTPUT.PUT_LINE('no insertara ahora realiza esto');
END;


create or replace VIEW vista_empleados
AS
 select emp_no,apellido,oficio,dir,dept_no from emp;


insert into vista_empleados values(555,'el nuevo','BECARIO',1567,30);

create or replace trigger tr_vista_emp
instead of insert
on vista_empleados
DECLARE
BEGIN
    insert into emp values(:new.emp_no,:new.apellido,:new.oficio,:new.dir,sysdate,0,0,:new.dept_no);
END;

ROLLBACK;

-- vamos a crear una vista para mostrar doctores
create or replace view vista_doctores
as select doctor_no,apellido,especialidad,salario,nombre from doctor natural join hospital;
select * from vista_doctores;

insert into vista_doctores values (111,'HOUSE 2','Especailista',450000,'provincial');

select * from doctor;
select * from hospital;
create or replace trigger tr_vista_doctores
instead of insert
on vista_doctores
DECLARE
     v_hospitalcod doctor.HOSPITAL_COD%TYPE;
BEGIN
    select hospital_cod into v_hospitalcod from hospital where nombre = :new.nombre;
    insert into doctor values(v_hospitalcod,:new.doctor_no,:new.apellido,:new.especialidad,:new.salario);
END;

rollback;

----------SQL DINAMICO----------

