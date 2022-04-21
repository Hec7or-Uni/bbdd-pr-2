-- TRIGGER 1:
-- Al insertar en peliculas verifica que el identificado de la peli X no 
-- este en la tabla de series
CREATE OR REPLACE TRIGGER EXC_PELIS
BEFORE INSERT ON peliculas
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
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
    SELECT COUNT(*) INTO flag
    FROM peliculas
    WHERE id = :NEW.id;

    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20001, 'La fila insertada ya pertenece a la categoria de peliculas.');
    END IF;
END; 
/

-- TRIGGER 2:
-- Al insertar en [ peliculas | series ] se inserta en contenido.
CREATE OR REPLACE TRIGGER INSERT_PEL
AFTER INSERT ON conteido_aux
FOR EACH ROW
WHEN :NEW.tipo = 'serie' AND (:NEW.estreno <= :NEW.fin OR :NEW.fin IS NULL)
BEGIN
  INSERT INTO contenido (id, titulo, estreno) VALUES (:NEW.id, :NEW.titulo, :NEW.estreno);
  IF :NEW.tipo = 'pelicula' THEN
    INSERT INTO peliculas (id) VALUES (:NEW.id);
  ELSE
    INSERT INTO series (id, fin) VALUES (:NEW.id, :NEW.fin);
  END IF;
  -- Eliminamos de la tabla auxiliar la tupla que acabamos de insertar
  DELETE FROM conteido_aux WHERE id = :NEW.id;
END;
/

-- TRIGGER 3:
-- Comprueba la coherencia de datos:
-- Si tenemos una tupla en la tabla actores debe estar también en la de colabora
CREATE OR REPLACE TRIGGER INSERT_ACT
BEFORE INSERT ON actores
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
  SELECT COUNT(*) INTO flag
  FROM colabora
  WHERE id_personal = :NEW.id AND (rol = 'actor' or rol = 'actress');

  IF flag < 1
  THEN
      RAISE_APPLICATION_ERROR (-20002, 'La persona insertada no es un actor.');
  END IF;
END;
/