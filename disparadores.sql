/*

    DISPARADORES / FUNCIONES / PROCEDIMIENTOS

*/

-- Formato y activador out put servidor
set serveroutput on;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

-- Disparador para controlar que el DNI sea correcto
-- En este caso usa ID en vez de DNI

c
--5 A
create or replace trigger trigger_participantes_id
before insert on participantes
for each row
declare
    -- Declaramos una variable donde meteremos el número de asociado
    v_max_asociado number;
begin
    -- Bucle para verificar cuando se inserta
    if inserting then
        -- Bucle para verificar que el ID no sea nulo ni esté vacío
        if :new.asociado is null or :new.asociado = '' then
            -- Error si el ID es nulo o está vacío
            raise_application_error(-20003, 'El ID no puede estar vacío');
        end if;

        -- Bucle para verificar que se inserten solo números y no letras
            -- Bucle para verificar que el ID no existe
            select max(to_number(asociado)) into v_max_asociado from participantes;
            
            --Si la consulta no devuelve nada a la variable le añadimos un 0
            if v_max_asociado is null then
                v_max_asociado := 0;
            end if;

            if :new.asociado <= v_max_asociado then
                -- Error si el ID ya existe o es menor o igual al máximo existente
                raise_application_error(-20002, 'El ID insertado ya existe o es menor o igual al máximo existente');
            end if;
        
    end if;
end;
/


INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('310', 'ELENA', 'LOPEZ', 'PEREZ', 'ELENA@EJEMPLO.COM', 688997766, 'AVD', 505, 'CARRERA', NULL, NULL, '8', 'H', NULL, 'JEREZ DE LA FRONTERA', 'CÁDIZ');

select * from participantes where asociado like upper('304');

DELETE FROM participantes
WHERE asociado = '310';

--5 B
-- Trigger para la tabla provincia
create or replace trigger mayus_trim_provincia
before insert or update on provincia
for each row
begin
    :new.nombreprov := trim(lower(:new.nombreprov));
end;
/

-- Trigger para la tabla localidad
create or replace trigger mayus_trim_localidad
before insert or update on localidad
for each row
begin
    :new.nombreloc := trim(lower(:new.nombreloc));
end;
/

-- Trigger para la tabla participantes
create or replace trigger mayus_trim_participantes
before insert or update on participantes
for each row
begin
    :new.nombre := trim(lower(:new.nombre));
    :new.ap1 := trim(lower(:new.ap1));
    :new.ap2 := trim(lower(:new.ap2));
    :new.correo_electronico := trim(lower(:new.correo_electronico));
    :new.tipo_via := trim(lower(:new.tipo_via));
    :new.nombre_via := trim(lower(:new.nombre_via));
    :new.nombreloc := trim(lower(:new.nombreloc));
    :new.nombreprov := trim(lower(:new.nombreprov));
end;
/

-- Trigger para la tabla arbitro
create or replace trigger mayus_trim_arbitro
before insert or update on arbitro
for each row
begin
    :new.n_arbitro := trim(lower(:new.n_arbitro));
end;
/

-- Trigger para la tabla jugador
create or replace trigger mayus_trim_jugador
before insert or update on jugador
for each row
begin
    :new.n_jugador := trim(lower(:new.n_jugador));
end;
/

-- Trigger para la tabla competicion
create or replace trigger mayus_trim_competicion
before insert or update on competicion
for each row
begin
    :new.nombre := trim(lower(:new.nombre));
end;
/

-- Trigger para la tabla juega
create or replace trigger mayus_trim_juega
before insert or update on juega
for each row
begin
    :new.nombre_competicion := trim(lower(:new.nombre_competicion));
    :new.n_jugador := trim(lower(:new.n_jugador));
end;
/

