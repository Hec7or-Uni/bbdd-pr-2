-- Tabla de contenido = (pelis & tv series)
SELECT id, title AS titulo
FROM title
WHERE kind_id = 1 OR kind_id = 2;

-- Tabla de peliculas
SELECT id, production_year AS estreno
FROM title
WHERE kind_id = 1;

-- Tabla N:M que sale de la entidad peliculas
-- Relacion entre peliculas
SELECT L.movie_id AS id_pelicula_a, L.linked_movie_id AS id_pelicula_b, T.link as tipo
FROM movie_link L, (
	SELECT *
	FROM link_type
) T
WHERE L.link_type_id = T.id;

-- Tabla de series
SELECT id, 
	CASE
		WHEN SUBSTRING(series_years, 1, 4) = "????" THEN NULL
        ELSE SUBSTRING(series_years, 1, 4)
	END AS estreno,
	CASE
		WHEN SUBSTRING(series_years, 6, 4) = "????" THEN NULL
        ELSE SUBSTRING(series_years, 6, 4)
	END AS fin
FROM title
WHERE kind_id = 2;

-- Tabla de capitulos
SELECT episode_of_id as serie_id, title AS nombre, production_year AS estreno, season_nr AS temporada, episode_nr AS episodio
FROM title
WHERE kind_id = 7
ORDER BY temporada, episodio;

-- Tabla personal
SELECT id, name AS nombre
FROM name;

-- Tabla colabora
SELECT person_id AS id_personal, movie_id AS id_contenido, role
FROM cast_info C, (
	SELECT * 
	FROM role_type
) R
WHERE role_id = id;

-- Tabla personajes
SELECT id, name as nombre, NULL AS descripcion
FROM char_name;

-- Tabla dirige
SELECT person_id AS id_personal, movie_id AS id_contenido
FROM cast_info
WHERE role_id = 8;

-- Tabla interpreta
-- ERROR: person_role_id <> NULL, SOL: person_role_id >= 1
SELECT person_id AS id_personal, movie_id AS id_contenido, person_role_id AS id_personaje
FROM cast_info
WHERE (role_id = 1 OR role_id = 2) AND person_role_id >= 1;

-- Tabla participa
SELECT movie_id AS id_contenido, person_role_id AS id_personaje
FROM cast_info
WHERE (role_id = 1 OR role_id = 2) AND person_role_id >= 1;