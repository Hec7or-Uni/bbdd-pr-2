--CONSULTA 1
--Porcentaje de películas con hasta 3 actores o actrices
SELECT ROUND(N.num_conteidos_limite_actores / D.num_contenidos * 100, 2) AS porcentaje
FROM (
  -- Devuelve cuantos contenidos hay con hasta 3 actores/actrices
  SELECT COUNT(*) AS num_conteidos_limite_actores
FROM (
    -- Devuelve tuplas (num_actores, id_contenido) en las que el num_actores es <= 3 
    SELECT id_contenido
    FROM participa
    GROUP BY id_contenido
    HAVING COUNT(*) <= 3
)
) N, (
  -- Devuelve el numero total de contenidos
  SELECT COUNT(*) AS num_contenidos
  FROM contenido
) D;


-- CONSULTA 2
-- Título de las películas y series de terror en las que el mismo personaje 
-- ha sido interpretado por al menos 50 diferentes actores o actrices, 
-- junto con el nombre del personaje y el número de actores distintos que lo han interpretado
SELECT N.titulo, P.nombre, N.num_actores
FROM personajes P, (
  -- Devuelve tuplas (id, titulo, num_actores, id_personaje) en las que el contenido es de terror y el 
  -- numero de veces que un personaje es interpretado dentro del mismo contenido es de al menos 50.
  SELECT A.id, A.titulo, B.num_actores, B.id_personaje
  FROM (
    -- Devuelve una lista de tuplas (id, titulo) de aquellos contenidos que
    -- pertenecen al genero de terror.
    SELECT C.id, C.titulo
    FROM contenido C, generos G
    WHERE C.id = G.id_contenido and G.nombre = 'terror'
  ) A, (
    -- Devuelve tuplas como (numero de veces, id_contenido, id_personaje) en las que
    -- el numero de actores para interpretar un personaje dentro de un mismo contenido (pelicula/serie)
    -- es al menos de 50
    SELECT COUNT(*) AS num_actores, id_contenido, id_personaje
    FROM interpreta I
    GROUP BY id_contenido, id_personaje
    HAVING COUNT(*) > 49
  ) B
  WHERE A.id = B.id_contenido
) N
WHERE P.id = N.id_personaje;