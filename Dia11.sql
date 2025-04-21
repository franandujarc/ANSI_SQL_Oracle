------------- DIA 11 --------------
undefine dato1;
undefine dato2;
undefine dato3;
DECLARE

    v_departamento dept.DEPT_NO%TYPE;
    v_nombre dept.DNOMBRE%TYPE;
    v_localidad dept.LOC%TYPE;

BEGIN
   v_departamento := &dato1;
   v_nombre := '&dato2';
   v_localidad := '&dato3';

   insert into dept values(v_departamento,v_nombre,v_localidad);

END;

SELECT * FROM dept;

rollback;

/* 2º Insertar en la tabla EMP un empleado con código 9999 asignado directamente 
en la variable con %TYPE,apellido ‘PEREZ’, oficio ‘ANALISTA’ y 
código del departamento al que pertenece 10.*/
select * from emp;
DECLARE
    v_emp_no emp.EMP_NO%TYPE := 9999;
    v_apellido emp.APELLIDO%TYPE := 'PEREZ';
    v_oficio emp.OFICIO%TYPE := 'ANALISTA';
    v_dept_no emp.DEPT_NO%TYPE := 10;
BEGIN
    INSERT INTO emp (emp_no,apellido,oficio,dept_no) values (v_emp_no,v_apellido,v_oficio,v_dept_no);
END;

/*
3º  Incrementar el salario en la tabla EMP en 200 EUROS a todos los
 trabajadores que sean ‘ANALISTA’,mediante un bloque anónimo PL, 
 asignando dicho valor a una variable declarada con %TYPE.
*/
select * from emp;
DECLARE
    v_subida_sueldo emp.SALARIO%TYPE;
BEGIN
    v_subida_sueldo := 200;
    UPDATE emp set salario=(salario +v_subida_sueldo);
END;

ROLLBACK;

/*
Realizar un programa que devuelva el número de cifras de un número entero, 
introducido por teclado, mediante una variable de sustitución.

*/

DECLARE
    v_cantidad int:=10;
    v_numletrascantidad int;
BEGIN
    v_cantidad := &dato1;
    v_numletrascantidad := length(to_char(v_cantidad));
   DBMS_OUTPUT.PUT_LINE('el numeor de cifras es ... '||v_numletrascantidad);
END;

/*
 Crear un bloque PL para insertar una fila en la tabla DEPT. 
 Todos los datos necesarios serán pedidos desde teclado.
*/
DECLARE

    v_departamento dept.DEPT_NO%TYPE;
    v_nombre dept.DNOMBRE%TYPE;
    v_localidad dept.LOC%TYPE;

BEGIN
   v_departamento := &dato1;
   v_nombre := '&dato2';
   v_localidad := '&dato3';

   insert into dept values(v_departamento,v_nombre,v_localidad);

END;

/*
Crear un bloque PL que actualice el salario de los empleados 
que no cobran comisión en un 5%.
*/
select * from emp;
DECLARE
    v_porcentajesubida int :=5;
BEGIN
    update emp set salario = (salario +((salario*v_porcentajesubida)/100)) where comision = 0;
END;

ROLLBACK;


/*
Crear un bloque PL que almacene la fecha del sistema en una variable. 
Solicitar un número de meses por teclado y mostrar la fecha del sistema
 incrementado en ese número de meses.
*/

DECLARE
    v_fechahoy date;
    v_diasincrementar int;
BEGIN
    v_fechahoy:=sysdate;
    v_diasincrementar:='&dato1';
    --quiero es almancenar longitud del texto


    dbms_output.put_line('la fecha de hoy es  '|| to_char(v_fechahoy,'dd/mm/yyyy')|| ' se incremento el siguiente numero de meses '||v_diasincrementar || ' quedando asi la fecha de ' || to_char(add_months(v_fechahoy,v_diasincrementar),'dd / mm / yyyy'));

END;

/*
Introducir dos números por teclado y devolver el resto de la división de los dos números.
*/