-- Trigger para la tabla partida
create or replace trigger mayus_trim_partida
before insert or update on partida
for each row
begin
    :new.nombre_competicion := trim(:new.nombre_competicion);
    :new.n_arbitro := trim(:new.n_arbitro);
    :new.n_jugador_gana := trim(:new.n_jugador_gana);
end;
/
--5C
create or replace procedure listar_partidas_por_realizar (
    p_nombre_competicion in partida.nombre_competicion%type
)
is
begin
    for r in (
        select nombre_competicion, 
               fecha_competicion, 
               jornada, 
               jornada_fin, 
               n_arbitro
        from partida
        where nombre_competicion = p_nombre_competicion
          and n_jugador_gana is null
        order by fecha_competicion, jornada
    ) loop
        dbms_output.put_line('');
        dbms_output.put_line('Competición: ' || r.nombre_competicion);
        dbms_output.put_line('Fecha Competición: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY'));
        dbms_output.put_line('Jornada: ' || r.jornada);
        dbms_output.put_line('Jornada Fin: ' || r.jornada_fin);
        dbms_output.put_line('Árbitro: ' || r.n_arbitro);
        dbms_output.put_line('');
    end loop;
end;
/
       
      begin 
          listar_partidas_por_realizar('PARTIDA PARCHÍS LIMA');
end;
/
      
--5D

create or replace procedure listar_partidas_programadas(ncomp varchar2) is
begin
    for r in (
        select c.nombre as competicion, c.fecha as fecha_competicion, p.jornada, p.jornada_fin, p.n_arbitro, p.n_jugador_gana
        from competicion c
        join partida p on c.nombre = p.nombre_competicion and c.fecha = p.fecha_competicion
        where p.jornada > sysdate
        order by c.nombre, p.jornada
    ) loop
        dbms_output.put_line('Competición: ' || r.competicion || ', Fecha: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY') || ', Jornada: ' || r.jornada || ', Jornada Fin: ' || to_char(r.jornada_fin, 'DD-MM-YYYY') || ', Árbitro: ' || r.n_arbitro || ', Jugador Gana: ' || r.n_jugador_gana);
    end loop;
end;
/

begin 
          listar_partidas_programadas('PARTIDA PARCHÍS LIMA');
end;
/

--5E

create or replace procedure listar_partidas_porrealizadas(ncomp varchar2)
as
begin

   for r in (
        select c.nombre as competicion,
               c.fecha as fecha_competicion,
               p.jornada,
               p.jornada_fin,
               p.n_arbitro,
               p.n_jugador_gana
        from competicion c
        join partida p on c.nombre = p.nombre_competicion and c.fecha = p.fecha_competicion
        where p.jornada > sysdate and nombre_competicion like upper(ncomp)
        order by c.nombre, p.jornada
    ) loop
        dbms_output.put_line('Competición: ' || r.competicion || ', Partida: ' ||  'Fecha: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY') || ', Jornada: ' || r.jornada || ', Jornada Fin: ' || to_char(r.jornada_fin, 'DD-MM-YYYY') || ', Árbitro: ' || r.n_arbitro || ', Jugador Gana: ' || r.n_jugador_gana);
    end loop;

end;
/
begin 
          listar_partidas_porrealizadas('PARTIDA PARCHÍS LIMA');
end;
/


