-------------------- DIA 10 -------------------
-- EJERCICIOS DE FUNCIONES ORACLE

-- 1º Mostrar todos los apellidos de los empleados en Mayúsculas

select upper(apellido) as upperapellidos from emp;

-- 2º Construir una consulta para que salga la fecha de hoy con el siguiente formato: Martes 06 de Octubre de 2020

select to_char(sysdate,'day dd "de" month "de" yyyy','nls_date_language = spanish') fechahoy from dual;

/* 3º Queremos cambiar el departamento de Barcelona y llevarlo a Tabarnia.
Para ello tenemos que saber qué empleados cambiarían de localidad y cuáles no.  
Combinar tablas y mostrar el nombre del departamento junto a los datos del empleado.*/

select * from dept;
select * from emp;

select d.dnombre, e.apellido, decode(d.loc,'BARCELONA','A TABARNIA','NO CAMBIA DE LOCALIDAD') as Traslado from emp e natural join dept d;

/* 4º Mirar la fecha de alta del presidente. Visualizar 
todos los empleados dados de alta 330 días antes que el presidente. */

select * from emp where fecha_alt <= (select fecha_alt - 330 from emp where oficio='PRESIDENTE');

/* 5º genera un informe como este */

select rpad(apellido,14,'.')
||rpad(oficio,14,'.')
||rpad(salario,14,'.')
||rpad(dept_no,14,'.')
as informe from emp;

/* Nos piden otro, en el que se muestren todos los empleados de la siguiente manera: */

select 'El Señor '|| INITCAP (apellido) ||' con cargo de '||INITCAP (oficio)||' se dió de alta el '||to_char(fecha_alt,'day dd "de" month "de" yyyy','nls_date_language = spanish')||' en la empresa'  "fecha de alta" from emp;

------------------- PL / SQL ---------------------------
DECLARE
    numero int;
    textoyes VARCHAR2(50):='entra if';
    textono VARCHAR2(50):='entra else'; --SE DEBE DECLARAR LA LONGITUD DEL TEXTO SI ES REQUERIDO EN EL TIPO DE DATO
BEGIN   
    --la variable es null
    numero:= 19;
    dbms_output.put_line('El numero vale ahora '||numero);
    IF true 
    THEN dbms_output.put_line('El numero es mas grande que 4 '); 
    END IF;
        
END;

DECLARE
    numero1 int:=&dato1;
    numero2 int:=&dato2;
    texto1 VARCHAR2(50):='&dato3';
BEGIN
    dbms_output.put_line('la suma del valor es  '||(numero1+numero2));
      dbms_output.put_line('texto guardado  '||texto1);
END;



DECLARE
    fecha date;
    texto varchar2(50);
    longitud int;
BEGIN
    fecha:=sysdate;
    texto:='&data';
    --quiero es almancenar longitud del texto

    longitud:= length(texto);

    dbms_output.put_line('la longitud de su texto es '|| longitud);
    DBMS_OUTPUT.PUT_LINE('Hoy es '|| to_char(fecha,'day'));
     DBMS_OUTPUT.PUT_LINE(texto);
END;

DECLARE
    numero1 int:=&dato1;
    numero2 int:=&dato2;
BEGIN
    dbms_output.put_line('la suma de '||numero1 ||' + '||numero2 || ' es '||(numero1+numero2));
    
END;
-- vacia variables dinamicas
--undefine dato1;
--undefine dato2;

DECLARE
    --declaramos la variable que contenga de forma dinamica la variable departamento.BEGIN
    v_departamento number(5);

BEGIN
    v_departamento:= &dato1;
    UPDATE emp set salario = salario + 1 where DEPT_NO = v_departamento;

END;


