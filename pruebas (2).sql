create or replace procedure inserta_jugador_partida(ncomp varchar2) 
as
    -- Variable de jugador ya insertado
    v_jugado varchar2;
    -- Varible de arbitro ya insertado
    v_arbitrando varchar2;
    -- Variable jugador no insertado
    v_jugador varchar2;
    -- Variable temporal incrementable
    v_i number := 1;
    -- Variable temporal incrementable
    v_j number := 1;
    -- Variable booleana para verificar si se a insertado
    v_val boolean := false;

begin 
   
   -- Bucle 4 veces una por jugador
   for i in 1..4 
   loop
        
        while v_val = true
        loop
            -- Select saca todas partidas con albtros y jugadores
            select j.n_jugador, p.n_arbitro into v_jugado, v_arbitrando
            from juega j join partida p on p.nombre_competicion = j.nombre_competicion
            where j.nombre_competicion like upper(ncomp) -- verificamos que la competición es la insertada
                    and j.jornada = p.jornada -- La jornada debe ser la misma en cada tupla de juega y de partida
                    and v_i = SQL%rownum; -- Row num para oder mover por la tabla hasat encotnrar un jugador bueno
            
            while v_val = true or v_j = (select to_number(max(asociado)) from participantes)
            loop
            
                -- Select saca todos los participantes 
                select asociado into v_jugador
                from participantes;
                
                if (v_jugador not like v_arbitro ) then 
                    if (v_jugador not like v_jugando) then
                        
                        
                        INSERT INTO jugador(n_jugador)
                            (SELECT asociado FROM participantes where SQL%rownum = v_j);
                                                
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