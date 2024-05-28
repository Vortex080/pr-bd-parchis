create or replace procedure insert_ganador_partida_auto2(ncomp2 varchar2)
as

    -- Variable jugador
    v_jugador varchar2(3);
    -- Fecha dela jornada
    v_jor date;
    
    k number;

begin 
    -- Bucle primera rond 
        for i in 1..4
        loop
        
            
        
            i := k+16;
        
            -- Select jornada
            select jor into v_jor
             from (select jornada as jor, rownum as rnum 
                    from partida 
                    where rownum <= k  
                    and nombre_competicion like ncomp2)
            where rnum = k;
            DBMS_OUTPUT.PUT_LINE( i || ' ' || v_jor);
            -- Select para sacar los jugadores que juegan en esa partida

             select njug into v_jugador
             from (select n_jugador as njug, rownum as rnum, nombre_competicion as ncomp
                    from juega
                    where rownum <= k
                        and nombre_competicion like ncomp2
                        and jornada = v_jor)
            where rnum = k;
                
                update partida 
                set n_jugador_gana = v_jugador
                where nombre_competicion = ncomp2 and 
                    jornada = v_jor;
                    
                insert into ganadores (n_jugador, ncomp)
                values (v_jugador, ncomp2);
                DBMS_OUTPUT.PUT_LINE( i || ' ' || v_jor || ' ' || v_jugador);
        end loop;
end;
/