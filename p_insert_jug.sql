create or replace procedure inserta_jugador_partida(ncomp varchar2, fcomp date, ronda number)
as 
    -- Variable para el calculo de las fechas
    f_i number := 1;
    -- Variable para el calculo de las fechas
    f_f number := 0;
    -- Varible de arbitro ya insertado
    v_arbitrando varchar2(3) := null;
    -- Variable jugador no insertado
    v_jugador varchar2(3) := null;
    -- Variable número de la ficha
    v_ficha number := 0;
    -- Variable para el color de la ficha
    v_color varchar2(10);
    -- Jugador mas bajo en el que empieza la partida
    minj number := 1;
    -- Jugador maximo en el que termina la partida
    maxj number := 4;
    
    

begin 

    case ronda
        when 1
            then   
             
             for i in 1..16
             loop
             
                -- Cojemos dividimos 1 entre 1400 para pasarlo a minutos
                f_i := f_i /1400;
                -- Cojemos y le añadimos 20 min y lo pasamos a minutos
                f_f := ((f_i*1400)+20) /1400;
                
                -- Bucle para los jugadores entre el minimo y el maximo
                for k in minj..maxj
                loop
                
                    -- Select saca el albitro de la partida
                    select narbi into v_arbitrando
                              from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                                    from partida
                                    where rownum <= i
                                    and nombre_competicion like ncomp )
                    where rnum = i;
                    
                     -- Saca el jugaodr a insertar
                    select asociado into v_jugador
                                from (select asociado, rownum as rnum
                                    from participantes
                                    where rownum <= k)
                    where rnum = k;
                    
                     -- Verifica que el jugador no es albitro de esa partida
                    if (v_jugador not like v_arbitrando) then
                    
                        -- Añadimos un número a la ficha cada vez que pasa el bucle
                        v_ficha := v_ficha+1;
                        -- Verifica si ficha es mayor de 4 y lo restablece a uno
                        if (v_ficha > 4) then
                        
                            v_ficha := 1;
                            
                        end if;
                     -- Case dependiendo de v_ficha y cogemos un color u otro
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
                            
                            -- Insertamos el jugador
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, fcomp+f_i, v_jugador, v_color);
                                 
                        
                        end if;
                
                end loop;
                
                -- Sumamos cuando termine con una partida añada un minimo y un maximo de +4 jugadores 
                -- para la siguiente partida
                minj := minj+4;
                maxj := maxj+4;
                
                -- Claculo de minutos para ir sumando
                f_i := f_f * 1400;
             
             end loop;
             

            
        when 2
            then 
            
             for i in 1..4
             loop
             
                -- Cojemos dividimos 1 entre 1400 para pasarlo a minutos
                f_i := f_i /1400;
                -- Cojemos y le añadimos 20 min y lo pasamos a minutos
                f_f := ((f_i*1400)+20) /1400;
                
                -- Bucle para los jugadores entre el minimo y el maximo
                for k in minj..maxj
                loop
                
                    -- Select saca el albitro de la partida
                    select narbi into v_arbitrando
                              from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                                    from partida
                                    where rownum <= i
                                    and nombre_competicion like ncomp )
                    where rnum = i;
                    
                     -- Saca el jugaodr a insertar
                    select asociado into v_jugador
                                from (select asociado, rownum as rnum
                                    from participantes
                                    where rownum <= k)
                    where rnum = k;
                    
                     -- Verifica que el jugador no es albitro de esa partida
                    if (v_jugador not like v_arbitrando) then
                    
                        -- Añadimos un número a la ficha cada vez que pasa el bucle
                        v_ficha := v_ficha+1;
                        
                        -- Verifica si ficha es mayor de 4 y lo restablece a uno
                        if (v_ficha > 4) then
                        
                            v_ficha := 1;
                            
                        end if;
                     -- Case dependiendo de v_ficha y cogemos un color u otro
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
                            
                            -- Insertamos el jugador
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, fcomp+f_i, v_jugador, v_color);
                                 
                        
                        end if;
                
                end loop;
                
                              
                -- Sumamos cuando termine con una partida añada un minimo y un maximo de +4 jugadores 
                -- para la siguiente partida
                minj := minj+4;
                maxj := maxj+4;
                
                -- Claculo de minutos para ir sumando
                f_i := f_f * 1400;
             
             
             end loop;
             
        
        when 3
            then
                
            for i in 1..4
             loop
             
                -- Cojemos dividimos 1 entre 1400 para pasarlo a minutos
                f_i := f_i /1400;
                -- Cojemos y le añadimos 20 min y lo pasamos a minutos
                f_f := ((f_i*1400)+20) /1400;
                
                -- Bucle para los jugadores entre el minimo y el maximo
                for k in minj..maxj
                loop
                
                    -- Select saca el albitro de la partida
                    select narbi into v_arbitrando
                              from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                                    from partida
                                    where rownum <= i
                                    and nombre_competicion like ncomp )
                    where rnum = i;
                    
                     -- Saca el jugaodr a insertar
                    select asociado into v_jugador
                                from (select asociado, rownum as rnum
                                    from participantes
                                    where rownum <= k)
                    where rnum = k;
                    
                     -- Verifica que el jugador no es albitro de esa partida
                    if (v_jugador not like v_arbitrando) then
                    
                        -- Añadimos un número a la ficha cada vez que pasa el bucle
                        v_ficha := v_ficha+1;
                        
                        -- Verifica si ficha es mayor de 4 y lo restablece a uno
                        if (v_ficha > 4) then
                        
                            v_ficha := 1;
                            
                        end if;
                     -- Case dependiendo de v_ficha y cogemos un color u otro
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
                            
                            -- Insertamos el jugador
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, fcomp+f_i, v_jugador, v_color);
                                 
                        
                        end if;
                
                end loop;
                                
                    -- Sumamos cuando termine con una partida añada un minimo y un maximo de +4 jugadores 
                    -- para la siguiente partida
                    minj := minj+4;
                    maxj := maxj+4;
                    
                    -- Claculo de minutos para ir sumando
                    f_i := f_f * 1400;
             
             end loop;
                
        end case; 
        

end;
/