--5F
create or replace procedure mostrar_partidas_jugador (
    p_nombre_competicion in juega.nombre_competicion%type
)
is
begin
    for r in (
        select p.nombre,
               j.n_jugador,
               count(*) as total_jugadas,
               round((count(case when upper(j.color_ficha) = upper('rojo') then 1 end) / count(*)) * 100, 2) as "rojo (%)",
               round((count(case when upper(j.color_ficha) = upper('azul') then 1 end) / count(*)) * 100, 2) as "azul (%)",
               round((count(case when upper(j.color_ficha) = upper('amarillo') then 1 end) / count(*)) * 100, 2) as "amarillo (%)",
               round((count(case when upper(j.color_ficha) = upper('verde') then 1 end) / count(*)) * 100, 2) as "verde (%)"
        from juega j
        join participantes p on p.asociado = j.n_jugador
        where j.nombre_competicion = p_nombre_competicion
        group by j.n_jugador, p.nombre
    ) loop
        dbms_output.put_line(' ');
        dbms_output.put_line('Jugador: ' || r.nombre || ' (' || r.n_jugador || ')');
        dbms_output.put_line('Total de veces jugadas: ' || r.total_jugadas);
        dbms_output.put_line('Rojo (%): ' || r."rojo (%)");
        dbms_output.put_line('Azul (%): ' || r."azul (%)");
        dbms_output.put_line('Amarillo (%): ' || r."amarillo (%)");
        dbms_output.put_line('Verde (%): ' || r."verde (%)");
        dbms_output.put_line(' ');
    end loop;
end;
/

declare
    v_nombre_competicion varchar2(30) := 'PARTIDA PARCHÍS LIMA'; -- reemplaza con el nombre de la competición
begin
    mostrar_partidas_jugador(v_nombre_competicion);
end;
/

/** 6. Dado un participante mostrar su historial como
          a. Jugador y si ha ganado o no.
          b. Árbitro.
**/
create or replace procedure mostrar_historial_participante(
      num_asociado participantes.asociado%type)
as 
        v_nombre varchar(30);
        v_jugador_count number:=0;
        v_ganador_count number:=0;
        v_arbitro_count number:=0;
        
begin 
       --Obtener el nombre del jugador 
       select nombre into v_nombre
       from participantes
       where asociado = num_asociado;
       
       --Contar las veces que ha jugado como jugador
       select count(*) into v_jugador_count
       from juega j
       join jugador ju on j.n_jugador = ju.n_jugador
       where ju.n_jugador = num_asociado;
       
       --contar las veces que ha ganado
       select count(*) into v_ganador_count
       from partida p 
       where p.n_jugador_gana = num_asociado;
       
      -- contar las veces que ha arbirado 
      select count(*) into v_arbitro_count 
      from partida p
      where p.n_arbitro = num_asociado;
      
      --Mostrar los resultados
       dbms_output.put_line('Historial del Participante' || ' ' || v_nombre || ' ' || ' (' || num_asociado || ' )');
       dbms_output.put_line('Ha jugado' || ' ' || v_jugador_count  || ' veces' );
       dbms_output.put_line('Ha ganado' || ' ' || v_ganador_count  || ' veces' );
       dbms_output.put_line('Ha arbitrado' || ' ' || v_arbitro_count  || ' veces' );
  
end;
/

set serveroutput on;

begin 
          mostrar_historial_participante('006');
end;
/

/** 8 Cuando se termina una partida se debe rellenar la hora de su terminación
y quién ha sido el ganador. Esta tarea se irá realizando cada
automáticamente **/

create or replace trigger actualizar_hora_ganador
after update on juega -- Despues de actualizar en la tabla juega
for each row -- por cada fila 
begin -- Me haga una actualizacion 
  update partida 
  set jornada_fin = sysdate, n_jugador_gana = :new.n_jugador --la jornada_fin sea la fecha actual a la hora de hacer una actualizacion en la tabla juega
  -- y el numero de jugador ganador sea el que se le pasa cuando actualizas la tabla juega
  where jornada = :new.jornada and nombre_competicion = :new.nombre_competicion and fecha_competicion = :new.fecha_competicion;
end;
/

/** 9 Controlar que un árbitro no puede ser jugador de la partida que arbitra. **/
-- TABLA PARTIDA
create or replace trigger verificar_arbitro
before insert or update on partida -- antes de insertar o actualizar la tabla partida
for each row -- por cada fila 
declare -- declaramos la variable para poder lanzar el error en el caso que de haya un arbitro en la tabla juega
  v_existe number;
