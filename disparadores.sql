/*

    DISPARADORES / FUNCIONES / PROCEDIMIENTOS

*/

-- Formato y activador out put servidor
set serveroutput on;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

-- Disparador para controlar que el DNI sea correcto
-- En este caso usa ID en vez de DNI

create or replace trigger trigger_participantes_id
before insert 
on participantes
referencing new as 
new for each row -- por cada fila insertada

begin 
    -- Bucle para verificar cuando inserta
    if inserting then
        -- Bucle para verificar que el ID no se null ni este vacio
        if (:new.asociado is not null or :new.asociado not like '') then

            -- Bucle para verificar que el Id no existe
            if (to_number(:new.asociado) > num_max_asociado) then
                
                insert into participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
                values (:new.asociado, :new.nombre, :new.ap1, :new.ap2, :new.correo_electronico, :new.telefono, :new.tipo_via, :new.num_via,:new.nombre_via, :new.bloque, :new.escalera, :new.planta, :new.puerta, :new.seccion, :new.nombreloc, :new.nombreprov);
                
            else 
                -- ERROR
                    raise_application_error(-20001, 'El id insertado ya existe');
                
            end if;  
        
         else
            -- ERROR
            raise_application_error(-20003, 'El id no puede estar vacio');
        
        end if; 

    end if;

end;
/


/*

    Función devuelve el id mas alto

*/
create or replace function num_max_asociado return number
as 

    n_max number;

begin
    
    select max(to_number(asociado)) into n_max
    from participantes;

    return n_max;

end;
/


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

create or replace procedure listar_partidas_por_realizadar
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
        where p.jornada > sysdate
        order by c.nombre, p.jornada
    ) loop
        dbms_output.put_line('Competición: ' || r.competicion || ', Fecha: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY') || ', Jornada: ' || r.jornada || ', Jornada Fin: ' || to_char(r.jornada_fin, 'DD-MM-YYYY') || ', Árbitro: ' || r.n_arbitro || ', Jugador Gana: ' || r.n_jugador_gana);
    end loop;

end;
/

--5D

create or replace procedure listar_partidas_programadas 
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
        where p.jornada > sysdate
        order by c.nombre, p.jornada
    ) loop
        dbms_output.put_line('Competición: ' || r.competicion || ', Fecha: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY') || ', Jornada: ' || r.jornada || ', Jornada Fin: ' || to_char(r.jornada_fin, 'DD-MM-YYYY') || ', Árbitro: ' || r.n_arbitro || ', Jugador Gana: ' || r.n_jugador_gana);
    end loop;
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
        dbms_output.put_line('Competición: ' || r.competicion || ', Fecha: ' || to_char(r.fecha_competicion, 'DD-MM-YYYY') || ', Jornada: ' || r.jornada || ', Jornada Fin: ' || to_char(r.jornada_fin, 'DD-MM-YYYY') || ', Árbitro: ' || r.n_arbitro || ', Jugador Gana: ' || r.n_jugador_gana);
    end loop;

end;
/

--5F



-- Creación de un disparador que se encargue de crear todas las 
-- partidas de una copmpetición
--Disparador creación partidas
-- TODO
CREATE OR REPLACE TRIGGER Trigger_partidas_competi
after INSERT ON competicion 
REFERENCING NEW AS NEW FOR EACH ROW -- para cada fila insertada new
declare
    f_i number := 1;
    f_f number := 0;

BEGIN 

    for i in 1..16 
    loop
        
        f_i := f_i /1400;
        f_f := (f_i+20) /1400;
    
        -- La fecha de la competición debera ser insertada con hora de inicio
        insert into partida (nombre_competicion, fecha_competicion, jornada, jornada_fin, n_arbitro, n_jugador_gana)
        values (
            :new.nombre,
            :new.fecha, -- fecha de la competición 
            :new.fecha + f_i, -- agrega i minutos a la fecha a la jornada de inicio
            :new.fecha +  f_f, -- agrega i + 20 minutos a la fecha de la jornada fin
            '001', -- n_albitro 
            null -- n_jugador_gana 
        );
        
        inserta_jugador_partida(:new.nombre , :new.fecha, :new.fecha + f_i);
        
        f_i := f_f;
        
        DBMS_OUTPUT.PUT_LINE('Partida creada' || i );
    end loop;
    
END; 
/ 

-- Procedimiento jugadores y albitros

