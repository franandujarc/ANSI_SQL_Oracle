---------- FUNCIONES ---------------

create or replace FUNCTION f_sumar_numeros(p_numero1 number,p_numero2 number) return number
AS
BEGIN
    return (nvl(p_numero1,0) + nvl(p_numero2,0));
end;

DECLARE
    v_resultado number;
BEGIN
    v_resultado := F_SUMAR_NUMEROS(50,50);
    DBMS_OUTPUT.PUT_LINE('la suma es ' ||v_resultado);
END;

-- con un select

select F_SUMAR_NUMEROS(22,99) as SUMA from dual;

-- funcion para sabe el numero de personas de un oficio

create or replace FUNCTION f_num_personas_oficio(p_oficio emp.oficio%type)return NUMBER
AS
    v_personas int;
BEGIN
    select count(EMP_NO) into v_personas from emp where lower(oficio) = LOWER(p_oficio);
    return v_personas;
END;

select f_num_personas_oficio('analista') as num_personas from dual;

-- realizar una funcion para devolver el mayor de dos numeros

create or replace function f_numero_mayor(p_numero1 number, p_numero2 number) return NUMBER
AS
BEGIN

    IF p_numero1>p_numero2 THEN
        RETURN p_numero1;
    ELSE
        RETURN p_numero2;
    END IF;

END;

select f_numero_mayor(5,10) as nummayor from dual;


DECLARE
   -- v_varchar VARCHAR2(10);
    v_number number;
BEGIN
  --  DBMS_OUTPUT.PUT_LINE('v_varchar ' || v_varchar%TYPE );
    DBMS_OUTPUT.PUT_LINE('v_number ' || v_number%type);
    IF  v_number%type = 'number' THEN
        DBMS_OUTPUT.PUT_LINE('v_number ');
    ELSE
        DBMS_OUTPUT.PUT_LINE('v_number 2 ');
    END IF;
END;

-- funcion una funcion para devolver el mayor de los 3 numeros

select greatest(5,110,25) as nummayor from dual;
--valor por defecto y sobre carga de metodos
create or replace function calcular_iva(p_precio number,p_iva number := 1.18) return NUMBER

AS

BEGIN
    return p_precio * p_iva;
END;


------ VIEWS / VISTAS ------------------

CREATE OR REPLACE VIEW V_EMPLEADOS
AS
SELECT EMP_NO,APELLIDO,OFICIO,FECHA_ALT,DEPT_NO,SALARIO FROM EMP;

SELECT * FROM V_EMPLEADOS;
-- UNA VISTA SIMPLIFICA LAS CONSULTAS
-- mostrar apellido moficio,salario,nombre departamento y localidad de los empleados
CREATE OR REPLACE VIEW V_EMP_DEPT
AS
select e.apellido,e.oficio,e.salario,d.dnombre,d.loc 
from emp e 
inner join dept d 
on e.DEPT_NO = d.DEPT_NO;

select * from V_EMP_DEPT;

select * from user_views where view_name ='V_EMP_DEPT';

-- modificar el salario de los empelados analista


UPDATE emp set salario = salario+1 where OFICIO='ANALISTA';

UPDATE V_EMPLEADOS set salario = salario+1 where OFICIO='ANALISTA';

SELECT * FROM V_EMPLEADOS;

-- eliminamos al empleado con id 7917

delete from V_EMPLEADOS where emp_no =7917;

ROLLBACK;

-- insertar en la vista


insert into V_EMPLEADOS values(1111,'lunes','LUNES',sysdate,10,10);
-- update a una vista con join
UPDATE V_EMP_DEPT set salario = salario + 1 where loc='MADRID';
-- eliminar con la vista join
delete from V_EMP_DEPT where loc = 'BARCELONA';

select * from emp;
select * from dept;

CREATE OR REPLACE VIEW V_EMP_DEPT2
AS
select e.apellido,e.oficio,e.salario,d.dnombre,d.loc 
from dept d 
inner join emp e
on e.DEPT_NO = d.DEPT_NO;

delete from V_EMP_DEPT where loc = 'BARCELONA';

--insertar no por que afecta a dos tablas el update si le pones set a otro como e localidad y afectara a 2 tablas tampoco dejaria


-- with check option evita que la vista se quede inutil

CREATE OR REPLACE VIEW V_VENDEDORES
AS
SELECT EMP_NO,APELLIDO,OFICIO,SALARIO,DEPT_NO FROM EMP WHERE oficio='VENDEDOR';

delete from V_VENDEDORES ;

SELECT * FROM V_VENDEDORES;

select * from emp;

rollback;

-- modificamos salario de los vendendores

update V_VENDEDORES set salario = salario+ 1 ;
--VUELVE LA VISTA INUTIL
update V_VENDEDORES set oficio = 'VENDIDOS' ;

CREATE OR REPLACE VIEW V_VENDEDORES
AS
SELECT EMP_NO,APELLIDO,OFICIO,SALARIO,DEPT_NO FROM EMP WHERE oficio='VENDEDOR' WITH CHECK OPTION;

update V_VENDEDORES set oficio = 'VENDIDOS' ;

-- FUNCION NARCISISTA

CREATE OR REPLACE FUNCTION numero_narcisista(numero number)return number
AS
    v_numero_texto varchar2(100):= to_char(numero);
    longitud number;
    digito number;
    numero_cubo number;
    suma number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EL NUMEOR INTRODUCIDO ES' || v_numero_texto );
    longitud := length(v_numero_texto);
    
    FOR i in 1..longitud LOOP
    digito:= to_number(substr(v_numero_texto,i,1));
    numero_cubo := power(digito,3);
     DBMS_OUTPUT.PUT_LINE('EL DIGITO ' || digito || ' elevado al cubo es '||  numero_cubo);
    suma:= suma + numero_cubo;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('por lo que la suma es ' || suma );

    IF suma=numero THEN
      DBMS_OUTPUT.PUT_LINE('ES NARCISISTA' );
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO ES NARCISISTA' );
    END IF;
    
    RETURN suma;
    
END;


DECLARE

    v_numero_texto varchar2(100):= to_char(548);
    longitud number;
    digito number;
    suma number;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EL NUMEOR INTRODUCIDO ES ' || v_numero_texto );
    longitud := length(v_numero_texto);
    
    FOR i in 1..longitud LOOP
    digito:= to_number(substr(v_numero_texto,i,1));
    -- DBMS_OUTPUT.PUT_LINE('EL DIGITO ' || digito || ' elevado al cubo es '||  power(digito,3));
    suma:= suma + power(digito,3);
     DBMS_OUTPUT.PUT_LINE('suma ' || suma );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('por lo que la suma es ' || to_char(suma));

    IF suma=548 THEN
      DBMS_OUTPUT.PUT_LINE('ES NARCISISTA' );
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO ES NARCISISTA' );
    END IF;
    
    --RETURN suma;
    
END;

BEGIN
    NUMERO_NARCISISTA(548);
END;