begin  -- hacemos una consulta para poder saber si el arbitro existe en la tabla juega. 
  select count(*) into v_existe
  from juega
  where n_jugador = :new.n_arbitro and jornada = :new.jornada and nombre_competicion = :new.nombre_competicion and fecha_competicion = :new.fecha_competicion;
  
  if v_existe >0 then -- si la variable v_existe tiene un numero mayor a 0 lanza error 
    raise_application_error(-20002, 'El arbitro no puede ser jugador en la partida que arbitra' );
  end if; 
end;
/
--  TABLA JUEGA

create or replace trigger verificar_jugador
before insert or update on juega  -- antes de insertar o actualizar la tabla juega
for each row -- por cada fila 
declare  -- declaramos la variable para poder lanzar el error en el caso que de haya un jugador asignado en una partida en la tabla partida
  v_existe number;
begin -- hacemos una consulta para poder saber si el jugador esta asignado como arbitro en la tabla partida
  select count(*) into v_existe 
  from partida
  where n_arbitro = :new.n_jugador and jornada = :new.jornada and nombre_competicion = :new.nombre_competicion and fecha_competicion = :new.fecha_competicion;
  
  if v_existe >0 then -- si la variable v_existe tiene un numero mayor a 0 lanza error
    raise_application_error(-20002, 'El jugador no puede ser arbitro en la partida que juega' );
  end if; 
end;
/

        
/**10 Controlar que en una partida cada jugador tiene que tener un color
distinto. (Se podría controlar en el apartado 3). **/

create or replace trigger comprobar_color
before insert on juega 
for each row
declare 
          v_color_count number;
begin 
        
        -- Contar las veces que los jugadores tiene el mismo color en la partida
        select count(*)
        into v_color_count
        from juega
        where nombre_competicion = :new.nombre_competicion
                and fecha_competicion = :new.fecha_competicion
                and jornada = :new.jornada
                and color_ficha = :new.color_ficha;
                
      if v_color_count > 0 then 
            raise_application_error(-20003, ' Cada jugador debe de tener un  color difrente');
      end if;
end;
/

INSERT INTO juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
VALUES ('PARTIDA PARCHÍS LIMA', TO_DATE('10-11-2024', 'DD-MM-YYYY'), TO_DATE('17-11-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS'),'003','ROJO');


delete from juega
where n_jugador ='003' and fecha_competicion =  TO_DATE('10-11-2024', 'DD-MM-YYYY');

drop trigger mostrar_partidas_jugador;

/** 11 Listado de los participantes en una determinada competición. **/

create or replace procedure listado_parti_compe(nombre_comp varchar2) --Parametro de entrada
as
cursor c_parti is -- Creamos un cursor para seleccionar los participantes de una competicion especifica
  select p.asociado, p.nombre, p.ap1, p.ap2, p.correo_electronico, p.telefono, p.tipo_via, p.num_via, p.nombre_via, p.bloque, p.escalera, p.planta, p.puerta, p.seccion, p.nombreloc, p.nombreprov
  from participantes p
  join jugador j on p.asociado = j.n_jugador
  join juega ju on j.n_jugador = ju.n_jugador
  where ju.nombre_competicion = nombre_comp;
  
  v_parti c_parti%rowtype; -- Declaramos una variable del tipo del cursos para almacenar los resultados del cursor
  
