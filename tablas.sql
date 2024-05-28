/*--------------------------------------------------*/
/*TABLAS */
/*--------------------------------------------------*/
/*las tablas localidad y provincia ya estaban creadas de antiguas realaciones*/

-- Tabla provincia
create table provincia(

 nombreprov varchar2 (30),
 codprov number (2) constraint provincia_codprov_NN not null,
  
  constraint provincia_nombreprov_pk primary key (nombreprov),
  constraint provin_codprov_uniq unique(codprov)
);

-- Tabla localidad
Create table localidad(

  nombreloc varchar2 (30),
  codloc number (4) constraint localidad_codloc_NN not null,
  nombreprov varchar2(30) constraint localidad_nombreprov_NN not null,
  constraint pk_localidad primary key (nombreloc, nombreprov),
  
  constraint localidad_fk_provincia foreign key (nombreprov) 
  references provincia (nombreprov)
    
);

-- Tabla participante
create table participantes(

  asociado varchar2(3),
  nombre varchar2(30) constraint participantes_nombre_NN not null,
  ap1 varchar2(30) constraint participantes_ap1_NN not null,
  ap2 varchar2(30),
  correo_electronico varchar(30) constraint participantes_correo_electr_NN not null,
  telefono number(9) constraint participantes_tlf_NN Not Null,
  tipo_via varchar2 (20) constraint participantes_tipo_via_NN Not Null,
  num_via number(3) constraint participantes_num_via_NN Not Null,
  nombre_via varchar2(20) constraint participantes_nombre_via_NN Not Null,
  bloque varchar2(1),
  escalera varchar2(4),
  planta varchar2(3),
  puerta varchar2(3),
  seccion varchar2(5),
  nombreloc varchar2(30) constraint participantes_nombreloc_NN not null,
  nombreprov varchar2(30) constraint participantes_nombreprov_NN not null,

  constraint participantes_pk primary key (asociado),
  constraint participantes_fk_localidad foreign key (nombreloc,nombreprov) 
    references localidad (nombreloc,nombreprov)
);

-- Tabla arbitro
create table arbitro (

    n_arbitro varchar(3),
    constraint arbitro_pk primary key (n_arbitro),
    constraint artbitro_fk_participantes foreign key (n_arbitro) 
    references participantes(asociado)
);

-- Tabla jugador
Create table jugador(

  n_jugador varchar2(3),
  
  constraint jugador_pk primary key (n_jugador),
  constraint jugador_fk_participantes foreign key (n_jugador) 
  references participantes(asociado)
  
);

-- Tabla competición
create table competicion(

  nombre varchar2(30),
  fecha date,
  n_jugadores number,
  
  constraint pk_competicion primary key (nombre, fecha)
 
);

Create table partida(

  nombre_competicion varchar(30),
  fecha_competicion date,
  jornada_fin date,
  jornada date constraint partida_jornada_NN not null,
  n_arbitro varchar(3) constraint partida_n_arbitro_NN not null,
  n_jugador_gana varchar2(3),
  
  constraint partida_pk primary key (jornada,nombre_competicion,fecha_competicion),
  
  constraint partida_fk_competicion foreign key (nombre_competicion,fecha_competicion) 
    references competicion (nombre,fecha) on delete cascade,
  constraint partida_fk_arbitro foreign key (n_arbitro) 
    references arbitro (n_arbitro),
  constraint partida_fk_jugador foreign key (n_jugador_gana) 
    references jugador (n_jugador)
);

-- Tabla Juega
Create table juega(

  nombre_competicion varchar(30),
  fecha_competicion date,
  jornada date,
  n_jugador varchar2(3),
  color_ficha varchar2(20) constraint juega_color_ficha_NN not null,
  
  constraint juega_pk primary key (jornada,nombre_competicion,fecha_competicion),
  
  constraint juega_fk_partida foreign key (jornada,nombre_competicion,fecha_competicion) 
    references partida(jornada,nombre_competicion,fecha_competicion),
  constraint juega_fk_jugador foreign key (n_jugador) 
    references jugador(n_jugador)
);



create table ganadores(

    n_jugador varchar2(3),
    ncomp varchar2(30),
    jornada date

);