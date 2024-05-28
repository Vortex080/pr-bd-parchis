create or replace procedure insert_ganador_partida_man(ncomp2 varchar2, jor date, n_jug varchar2)
as

    -- Variable jugador
    v_jugador varchar2(3);
    -- Fecha dela jornada
    v_jor date;
    
    y number;

begin 
    -- Bucle primera rond 
            -- Select jornada
                
                update partida 
                set n_jugador_gana = n_jug
                where nombre_competicion = ncomp2 and 
                    jornada = jor;
                    
                insert into ganadores (n_jugador, ncomp, jornada)
                values (v_jugador, ncomp2, jor);
            
end;
/