begin
  open c_parti; -- Abrimos cursor
    fetch c_parti into v_parti; -- Obtenemos la primera fila del cursor
    
    if c_parti%notfound then -- Si no se ha encontrado datos.
   dbms_output.put_line('El participante no existe en esa competicion o la competicion no existe');
  else 
  -- Recorremos las filas del cursor mientras haya resultados
    while c_parti%found loop
      -- Imprimimos los detalles del participante utilizando dbms
      dbms_output.put_line('Numero Asociado: '||v_parti.asociado);
      dbms_output.put_line('Nombre: '||v_parti.nombre);
      dbms_output.put_line('Primer Apellido: '||v_parti.ap1);
      dbms_output.put_line('Segundo Apellido: '||v_parti.ap2);
      dbms_output.put_line('Correo electronico: '||v_parti.correo_electronico);
      dbms_output.put_line('Telefono: '||v_parti.telefono);
      dbms_output.put_line('Tipo de via: '||v_parti.tipo_via);
      dbms_output.put_line('Numero de via: '||v_parti.num_via);
      dbms_output.put_line('Nombre de via: '||v_parti.nombre_via);
      dbms_output.put_line('Bloque: ' || v_parti.bloque);
      dbms_output.put_line('Escalera: ' || v_parti.escalera);
      dbms_output.put_line('Planta: ' || v_parti.planta);
      dbms_output.put_line('Puerta: ' || v_parti.puerta);
      dbms_output.put_line('Sección: ' || v_parti.seccion);
      dbms_output.put_line('Localidad: ' || v_parti.nombreloc);
      dbms_output.put_line('Provincia: ' || v_parti.nombreprov);
      fetch c_parti into v_parti; -- Obtenemos la siguiente fila del cursor
    end loop;
    end if;
    close c_parti;
end;
/

execute listado_parti_compe('PARTIDA PARCHÍS LIMA');

select count(p.*), pa.n_jugador_gana
  from participantes p
  join partida pa on p.asociado = pa.n_jugador_gana
  having count(pa.n_jugador_gana) => 3 ;

/** 12 ¿Quién ha ganado una determinada competición? **/
create or replace procedure ganador_competicion (
    v_nombre_competicion in varchar2,
    v_fecha_competicion in date
)
as
    v_ganador varchar2(3);
begin
    -- obtener el ganador de la competición
    select n_jugador_gana into v_ganador
    from (select n_jugador_gana, count(*) 
              from partida
              where nombre_competicion = v_nombre_competicion
                    and fecha_competicion = v_fecha_competicion
              group by n_jugador_gana
              having count(*) >= 3);

    -- mostrar el ganador si lo hay
    if v_ganador is not null then
        dbms_output.put_line('el ganador de la competición ' || v_nombre_competicion || ' en la fecha ' || to_char(v_fecha_competicion) || ' es el jugador ' || v_ganador);
    else
        dbms_output.put_line('no hay un ganador definido para la competición ' || v_nombre_competicion || ' en la fecha ' || to_char(v_fecha_competicion, 'dd-mon-yyyy'));
    end if;
exception
    when no_data_found then
        dbms_output.put_line('no se encontraron partidas para la competición ' || v_nombre_competicion || ' en la fecha ' || to_char(v_fecha_competicion, 'dd-mon-yyyy'));
end;
/ 

declare
    v_nombre_competicion VARCHAR2(30) := 'PARTIDA PARCHÍS LIMA';
    v_fecha_competicion DATE := TO_DATE('10-11-2024', 'DD-MM-YYYY');
begin
    -- Llamar al procedimiento
    ganador_competicion(v_nombre_competicion, v_fecha_competicion);
end;
/

/** 13 Jugador que ha ganado más competiciones y el nombre de estas. **/

create or replace procedure jugador_mas_ganado as
cursor c_compe is -- Cursor que saca el jugador que mas gana competiciones, si hay ganador diferente en cada competición muestra cada uno de ellos
--si hay un jugador que ha ganado mas competiciones que los demas, solo muestra ese 
  select count(*) "Partidas ganadas" , pa.n_jugador_gana, p.nombre, pa.nombre_competicion
  from participantes p
  join partida pa on p.asociado = pa.n_jugador_gana
  group by n_jugador_gana, p.nombre, pa.nombre_competicion
  having count(*) = (select distinct max(count(n_jugador_gana))
                     from partida 
                     group by n_jugador_gana);
  
  v_compe c_compe%rowtype;
  