DECLARE
    v_num1 int;
    v_num2 int;
BEGIN
    v_num1:=&dato1;
    v_num2:=&dato2;
    --quiero es almancenar longitud del texto


    dbms_output.put_line('el resto de la division '||v_num1||'/'||v_num2|| ' es ' ||mod(v_num1,v_num2) );

END;

/*
Solicitar un nombre por teclado y devolver ese nombre con la primera inicial en mayúscula.
*/
DECLARE
    v_nombre VARCHAR2(50);
BEGIN
    v_nombre := '&dato1';
dbms_output.put_line(' la primera letra de ' || v_nombre || ' es ' || substr(INITCAP(v_nombre),1,1));

END;

/*
Crear un bloque anónimo que permita borrar un registro de la tabla 
emp introduciendo por parámetro un número de empleado.

*/
SELECT * from emp;
DECLARE
    v_numempleado emp.EMP_NO%TYPE;
BEGIN
    v_numempleado:= &dato1;

    delete from emp where emp_no = v_numempleado;
END;


-------------  CONDICIONALES IF -----------------
undefine dato1;
undefine dato2;
undefine dato3;

DECLARE
    v_num1 int;

BEGIN
    v_num1:=&dato1;
    IF(v_num1 >= 0 )THEN
        dbms_output.put_line(' ES POSITIVO' );
    ELSE
    dbms_output.put_line(' ES NEGATIVO' );
    END IF;
END;


DECLARE
    v_num1 int;

BEGIN
    v_num1:=&dato1;
    IF(v_num1 > 0 )THEN
        dbms_output.put_line(' ES POSITIVO' );
    ELSIF(v_num1 = 0) THEN
        dbms_output.put_line(' ES 0' );
    ELSE
    dbms_output.put_line(' ES NEGATIVO' );
    END IF;
END;

DECLARE
    v_num1 int;
BEGIN
    dbms_output.put_line('DAME UN NUMERO DEL 1-4 INCLUSIVES');
    v_num1:=&dato1;
    IF(v_num1 = 1 )THEN
        dbms_output.put_line('Primavera');
    ELSIF(v_num1 = 2) THEN
        dbms_output.put_line('Verano');
    ELSIF(v_num1 = 3) THEN
        dbms_output.put_line('Otoño');
    ELSIF(v_num1 = 4) THEN
        dbms_output.put_line('Invierno');
    ELSE
        dbms_output.put_line('ESTA MAL EL NUMERO');
    END IF;

END;

DECLARE
    v_num1 int;
    v_num2 int;
BEGIN
    v_num1:=&dato1;
    v_num2:=&dato2;

    IF(v_num1 > v_num2 )THEN
        dbms_output.put_line(v_num1 || ' ES MAYOR QUE ' || v_num2);
    ELSIF(v_num1 = v_num2) THEN
        dbms_output.put_line(v_num1 || ' SON EL MISMO NUMERO ' || v_num2);
    ELSE
        dbms_output.put_line(v_num2 || ' ES MAYOR QUE ' || v_num1);
    END IF;
END;

DECLARE
    v_num1 int;
BEGIN
    v_num1 := &dato1;

    if(mod(v_num1,2)=0) THEN
        dbms_output.put_line('ES PAR');
    ELSE
        dbms_output.put_line('ES IMPAR');
    END IF;
END;


--- PEDIR UNA LETRA USUARIO SI LA LETRA ES VOCAL O CONSONANTE

DECLARE
    v_letra1 VARCHAR2(1);
BEGIN
    v_letra1 := UPPER('&dato1');

    IF(v_letra1 = 'A' OR v_letra1 = 'E' OR v_letra1 = 'I' OR v_letra1 = 'O' OR v_letra1 = 'U') THEN
        dbms_output.put_line('VOCAL');
    ELSE
        dbms_output.put_line('CONSONANTE');
    END IF;

END;

-- PEDIR 3 NUMEROS AL USUARIO Y MOSTRAR EL MAYOR Y EL MENOR DE LOS TRES

