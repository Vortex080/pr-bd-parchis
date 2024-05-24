-- Testeo trigger participantes

-- ID no puede estar vacio
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- ID existe
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('002', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- Test insertar conpetición
INSERT INTO competicion (nombre, fecha) VALUES ('antonio7', '14-11-2024 10:00:00');


delete partida where nombre_competicion like 'prueba5';
delete juega where nombre_competicion like 'TORNEO PARCHÍS CORAL';
delete ganadores;

execute inserta_jugador_partida('TORNEO PARCHÍS CORAL' , TO_DATE('01-11-2024', 'DD-MM-YYYY') , TO_DATE('01-11-2024 10:40:00', 'DD-MM-YYYY HH24:MI:SS'));

select * from juega where nombre_competicion like 'antonio6';
select * from partida where nombre_competicion like 'antonio7';
select * from ganadores;

                select n_arbitro
                from partida
                where upper(nombre_competicion) like upper('TORNEO PARCHÍS CORAL') and 
                        rownum = 1;
select * from arbitro where n_arbitro like '102';
alter table partida disable constraint PARTIDA_PK;

            select narbi
                      from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                            from partida
                            where rownum <= 5
                            and nombre_competicion like upper('TORNEO PARCHÍS CORAL') )
            where rnum = 5;

 select asociado
                    from participantes
                    where rownum = 1;
                    
    select count(*)
    from juega
    where nombre_competicion = 'TORNEO PARCHÍS CORAL';

execute prueba;
commit;
select * from jugador where n_jugador = 55;

select j.n_jugador, p.n_arbitro
            from juega j join partida p on p.nombre_competicion = j.nombre_competicion
            where upper(j.nombre_competicion) like upper('TORNEO PARCHÍS CORAL') -- verificamos que la competición es la insertada
                    and j.jornada = p.jornada;
commit;
select * from competicion; 
execute insert_partida_comp('prueba5' , TO_DATE('10/02/2000 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 1);
execute inserta_jugador_partida('prueba5' , TO_DATE('10/02/2000 10:00:00', 'DD-MM-YYYY HH24:MI:SS'));
execute insert_ganador_partida_auto('antonio7', 3);


         select njug
         from (select n_jugador as njug, rownum as rnum
                from juega
                where rownum <= 2
                    and nombre_competicion like 'antonio6' 
                    and jornada = '14/11/2024 10:01:02'
                    )
        where rnum = 2;
        
commit;

create or replace procedure prueba
as 

     f_i number := 1;
    f_f number := 0;

begin 


    for i in 1..16 
    loop
        
        f_i := f_i /1400;
        f_f := ((f_i*1400)+20) /1400;
    
       
 
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
        
        f_i := f_f * 1400;
        
        DBMS_OUTPUT.PUT_LINE('Partida creada' || i || ' ' ||f_i);
    end loop;

end;
/


            select j.n_jugador, p.n_arbitro
                from juega j join partida p on p.nombre_competicion = j.nombre_competicion
                where upper(j.nombre_competicion) like upper('TORNEO PARCHÍS CORAL') -- verificamos que la competición es la insertada
                        and j.jornada = p.jornada -- La jornada debe ser la misma en cada tupla de juega y de partida
                        and rownum = 1; -- Row num para oder mover por la tabla hasat encotnrar un jugador bueno
                        
                        
                                            
                    select asociado
                    from (
                        select asociado, rownum as rnum
                        from participantes
                        where rownum <= 3
                    )
                    where rnum = 3;
                    
                    select * from partida 
                    
                select narb
                  from (select n_arbitro as narbi, rownum as rnum, nombre_competicion as ncomp
                        from partida
                        where rownum <= 2
                        and nombre_competicion like upper('TORNEO PARCHÍS CORAL') )
                where rnum = 2;
                                            
                          select asociado
                    from participantes
                    where rownum = 2;
                    
                    
                     select njug 
                  from (select n_jugador as njug, rownum as rnum, nombre_competicion as ncomp
                        from juega
                        where rownum <= 3
                        and nombre_competicion like upper('TORNEO PARCHÍS CORAL') )
                        where rnum = 3;
                        
                        
                                select asociado
                    from (
                        select asociado, rownum as rnum
                        from participantes
                        where rownum <= 1
                        order by asociado desc)
            where rnum = 1;
            
            
            select count(*)
            from jugador;
            
            
            select narbi 
                from (select n_arbitro as narbi, rownum as rnum, nombre_competicion
                            from partida
                            where rownum <= 1
                            and nombre_competicion like 'sdfsdfsafd' )
            where rnum = 1;