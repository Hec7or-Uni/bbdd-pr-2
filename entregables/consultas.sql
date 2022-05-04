--CONSULTA 1
--Porcentaje de películas con hasta 3 actores o actrices
SELECT ROUND(N.num_conteidos_limite_actores / D.num_contenidos * 100, 2)||'%' AS porcentaje
FROM (
  -- Devuelve cuantos contenidos hay con hasta 3 actores/actrices
  SELECT COUNT(*) AS num_conteidos_limite_actores
  FROM (
    -- Devuelve tuplas (num_actores, id_contenido) en las que el num_actores es <= 3 
    SELECT id_contenido
    FROM participa PA, peliculas P
    WHERE PA.id_contenido = P.id
    GROUP BY id_contenido
    HAVING COUNT(*) <= 3
)
) N, (
  -- Devuelve el numero total de peliculas
  SELECT COUNT(*) AS num_contenidos
  FROM peliculas
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

-- CONSULTA 3
-- Actores que solo han participado en una película de la década de los 90 
-- que forma parte de una saga de al menos tres películas
SELECT nombre
FROM personal P, (
    SELECT id_actor
    FROM participa P , (
    -- Selecciona de la lista de peliculas que pertenecen a una saga de al menos 3 peliculas, las que
    -- se estrenaron en la decada de los 90 
      SELECT DISTINCT S.id
      FROM contenido C, (
        -- Saca la lista de sagas con al menos 3 peliculas
          SELECT id_pelicula_a as id
          FROM (
              SELECT *
              FROM relacion_peliculas
              WHERE tipo = 'follows'
          ) T1
          GROUP BY id_pelicula_a
          HAVING COUNT(*) >= 2  -- es 2 y no 3 ya que la primera pelicula no se cuenta, se usa como identificador de saga
          UNION ALL 
          -- Devuelve las peliculas que pertenecen a la lista de sagas
          -- siendo "saga" la primera pelicula de la saga
          SELECT id_pelicula_b as id
          FROM relacion_peliculas
          WHERE id_pelicula_a IN (
              SELECT id_pelicula_a
              FROM relacion_peliculas
              WHERE tipo = 'follows'
          )
      ) S
      WHERE C.id = S.id and 
          1990 <= estreno and estreno < 2000
    ) S
    WHERE P.id_contenido = S.id
    GROUP BY id_actor
    HAVING COUNT(*) = 1
) A
WHERE P.id = A.id_actor;
