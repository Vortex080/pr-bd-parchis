create or replace procedure insert_ganador_partida_auto(ncomp2 varchar2)
as

    -- Variable jugador
    v_jugador varchar2(3);
    -- Fecha dela jornada
    v_jor date;
    
    y number;

begin 
    -- Bucle primera rond 
        for i in 1..16
        loop
        
            -- Select jornada
            select jor into v_jor
             from (select jornada as jor, rownum as rnum 
                    from partida 
                    where rownum <= i  
                    and nombre_competicion like ncomp2)
            where rnum = i;
            DBMS_OUTPUT.PUT_LINE( i || ' ' || v_jor);
            -- Select para sacar los jugadores que juegan en esa partida

             select njug into v_jugador
             from (select n_jugador as njug, rownum as rnum, nombre_competicion as ncomp
                    from juega
                    where rownum <= 1
                        and nombre_competicion like ncomp2
                        and jornada = v_jor)
            where rnum = 1;
                
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