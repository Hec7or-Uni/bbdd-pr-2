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
-- COMPRUEBA QUE LAS FECHAS DE INICIO Y FIN DE UNA SERIE TENGAN SENTIDO
CREATE OR REPLACE TRIGGER CLEAN_DATES
BEFORE INSERT ON series
FOR EACH ROW
DECLARE 
    fechaEstr NUMBER;
BEGIN
    SELECT estreno INTO fechaEstr FROM contenido WHERE :NEW.id = id;
    IF :NEW.fin < fechaEstr
    THEN
        RAISE_APPLICATION_ERROR (-20002, 'La serie: ' || :NEW.id || ' tiene una fecha de finalización menor que la del estreno de la tabla contenido. Cosidera eliminar/corregir la inserción.');
    END IF;
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