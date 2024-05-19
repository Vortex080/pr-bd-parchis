-- Testeo trigger participantes

-- ID no puede estar vacio
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- ID existe
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('002', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- Test insertar conpetición
INSERT INTO competicion (nombre, fecha) VALUES ('TORNEO PARCHÍS CORAL', '01-11-2024');


delete partida where nombre_competicion like 'TORNEO PARCHÍS CORAL';
delete juega where nombre_competicion like 'TORNEO PARCHÍS CORAL';

execute inserta_jugador_partida('TORNEO PARCHÍS CORAL' , TO_DATE('01-11-2024', 'DD-MM-YYYY') , TO_DATE('01-11-2024 10:40:00', 'DD-MM-YYYY HH24:MI:SS'));

select * from juega where nombre_competicion like 'TORNEO PARCHÍS CORAL';
select * from partida where nombre_competicion like 'TORNEO PARCHÍS CORAL';

                select n_arbitro
                from partida
                where upper(nombre_competicion) like upper('TORNEO PARCHÍS CORAL') and 
                        rownum = 1;


 select asociado
                    from participantes
                    where rownum = 1;
                    
    select count(*)
    from juega
    where nombre_competicion = 'TORNEO PARCHÍS CORAL';

execute prueba;

select j.n_jugador, p.n_arbitro
            from juega j join partida p on p.nombre_competicion = j.nombre_competicion
            where upper(j.nombre_competicion) like upper('TORNEO PARCHÍS CORAL') -- verificamos que la competición es la insertada
                    and j.jornada = p.jornada;

execute inserta_jugador_partida('TORNEO PARCHÍS CORAL' , TO_DATE('01-11-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , TO_DATE('01-11-2024 10:20:00', 'DD-MM-YYYY HH24:MI:SS'));

create or replace procedure prueba
as 

     f_i number := 1;
    f_f number := 0;

begin 


    for i in 1..16 
    loop
        
        f_i := f_i /1400;
        f_f := ((f_i*1400)+20) /1400;
    
       
 
        inserta_jugador_partida('TORNEO PARCHÍS CORAL' , TO_DATE('01-11-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , TO_DATE('01-11-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS') + f_i);
        
        f_i := f_f * 1400;
        
        DBMS_OUTPUT.PUT_LINE('Partida creada' || i );
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
                                            
                          select asociado
                    from participantes
                    where rownum = 2;