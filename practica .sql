-- Formato y activador out put servidor
set serveroutput on;
alter session set nls_date_format = 'DD/MM/YYYY HH24:MI:SS';

-- Test insertar conpetición
INSERT INTO competicion (nombre, fecha) VALUES ('LAS FUENTEZUELAS', '21-12-2004 10:00:00');

select * from juega where nombre_competicion like 'LAS FUENTEZUELAS';
select * from partida where nombre_competicion like 'LAS FUENTEZUELAS';

update partida set n_arbitro = '001' where nombre_competicion like 'LAS FUENTEZUELAS' and jornada = '21/12/2004 10:01:02' ;

-- Crea la segunda ronda
execute insert_partida_comp('LAS FUENTEZUELAS' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 2);

-- Crea la tercera ronda
execute insert_partida_comp('LAS FUENTEZUELAS' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS') , 3);
-- Ganadores automaticos primera ronda
execute insert_ganador_partida_auto('LAS FUENTEZUELAS');

select * from partida where nombre_competicion like 'LAS FUENTEZUELAS';


execute inserta_jugador_partida('LAS FUENTEZUELAS' , TO_DATE('21-12-2004 10:00:00', 'DD-MM-YYYY HH24:MI:SS'), 2);

select * from juega where nombre_competicion like 'JUAN';

execute insert_ganador_partida_man('LAS FUENTEZUELAS', '21-12-2004 10:01:02', '001');

execute insert_ganador_partida_man('LAS FUENTEZUELAS', '21-12-2004 10:21:36', '017');

execute insert_ganador_partida_man('LAS FUENTEZUELAS', '21-12-2004 10:42:10', '033');

execute insert_ganador_partida_man('LAS FUENTEZUELAS', '21-12-2004 11:02:45', '049');



select * from juega where nombre_competicion like 'LAS FUENTEZUELAS';


