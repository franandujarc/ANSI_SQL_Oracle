--------------DIA 12 -----------------------

------------ BUCLES---------

--- BUCLES SIMPLES
-- MOSTAR LA SUMA DE LOS PRIMEROS 100 NUMEROS
-- 1º BUCLE LOOP..END LOOP

DECLARE
    i int ;
    suma int;
BEGIN
    i:= 1;
    suma := 0;
    LOOP
        suma:= suma + i;
        i:= i+1;
        EXIT WHEN i>100;
    END LOOP;

    dbms_output.put_line('la suma de los 100 primeros numeroes es : ' ||suma);

END;

-- 2º BUCLE WHILE ... LOOP

DECLARE
    i int := 1;
    suma int := 0;
BEGIN
    WHILE i <= 100 LOOP
    suma:= suma + i;
    i:= i+1;
    END LOOP;
     dbms_output.put_line('la suma de los 100 primeros numeroes es : ' ||suma);
END;

-- 3º BUCLE FOR

DECLARE
    suma int := 0;
BEGIN
    FOR i IN 1..100 LOOP
        suma:= suma + i;
    END LOOP;
     dbms_output.put_line('la suma de los 100 primeros numeroes es : ' ||suma);
END;

-- goto hace que salte el codigo a otra parte del codigo

DECLARE
    suma int := 0;
BEGIN
    dbms_output.put_line('INICIO' );
    GOTO salto;
    dbms_output.put_line('ANTES DEL BUCLE');
    FOR i IN 1..100 LOOP
        suma:= suma + i;
    END LOOP;
    <<salto>>
    dbms_output.put_line('DESPUES DEL BUCLE');
    dbms_output.put_line('la suma de los 100 primeros numeroes es : ' ||suma);
END;

-- null permite escribir un else vacio

DECLARE
    i int:= 1;
    suma int := 0;
BEGIN
    IF ( i>= 1) THEN
        dbms_output.put_line('ANTES DEL BUCLE');
    ELSE 
        null;
    END IF;

END;


-- BUCLE PARA MOSTRAR LOS NUMEROS DEL 1 AL 10 CON BUCLE WHILE Y FOR

DECLARE
    i int :=1;
BEGIN  
    dbms_output.put_line('BUCLE WHILE');
    WHILE i<=10 LOOP
    dbms_output.put_line (i);
    i:= i+1;
    END LOOP;
END;

DECLARE 

BEGIN
    dbms_output.put_line('BUCLE FOR');
    FOR i in 1..10 LOOP
    dbms_output.put_line (i);
    END LOOP;
END;

-- PEDIR AL USUARIO UN NUMERO DE INICIO Y UN NUMERO FINA
-- MOSTRAR LOS NUMEROS COMPRENDIDOS ENTRE DICHO RANGO

DECLARE 
    num1 int :=0;
    num2 int := 0;
    arreglo int :=0; 
BEGIN
    num1:= &numero1;
    num2:= &numero2;
    IF (num1>num2) THEN
    arreglo:= num1;
    num1 := num2;
    num2:= arreglo;
    END IF;

    WHILE num1<=num2 LOOP
    dbms_output.put_line (num1);
    num1:= num1 + 1;
    END LOOP;
END;
-- QUEREMOS UN BUCLE PIDIENDO UN INICIO Y UN FIN Y QUEREMOS MOSTRAR LOS NUMEROS PARES ENTRE INICIO Y FIN

DECLARE 
    num1 int :=0;
    num2 int := 0;
    arreglo int :=0; 
BEGIN
    num1:= &numero1;
    num2:= &numero2;
    IF (num1>num2) THEN
    arreglo:= num1;
    num1 := num2;
    num2:= arreglo;
    END IF;

    WHILE num1<=num2 LOOP
    IF (mod(num1,2)=0) THEN
        dbms_output.put_line (num1);
    END IF;
    num1:= num1 + 1;
    END LOOP;
END;

--CONJETURA DE COLLATZ
--la teoria indica que cualquier numero siempre llegara a ser 1 siguiendo un algoritmo:
--1º si el numeor es par, se divide entre 2 / si es impar multiplica por 3 y sumamos 1
DECLARE 
    num1 int :=0;
BEGIN
    num1:= &numero1;
    dbms_output.put_line ('El numero dado es : '||num1);
    WHILE num1<>1 LOOP
        IF (mod(num1,2)=0) THEN
            num1:=num1/2;
        ELSE
            num1:=(num1*3)+1;
        END IF;

        dbms_output.put_line (num1);
    END LOOP;
END;

-- MOSTRAR LA TABLA DE MULTIPLICAR DE UN NUMERO QUE PIDAMOS A UN USUARIO
DECLARE

    num1 int;
BEGIN
    num1:= &numero1;
    dbms_output.put_line ('TABLA DE MULTIPLICAR DEL NUMERO : '||num1);
    FOR i in 0..10 LOOP
    dbms_output.put_line (num1 || ' x ' || i || ' = '||(num1 * i) );
    END LOOP;
END;

--  QUIERO UN PROGRAMA QUE NOS PEDIRA UN TEXTO , DEBEMOS RECORRER DICHO TEXTO LETRA A LETRA
DECLARE

    texto VARCHAR2(100);
    longitud int;
BEGIN
    texto:= '&texto1';
    longitud := length(texto);
    dbms_output.put_line ('TEXTO:'||texto);
    
    FOR i in 1..longitud LOOP
    dbms_output.put_line (substr(texto,i,1));
    END LOOP;

END;
--- EL USUARIO INTRODUCIRA UN TEXTO NUMERICO Y NECESITO MOSTRAR LA SUMA TODOS LOS CARACTERES NUMERICOS EN UN MENSAJE

DECLARE

    texto VARCHAR2(100);
    longitud int;
    suma int :=0;
BEGIN
    texto:= '&texto1';
    longitud := length(texto);
    dbms_output.put_line ('NUMEROS:'||texto);
    
    FOR i in 1..longitud LOOP
    suma:= suma + to_number(substr(texto,i,1));
    END LOOP;
    dbms_output.put_line ('SUMA:'||suma);

END;

undefine texto1;