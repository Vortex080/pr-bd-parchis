create or replace procedure insert_partida_comp(ncomp varchar2, fecha date, ronda number)
as 
    -- Fecha +1 inicial
    f_i number := 1;
    
    -- Fecha final +20 
    f_f number := 0;

    -- Números de partidas de la ronda
    n_ronda number ;
    
    -- Número maximo de jugadores
    v_max number;
    
    -- Codigo del arbitro
    n_arbitro varchar2(3);
    v_temp date;
    

begin 

    -- Case para elegir el número de partidas por ronda
        case ronda
            when 1
                then n_ronda := 16;
            when 2
                then n_ronda := 4;
            when 3
                then n_ronda := 1;
        end case;


            if (n_ronda = 4)
            then
            

                f_i := f_i + 7*1400;
                f_f := f_f + 7*1400;
                
            
            end if;
            
            if (n_ronda = 1)
            then
                
                f_i := f_i + 60*1400;
                f_f := f_f + 60*1400;
            
            end if;

        -- bucle para las partidas
        for i in 1..n_ronda
        loop
            
            -- Calculo de fechas
                f_i := f_i /1400;
                f_f := ((f_i*1400)+20) /1400;
                
            -- Select saca el número maximo de jugadores
            select count(*)-i into v_max
            from participantes;
        
            -- Select para sacar los arbitros
            select max(asociado) into n_arbitro
                    from (
                        select asociado, rownum as rnum
                        from participantes
                        where rownum <= v_max)
            where rnum = v_max;
        
            -- La fecha de la competición debera ser insertada con hora de inicio

            insert into partida (nombre_competicion, fecha_competicion, jornada, jornada_fin, n_arbitro, n_jugador_gana)
            values (
                ncomp,
                fecha, -- fecha de la competición 
                fecha + f_i, -- agrega i minutos a la fecha a la jornada de inicio
                fecha +  f_f, -- agrega i + 20 minutos a la fecha de la jornada fin
                n_arbitro, -- n_albitro 
                null -- n_jugador_gana 
            );
            
            
            f_i := f_f * 1400;
            
            DBMS_OUTPUT.PUT_LINE('Partida creada' || i );
        end loop;

end;
/