begin
  
  open c_compe;
  fetch c_compe into v_compe;-- Obtenemos la primera fila del cursor
  
   if c_compe%notfound then  -- Si no se ha encontrado datos.
   dbms_output.put_line('No se han encontrado datos');
  else 
  -- Recorremos las filas del cursor mientras haya resultados
    while c_compe%found loop
    dbms_output.put_line('Jugador que mas ha ganado: ' || v_compe.nombre);
      dbms_output.put_line('Nombre Competicion: '|| v_compe.nombre_competicion);
      fetch c_compe into v_compe;
  end loop;
  end if;
  close c_compe;
end;
/
set serveroutput on;

execute jugador_mas_ganado; 

/**16 Con el fin de garantizar el descanso de las personas encargadas del
mantenimiento de la BD, se ha decidido que desde el viernes a las 18:00
hasta el lunes 8:00 no se podrán realizar operaciones que impliquen
inserciones, modificaciones o borrados en la misma. **/

--Controlar fecha en competicion
create or replace trigger restric_fecha_comp
  before insert or update or delete
  on competicion
  for each row
begin
  if (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'vie' and to_number(to_char(sysdate, 'hh24')) >= 18) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') in ('sáb', 'dom')) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'lun' and to_number(to_char(sysdate, 'hh24')) < 8) then
    raise_application_error(-20000, 'operaciones no permitidas desde el viernes a las 18:00 hasta el lunes a las 8:00.');
  end if;
end;
/

--Controlar fecha de juega
create or replace trigger restric_fecha_juega
  before insert or update or delete
  on juega
  for each row
begin
  if (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'vie' and to_number(to_char(sysdate, 'hh24')) >= 18) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') in ('sáb', 'dom')) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'lun' and to_number(to_char(sysdate, 'hh24')) < 8) then
    raise_application_error(-20000, 'operaciones no permitidas desde el viernes a las 18:00 hasta el lunes a las 8:00.');
  end if;
end;
/

--Controlar fecha de partida
create or replace trigger restric_fecha_partida
  before insert or update or delete
  on partida
  for each row
begin
  if (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'vie' and to_number(to_char(sysdate, 'hh24')) >= 18) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') in ('sáb', 'dom')) or
     (to_char(sysdate, 'dy', 'nls_date_language=spanish') = 'lun' and to_number(to_char(sysdate, 'hh24')) < 8) then
    raise_application_error(-20000, 'operaciones no permitidas desde el viernes a las 18:00 hasta el lunes a las 8:00.');
  end if;
end;
/


/** Triger Para hacer las partidas de una competicion 6 puntos**/
create or replace trigger Trigger_partidas_competi
after insert on competicion 
REFERENCING NEW AS NEW 
FOR EACH ROW -- para cada fila insertada new
declare

begin
    -- Cuando inserta
    if inserting then
        -- Llama al procedimiento de creación de partidas para la primera ronda
        insert_partida_comp(:new.nombre, :new.fecha, 1);
        -- Llama al procedimiento de inserción de jugadores en las partidas
        inserta_jugador_partida(:new.nombre, :new.fecha, 1);
    
    end if;
    end; 
/


insert into competicion (nombre, fecha) values ('PRUEBA10', to_date('20-01-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS'));


select * from partida where nombre_competicion like upper('PRUEBA19');
select * from juega where nombre_competicion like upper('PRUEBA9');
select * from competicion;

drop trigger comprobar_color;
drop procedure ganador_competicion;
drop procedure ;



BEGIN
  FOR cur IN (SELECT object_name, object_type FROM user_objects WHERE object_type IN ('PROCEDURE', 'FUNCTION')) LOOP
    EXECUTE IMMEDIATE 'DROP ' || cur.object_type || ' ' || cur.object_name || '';
  END LOOP;
END;
/


BEGIN
  FOR cur IN (SELECT trigger_name FROM user_triggers) LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER ' || cur.trigger_name || '';
  END LOOP;
