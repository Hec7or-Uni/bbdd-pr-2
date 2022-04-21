-- TRIGGER 1:
-- Al insertar en peliculas verifica que el identificado de la peli X no 
-- este en la tabla de series
CREATE OR REPLACE TRIGGER EXC_PELIS
BEFORE INSERT ON peliculas
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT() INTO flag
    FROM series
    WHERE id = :NEW.id;

    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20000, 'La fila insertada ya pertenece a la categoria de series.');
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER EXC_SERIES
BEFORE INSERT ON series
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT() INTO flag
    FROM peliculas
    WHERE id = :NEW.id;

    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20001, 'La fila insertada ya pertenece a la categoria de peliculas.');
    END IF;
END; 
/

-- TRIGGER 2:
-- Al insertar en [ peliculas | series ] se inserta en contenido.

-- TRIGGER 3:
-- El final de una serie debe ser posterior a su estreno
CREATE OR REPLACE TRIGGER FECHAS_SERIES
BEFORE INSERT ON contenido
FOR EACH ROW
DECLARE 
    fechaFUN NUMBER;
BEGIN
    SELECT fechaFundacion INTO fechaFUN 
    FROM equipos 
    WHERE :NEW.equipo = nombreCorto;

    IF :NEW.temporada < fechaFUN
    THEN
        RAISE_APPLICATION_ERROR (-20001, 'El equipo no existe aún en esta temporada');
    END IF;
END;
/