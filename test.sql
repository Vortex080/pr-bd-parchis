-- Testeo trigger participantes

-- ID no puede estar vacio
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');

-- ID existe
INSERT INTO participantes (asociado, nombre, ap1, ap2, correo_electronico, telefono, tipo_via, num_via, nombre_via, bloque, escalera, planta, puerta, seccion, nombreloc, nombreprov)
VALUES ('002', 'JUAN', 'GOMEZ', 'LOPEZ', 'JUAN@EJEMPLO.COM', 612345678, 'C', 123, 'ALAMEDA', NULL, NULL, '1', 'A', NULL, 'ALICANTE', 'ALICANTE');
