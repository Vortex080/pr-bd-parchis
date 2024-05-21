create or replace procedure inserta_jugador_partida(ncomp varchar2, fcomp date, jor date)
as

    v_jugador varchar2(3);
    v_arbitrando varchar2(3);
    v_ficha number;
    v_color varchar2(10);

begin

    for i in 1..4
    loop
    
        select narbi into v_arbitrando
                  from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                        from partida
                        where rownum <= i
                        and nombre_competicion like upper(ncomp) )
        where rnum = i;
        
        
        select asociado into v_jugador
                    from (select asociado, rownum as rnum
                        from participantes
                        where rownum <= i)
        where rnum = i;
        
        if (v_jugador not like v_arbitrando) then
        
            for j in 1..4
            loop
            
                v_ficha := j;
                                                
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
            
            
            end loop;
        
        end if;
    
    end loop;



end;
/