END;
/

SELECT owner, object_name, object_type
FROM all_objects
WHERE object_type = 'PROCEDURE'
ORDER BY owner, object_name;


SELECT owner, trigger_name, table_name, status
FROM all_triggers
ORDER BY owner, trigger_name;

ALTER SESSION SET nls_date_format = 'DD-MM-YYYY HH24:MI:SS';

INSERT INTO partida (nombre_competicion, fecha_competicion, jornada, jornada_fin, n_arbitro, n_jugador_gana)
VALUES ('PRUEBA5', TO_DATE('20-01-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('20-01-2024 10:01:02', 'DD-MM-YYYY HH24:MI:SS'), TO_DATE('20-01-2024 10:21:36', 'DD-MM-YYYY HH24:MI:SS'), '290', NULL);

INSERT INTO juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
VALUES ('PRUEBA5', TO_DATE('20-01-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS'),TO_DATE('20-01-2024 10:01:02', 'DD-MM-YYYY HH24:MI:SS'), '064','ROJO');


/** EJERCICIO 6 CONSULTAS **/
create or replace procedure mostrar_ganadores_competicion 
as
begin
    for r in (
        select j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion, pa.jornada
        from partida pa
        join jugador j on pa.n_jugador_gana = j.n_jugador
        join participantes p on j.n_jugador = p.asociado
        order by j.n_jugador
    ) loop
        dbms_output.put_line('Jugador: ' || r.n_jugador || ', Nombre: ' || r.nombre || ' ' || r.ap1 || ' ' || r.ap2 || ', Competición: ' || r.nombre_competicion || ', Jornada: ' || r.jornada);
    end loop;
end;
/

execute mostrar_ganadores_competicion; 

--Consulta 7, estadistica de jugador color todos, Automatizacion, insertar 5 jugador, segunda ronda etc.

/** EJERCICIO 7 CONSULTAS **/
create or replace procedure mostrar_ganador_competicion(p_nombre_competicion in varchar2) is
begin
    for i in (
        select p.nombre, pa.n_jugador_gana, count(pa.n_jugador_gana) as "partidas ganadas"
        from participantes p
        join partida pa on p.asociado = pa.n_jugador_gana
        where upper(pa.nombre_competicion) like upper(p_nombre_competicion)
        group by p.nombre, pa.n_jugador_gana
        order by count(pa.n_jugador_gana) desc
    ) loop
        dbms_output.put_line('Jugador: ' || i.n_jugador_gana || ', Nombre: ' || i.nombre || ', Nº Partidas ganadas: ' || i."partidas ganadas");
    end loop;
end;
/

execute mostrar_ganador_competicion('PARTIDA PARCHÍS LIMA'); 

/** estadistica de colores de todas las competiciones **/

create or replace procedure mostrar_porc_todas_comp
is
begin
    for c in (
        select distinct nombre_competicion
        from juega
    ) loop
        dbms_output.put_line('Competición: ' || c.nombre_competicion);

        for r in (
            select p.nombre,
                   j.n_jugador,
                   count(*) as total_jugadas,
                   round((count(case when upper(j.color_ficha) = upper('rojo') then 1 end) / count(*)) * 100, 2) as "rojo (%)",
                   round((count(case when upper(j.color_ficha) = upper('azul') then 1 end) / count(*)) * 100, 2) as "azul (%)",
                   round((count(case when upper(j.color_ficha) = upper('amarillo') then 1 end) / count(*)) * 100, 2) as "amarillo (%)",
                   round((count(case when upper(j.color_ficha) = upper('verde') then 1 end) / count(*)) * 100, 2) as "verde (%)"
            from juega j
            join participantes p on p.asociado = j.n_jugador
            where j.nombre_competicion = c.nombre_competicion
            group by j.n_jugador, p.nombre
        ) loop
            dbms_output.put_line(' ');
            dbms_output.put_line('Jugador: ' || r.nombre || ' (' || r.n_jugador || ')');
            dbms_output.put_line('Total de veces jugadas: ' || r.total_jugadas);
            dbms_output.put_line('Rojo (%): ' || r."rojo (%)");
            dbms_output.put_line('Azul (%): ' || r."azul (%)");
            dbms_output.put_line('Amarillo (%): ' || r."amarillo (%)");
            dbms_output.put_line('Verde (%): ' || r."verde (%)");
            dbms_output.put_line(' ');
        end loop;
        dbms_output.put_line('-----------------------------------');
    end loop;
end;
/

execute mostrar_porc_todas_comp;

/** automatizacion **

/** . El 30 junio se da por finalizada la temporada de competiciones y se quiere
almacenar en la tabla “Partida ganadores”, los jugadores que han ganado
alguna partida con el fin de poder generarle un diploma. Decide si quieres
almacenar la información de todas las competiciones juntas o por
competición. (hacer tabla aparte.) **/

create or replace procedure almacenar_ganadores_temporada as
begin
    -- Insertar los ganadores de la temporada en la tabla ganadores
    insert into ganadores (n_jugador, ncomp, jornada)
    select distinct p.n_jugador_gana, p.nombre_competicion, p.jornada
    from partida p
    where p.fecha_competicion < to_date('2024-07-01', 'DD-MM-YYYY HH24:MI:SS') and p.n_jugador_gana is not null;

    dbms_output.put_line('Se han almacenado los ganadores de la temporada correctamente.');
end;
/

-- Programar la ejecución del procedimiento para el 30 de junio
begin
    dbms_scheduler.create_job (
        job_name        => 'GANADORES_TEMP_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin almacenar_ganadores_temporada; end;',
        start_date      => to_timestamp_tz('2024-06-30 00:00:00 Europe/Madrid', 'YYYY-MM-DD HH24:MI:SS TZR'),
        repeat_interval => null,
        enabled         => true
    );
end;
/ 

set serveroutput on;


/** . Seguir la misma filosofía que el aparado anterior, pero para los ganadores
de la competición.**/
create or replace procedure almacenar_gan_comp as
begin
    -- Insertar los ganadores de la competición en la tabla ganadores_competicion
    insert into ganadores_competicion (n_jugador, ncomp, jornada)
    select pa.n_jugador_gana, pa.nombre_competicion, max(pa.fecha_competicion)
    from participantes p
    join partida pa on p.asociado = pa.n_jugador_gana
    group by pa.n_jugador_gana, pa.nombre_competicion
    having count(*) = (select max(cnt)
                       from (select count(n_jugador_gana) as cnt
                             from partida 
                             group by n_jugador_gana));
                             
    dbms_output.put_line('Se han almacenado los ganadores de la competición correctamente.');
end;
/

begin
    dbms_scheduler.create_job (
        job_name        => 'ALMACENAR_GAN_COMPE',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin almacenar_gan_comp; end;',
        start_date      => to_timestamp_tz('2023-06-30 00:00:00 Europe/Madrid', 'YYYY-MM-DD HH24:MI:SS TZR'),
        repeat_interval => null,
        enabled         => true
    );
end;
/





-- Creación de un disparador que se encargue de crear todas las 
-- partidas de una copmpetición
--Disparador creación partidas
-- TODO


create or replace trigger Trigger_partidas_competi
after insert on competicion 
REFERENCING NEW AS NEW 
FOR EACH ROW -- para cada fila insertada new
declare

begin
    -- Cuando inserta
    if inserting then
        -- Llama al procidimiento de creación de partida
        insert_partida_comp(:new.nombre, :new.fecha, 1);
        -- Llama al procedimineto de insercción de jugadores en partida
        inserta_jugador_partida(:new.nombre , :new.fecha, 1);
    
    end if;
    
end; 
/




