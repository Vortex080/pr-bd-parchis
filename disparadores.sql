set serveroutput on;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';






-- Insert prueba competición

insert into competicion(nombre, fecha)
values ('prueba1', to_char(sysdate) );

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
        
        f_i := f_f;
        
        DBMS_OUTPUT.PUT_LINE('Partida creada' || i );
    end loop;
    
END; 
/ 


