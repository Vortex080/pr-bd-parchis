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
    v_z number := 1;
    -- Variable booleana para verificar si se a insertado
    v_val boolean := false;
    -- Variable ID maximo de asociado
    v_max number := 0;
    -- Variable número de la ficha
    v_ficha number := 0;
    -- Variable para el color de la ficha
    v_color varchar2(10);
    -- Variable temporal para verficar que existen jugadores
    v_t_jug number := 0;

  begin 
   
    select to_number(count(*)) into v_t_jug
    from juega
    where nombre_competicion = upper(ncomp);

   
   -- Bucle 4 veces una por jugador
   for i in 1..4 
   loop
   
        while v_val = false
        loop
             
             if (v_t_jug != 0) then
                      DBMS_OUTPUT.PUT_LINE('entra nomral' || ' ' || v_i);
                  -- Select saca todas partidas con albtros y jugadores
                  
                  select n_jugador into v_jugado
                  from juega
                  where  upper(nombre_competicion) like upper(ncomp) -- verificamos que la competición es la insertada
                        and rownum = v_i;
                        
                  select n_arbitro into v_arbitrando
                  from partida
                  where  upper(nombre_competicion) like upper(ncomp) -- verificamos que la competición es la insertada
                        and rownum = v_i;
                  
                
                -- Introduce en v_max el numero de asociado
                select to_number(max(asociado)) into v_max
                from participantes;
 
                -- El while verifica si se a insertado el jugador o a llegado al número maximo de participantes
                while v_val = false or v_j = v_max
                loop
                 DBMS_OUTPUT.PUT_LINE('v_j ' || v_j);
                    -- Select saca todos los participantes 
                    select asociado into v_jugador
                    from (
                        select asociado, rownum as rnum
                        from participantes
                        where rownum <= v_j
                    )
                    where rnum = v_j;
                                        
                    if (v_jugador not like v_arbitrando or v_arbitrando = null) then 
                        if (v_jugador not like v_jugado or v_jugado = null) then
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
                            
                            DBMS_OUTPUT.PUT_LINE(ncomp ||' '  ||fcomp ||' '  || jor ||' '  || v_jugador || ' ' || v_color);
                            
                            -- Insertamos el jugador en la partida
                            insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, jor, v_jugador, v_color);
                            
                            DBMS_OUTPUT.PUT_LINE('Jugador insertado normal');
                                                    
                            v_val := true;
                        end if;
                    end if;
                    v_j := v_j + 1;
                end loop;
             
             else 
             
                    
              while v_val = false or v_z = v_max
                loop
                            select asociado into v_jugador
                            from participantes
                            where rownum = v_z;
                
                
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
                            
                            DBMS_OUTPUT.PUT_LINE(ncomp ||' '  ||fcomp ||' '  || jor ||' '  || v_jugador || ' ' || v_color);
                            
                            
                            -- Insertamos el jugador en la partida
                           insert into juega (nombre_competicion, fecha_competicion, jornada, n_jugador, color_ficha)
                            values (ncomp, fcomp, jor, v_jugador, v_color);
                            

                            
                            DBMS_OUTPUT.PUT_LINE('Jugador insertado else');
                                                    
                            v_val := true;
                    v_z := v_z + 1;

                end loop;
             
             end if;
             
           
            v_i := v_i + 1;
            commit;
        end loop;
   end loop;
end; 
/

drop procedure inserta_jugador_partida;

 