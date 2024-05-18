create or replace procedure inserta_jugador_partida(ncomp varchar2, fcomp date, jor date) 
as
    -- Variable de jugador ya insertado
    v_jugado varchar2(3);
    -- Varible de arbitro ya insertado
    v_arbitrando varchar2(3);
    -- Variable jugador no insertado
    v_jugador varchar2(3);
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
        
        while v_val = true
        loop
            -- Select saca todas partidas con albtros y jugadores
            select j.n_jugador, p.n_arbitro into v_jugado, v_arbitrando
            from juega j join partida p on p.nombre_competicion = j.nombre_competicion
            where upper(j.nombre_competicion) like upper(ncomp) -- verificamos que la competición es la insertada
                    and j.jornada = p.jornada -- La jornada debe ser la misma en cada tupla de juega y de partida
                    and rownum = v_i; -- Row num para oder mover por la tabla hasat encotnrar un jugador bueno
                    
            -- Introduce en v_max el numero de asociado
            select to_number(max(asociado)) into v_max
            from participantes;
            
            while v_val = true or v_j = v_max
            loop
            
                -- Select saca todos los participantes 
                select asociado into v_jugador
                from participantes
                where rownum = v_j;
                
                if (v_jugador not like v_arbitrando ) then 
                    if (v_jugador not like v_jugado) then
                        
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
                                                
                        v_val := true;
                    end if;
                end if;
                v_j := v_j + 1;
            end loop;
            v_i := v_i + 1;
        end loop;
   end loop;
end; 
/