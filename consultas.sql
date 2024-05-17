/*

        CONSULTAS

*/



/*4. Mostrar un listado de las partidas programadas de cada competición.*/

select * 
from partida 
where nombre_competicion like upper('TORNEO PARCHÍS CORAL');

-- 5. Realiza una estadística que muestre la veces que ha jugado 
-- cada jugador con cada uno de los cuatro colores

select p.nombre, j.n_jugador,
       count(case when upper(j.color_ficha) like upper('rojo') then 1 end) "Rojo",
       count(case when upper(j.color_ficha) like upper('azul') then 1 end) "Azul",
       count(case when upper(j.color_ficha) like upper('amarillo') then 1 end) "Amarillo",
       count(case when upper(j.color_ficha) like upper('verde') then 1 end) as Verde
from juega j, participantes p
where p.asociado = j.n_jugador
group by j.n_jugador, p.nombre
order by j.n_jugador;

-- 6. Listado de los jugadores que han ganado alguna partida.
select * from partida;

select distinct p.nombre, pa.n_jugador_gana
from participantes p 
join partida pa on p.asociado = pa.n_jugador_gana;

-- 7. Jugador que ha ganado más partidas en una determinada competición.

select p.nombre, pa.n_jugador_gana, count(pa.n_jugador_gana) "Nº Partidas ganadas"
from participantes p
join partida pa on p.asociado = pa.n_jugador_gana
where nombre_competicion like upper('partida parchís lima')
group by p.nombre, pa.n_jugador_gana

order by count(n_jugador_gana) desc;

-- 8. Jugador que ha ganado más partidas. 

select p.nombre, pa.n_jugador_gana, count(pa.n_jugador_gana) "Nº Partidas ganadas"
from participantes p
join partida pa on p.asociado = pa.n_jugador_gana
group by p.nombre, pa.n_jugador_gana
order by count(n_jugador_gana) desc;

-- 9. Listado de los participantes por competición. 
select * from participantes;
select * from juega;

select p.nombre, p.ap1, p.ap2, j.nombre_competicion
from participantes p 
join juega j on p.asociado = j.n_jugador;

/*10. ¿Quién ha ganado una determinada competición? Para no complicar la
introducción de datos, consideramos los emparejamientos de la
siguiente manera. El que ha ganado la competición es el que HA
GANADO MÁS PARTIDAS en esa competición.*/
SELECT j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion, COUNT(*) as total_partidas_ganadas
FROM partida pa
JOIN jugador j ON pa.n_jugador_gana = j.n_jugador
JOIN participantes p ON j.n_jugador = p.asociado
JOIN competicion com ON pa.nombre_competicion = com.nombre AND pa.fecha_competicion = com.fecha
WHERE com.nombre LIKE UPPER('TORNEO PARCHÍS CORAL')
GROUP BY j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion
HAVING COUNT(*) = 3
ORDER BY total_partidas_ganadas DESC;

SELECT j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion, COUNT(*) as total_partidas_ganadas
FROM partida pa
JOIN jugador j ON pa.n_jugador_gana = j.n_jugador
JOIN participantes p ON j.n_jugador = p.asociado
JOIN competicion com ON pa.nombre_competicion = com.nombre AND pa.fecha_competicion = com.fecha
WHERE com.nombre LIKE UPPER('PARTIDA PARCHÍS LIMA')
GROUP BY j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion
HAVING COUNT(*) = 3
ORDER BY total_partidas_ganadas DESC;

SELECT j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion, COUNT(*) as total_partidas_ganadas
FROM partida pa
JOIN jugador j ON pa.n_jugador_gana = j.n_jugador
JOIN participantes p ON j.n_jugador = p.asociado
JOIN competicion com ON pa.nombre_competicion = com.nombre AND pa.fecha_competicion = com.fecha
WHERE com.nombre LIKE UPPER('CAMPEONATO PARCHÍS ORO')
GROUP BY j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion
HAVING COUNT(*) = 3
ORDER BY total_partidas_ganadas DESC;

/*11. Jugador que ha ganado más competiciones.*/
SELECT j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion, COUNT(*) as total_partidas_ganadas
FROM partida pa
JOIN jugador j ON pa.n_jugador_gana = j.n_jugador
JOIN participantes p ON j.n_jugador = p.asociado
JOIN competicion com ON pa.nombre_competicion = com.nombre AND pa.fecha_competicion = com.fecha
GROUP BY j.n_jugador, p.nombre, p.ap1, p.ap2, pa.nombre_competicion
HAVING COUNT(*) = 3
ORDER BY total_partidas_ganadas DESC, pa.nombre_competicion;