DECLARE
    v_num1 int;
    v_num2 int;
    v_num3 int;
    V_nummayor int;
    V_nummenor int;
BEGIN
    v_num1:=&dato1;
    v_num2:=&dato2;
    v_num3:=&dato3;

    IF(v_num1 > v_num2 and v_num1 > v_num3)THEN
       V_nummayor := v_num1;
    ELSIF(v_num2 > v_num1 and v_num2> v_num3 ) THEN
        V_nummayor := v_num2;    
    ELSE
         V_nummayor := v_num3; 
    END IF;

    IF(v_num1 < v_num2 and v_num1 < v_num3)THEN
       V_nummenor := v_num1;
    ELSIF(v_num2 < v_num1 and v_num2< v_num3 ) THEN
        V_nummenor := v_num2;    
    ELSE
         V_nummenor := v_num3; 
    END IF;


    dbms_output.put_line('el numero mayor es ' || V_nummayor);
    dbms_output.put_line('el numero menor es ' || V_nummenor);
END;


undefine dato1;
undefine dato2;
undefine dato3;


DECLARE
    v_dia int;
    v_mes int;
    v_ano int;
    v_resultadopaso1 int;
    v_resultadopaso2 int;
    v_resultadopaso3 int;
    v_resultadopaso4 int;
    v_resultadopaso5 int;
    v_resultadopaso6 int;
    v_resultadopaso7 int;
BEGIN
    v_dia:=&dato1;
    v_mes:=&dato2;
    v_ano:=&dato3;

    -- correcion del mes

    if(v_mes = 1)THEN
    v_mes := 13;
    v_ano:= v_ano-1;
    end if;
    if(v_mes = 2)THEN
     v_mes := 14;
     v_ano:= v_ano-1;
    end if;

    v_resultadopaso1:=((v_mes + 1)*3)/5;
     dbms_output.put_line('v_resultadopaso1 ' || v_resultadopaso1);
    v_resultadopaso2:= v_ano/4 ;
     dbms_output.put_line('v_resultadopaso2 ' || v_resultadopaso2);
    v_resultadopaso3:= v_ano/100 ;
     dbms_output.put_line('v_resultadopaso3 ' || v_resultadopaso3);
    v_resultadopaso4:= v_ano/400 ;
     dbms_output.put_line('v_resultadopaso4 ' || v_resultadopaso4);
    v_resultadopaso5:= v_dia + (v_mes*2) +v_ano+v_resultadopaso1+v_resultadopaso2-v_resultadopaso3 +v_resultadopaso4 + 2;
     dbms_output.put_line('v_resultadopaso5 ' || v_resultadopaso5);
    v_resultadopaso6:= v_resultadopaso5/7;
    dbms_output.put_line('v_resultadopaso6 ' || v_resultadopaso6);
    v_resultadopaso7:= v_resultadopaso5 - (v_resultadopaso6*7);
    dbms_output.put_line('v_resultadopaso7 ' || v_resultadopaso7);

    dbms_output.put_line('dia ' || v_dia);
    dbms_output.put_line('mes ' || v_mes);
    dbms_output.put_line('año ' || v_ano);
    if(v_resultadopaso7 = 0)THEN
        dbms_output.put_line('SABADO');
    end if;
    if(v_resultadopaso7 = 1)THEN
        dbms_output.put_line('DOMINGO');
    end if;
    if(v_resultadopaso7 = 2)THEN
        dbms_output.put_line('LUNES');
    end if;
    if(v_resultadopaso7 = 3)THEN
        dbms_output.put_line('MARTES');
    end if;
    if(v_resultadopaso7 = 4)THEN
        dbms_output.put_line('MIERCOLES');
    end if;
    if(v_resultadopaso7 = 5)THEN
        dbms_output.put_line('JUEVES');
    end if;
    if(v_resultadopaso7 = 6)THEN
        dbms_output.put_line('VIERNES');
    end if;

END;
