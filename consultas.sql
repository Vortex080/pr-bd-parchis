
-- Mostrar un listado de las partidas programadas de cada competición
-- Parchis coral
select * 
from partida
where nombre_competicion like upper('TORNEO PARCHÍS CORAL');
-- Parchis Lima
select * 
from partida
where nombre_competicion like upper('PARTIDA PARCHÍS LIMA');
-- Parchis oro
select * 
from partida
where nombre_competicion like upper('CAMPEONATO PARCHÍS ORO');

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

-- 
