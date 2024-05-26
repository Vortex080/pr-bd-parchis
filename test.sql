-- Testeo trigger participantes

-- ID no puede estar vacio
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- ID existe
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('002', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- Test insertar conpetición
INSERT INTO competicion (nombre, fecha) VALUES ('antonio40', '10-02-2003 10:00:00');


delete partida where nombre_competicion like 'antonio';
delete juega where nombre_competicion like 'TORNEO PARCHÍS CORAL';
delete ganadores;

execute inserta_jugador_partida('TORNEO PARCHÍS CORAL' , TO_DATE('01-11-2024', 'DD-MM-YYYY') , TO_DATE('01-11-2024 10:40:00', 'DD-MM-YYYY HH24:MI:SS'));

select * from juega where nombre_competicion like 'antonio10';
select * from partida where nombre_competicion like 'antonio10';
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
execute insert_partida_comp('antonio20' , TO_DATE('14/12/2023 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 3);

select * from partida where nombre_competicion like 'antonio20';
select * from juega where nombre_competicion like 'antonio20';
select * from ganadores where ncomp like 'antonio20';
commit;
delete juega where nombre_competicion like 'antonio20';
delete partida where nombre_competicion like 'antonio20';
execute inserta_jugador_partida('antonio20' , TO_DATE('14-12-2024 10:00:00', 'DD-MM-YYYY HH24:MI:SS'), 1);
execute insert_ganador_partida_auto('antonio20');

select * from procedures;

select * from ganadores;

             select njug 
             from (select n_jugador as njug, rownum as rnum, nombre_competicion as ncomp
                    from juega
                    where rownum <= 1
                        and nombre_competicion like 'antonio20' 
                        and jornada = '14/12/2024 10:01:02')
            where rnum = 1;