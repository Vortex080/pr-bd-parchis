-- Formato y activador out put servidor
set serveroutput on;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

-- Test insertar conpetición
INSERT INTO competicion (nombre, fecha) VALUES ('JUAN', '21-12-2004 10:00:00');

select * from juega where nombre_competicion like 'JUAN';
select * from partida where nombre_competicion like 'JUAN';


-- Crea la segunda ronda
execute insert_partida_comp('JUAN' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 2);

-- Crea la tercera ronda
execute insert_partida_comp('JUAN' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 3);
-- Ganadores automaticos primera ronda
execute insert_ganador_partida_auto('JUAN');

select * from partida where nombre_competicion like 'JUAN';


execute inserta_jugador_partida('JUAN' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS'), 2);

select * from juega where nombre_competicion like 'JUAN';

execute insert_ganador_partida_man('JUAN', '21-12-2004 10:01:02', '001');

execute insert_ganador_partida_man('JUAN', '21-12-2004 10:21:36', '017');

execute insert_ganador_partida_man('JUAN', '21-12-2004 10:42:10', '033');

execute insert_ganador_partida_man('JUAN', '21-12-2004 11:02:45', '049');



select * from juega where nombre_competicion like 'JUAN';


