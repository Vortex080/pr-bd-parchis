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
        inserta_jugador_partida(:new.nombre , :new.fecha);
    
    end if;
    
end; 
/

-- Procedimiento insercción ganador