create or replace procedure inserta_jugador_partida(ncomp varchar2, fcomp date, jor date) 
as
    -- Variable de jugador ya insertado
    v_jugado varchar2(3) := null;
    -- Varible de arbitro ya insertado
    v_arbitrando varchar2(3) := null;
    -- Variable jugador no insertado
    v_jugador varchar2(3) := null;
    -- Variable temporal incrementable
    v_i number := 1;
    -- Variable temporal incrementable
    v_j number := 1;
    -- Variable booleana para verificar si se a insertado
    v_val boolean := false;
    -- Variable ID maximo de asociado
    v_max number := 0;
    -- Variable número de la ficha
    v_ficha number := 0;
    -- Variable para el color de la ficha
    v_color varchar2(10);

  begin 
   
   -- Bucle 4 veces una por jugador
   for i in 1..4 
   loop
         DBMS_OUTPUT.PUT_LINE('bucle');
        while v_val = false
        loop
             DBMS_OUTPUT.PUT_LINE('while 1');
             
             -- Select saca todas partidas con albtros y jugadores
                select j.n_jugador, p.n_arbitro into v_jugado, v_arbitrando
                from juega j join partida p on p.nombre_competicion = j.nombre_competicion
                where upper(j.nombre_competicion) like upper(ncomp) -- verificamos que la competición es la insertada
                        and j.jornada = p.jornada -- La jornada debe ser la misma en cada tupla de juega y de partida
                        and rownum = v_i; -- Row num para oder mover por la tabla hasat encotnrar un jugador bueno
             
             if ((select n_jugador from juega) != null or (select n_jugador from juega) not like '') then
                      
                -- Introduce en v_max el numero de asociado
                select to_number(max(asociado)) into v_max
                from participantes;
                
                -- El while verifica si se a insertado el jugador o a llegado al número maximo de participantes
                while v_val = false or v_j = v_max
                loop
                 DBMS_OUTPUT.PUT_LINE('while');
                    -- Select saca todos los participantes 
                    select asociado into v_jugador
                    from participantes
                    where rownum = v_j;
                    
                    if (v_jugador not like v_arbitrando or v_arbitrando = null) then 
                         DBMS_OUTPUT.PUT_LINE('if arbitro');
                        if (v_jugador not like v_jugado or v_jugado = null) then
                                                 DBMS_OUTPUT.PUT_LINE('if jugador');
                            -- Select con random value para sacar el numero de la ficha
                            select ceil(DBMS_RANDOM.VALUE(0, 4)) into v_ficha
                            from dual;
                            
                            -- Case para convertir el numero random en el color correspondiente
                            case v_ficha
                            
                                when 1 
                                    then v_color := 'AZUL';
                                when 2 
                                    then v_color := 'ROJO';
                                when 3
                                    then v_color := 'AMARILLO';
                                when 4
                                    then v_color := 'VERDE';
                            end case;
                            
                            -- Insertamos el jugador en la partida
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, jor, v_jugador, v_color);
                            
                            DBMS_OUTPUT.PUT_LINE('Jugador insertado');
                                                    
                            v_val := true;
                        end if;
                    end if;
                    v_j := v_j + 1;
                end loop;
             
             else 
             
                if (v_jugador not like v_arbitrando or v_arbitrando = null) then 
                         DBMS_OUTPUT.PUT_LINE('if arbitro');
                        if (v_jugador not like v_jugado or v_jugado = null) then
                                                 DBMS_OUTPUT.PUT_LINE('if jugador');
                            -- Select con random value para sacar el numero de la ficha
                            select ceil(DBMS_RANDOM.VALUE(0, 4)) into v_ficha
                            from dual;
                            
                            -- Case para convertir el numero random en el color correspondiente
                            case v_ficha
                            
                                when 1 
                                    then v_color := 'AZUL';
                                when 2 
                                    then v_color := 'ROJO';
                                when 3
                                    then v_color := 'AMARILLO';
                                when 4
                                    then v_color := 'VERDE';
                            end case;
                            
                            -- Insertamos el jugador en la partida
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, jor, v_jugador, v_color);
                            
                            DBMS_OUTPUT.PUT_LINE('Jugador insertado');
                                                    
                            v_val := true;
                        end if;
                    end if;
             
             end if;
             
           
            v_i := v_i + 1;
        end loop;
   end loop;
end; 
/



