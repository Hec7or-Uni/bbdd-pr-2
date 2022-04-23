-- Tabla contenidos
select id, title as titulo, production_year as estreno
from title 
where kind_id <> 6 and kind_id <> 7;

-- Tabla de genero
-- poblada solo con las de terror
select "terror" as nombre, m.movie_id as id_contenido
from movie_keyword m, keyword k
where m.keyword_id = k.id and (k.keyword like '%horror%' or k.keyword like '%terror');

-- Tabla peliculas
select id 
from title 
where kind_id = 1 OR kind_id = 3 OR kind_id = 4;

-- Tabla relacion peliculas
select movie_id as id_pelicula_a, movie_id as id_pelicula_b, link as tipo
from movie_link r, link_type t
where r.link_type_id = t.id;

-- Tabla series
select id, 
	case
		when SUBSTRING(series_years, 6, 4) = "????" then null
      ELSE SUBSTRING(series_years, 6, 4)
	end as fin
from title
where kind_id = 2 or kind_id = 5;

-- Tabla capitulos
select episode_of_id as id, title as nombre, production_year as estreno, season_nr as temporada, episode_nr as episodio
from title 
where kind_id = 7;

-- Tabla personal
select id, name as nombre, gender as genero
from name;

-- Tabla actores
select distinct person_id as id
from cast_info 
where role_id = 1 OR role_id = 2;

-- Tabla personajes
-- Al hacer el insert, la columna descripcion estará a null 
-- ya que no tenemos descripciones de los personajes
select id, name as nombre
from char_name;

-- roles
select role as rol
from role_type;

-- Tabla colabora
select c.person_id as id_personal, c.movie_id as id_contenido, r.role as rol
from cast_info c, title t, role_type r
where c.movie_id = t.id and r.id = c.role_id  -- condicion de join
  and t.kind_id <> 6  -- No es video game
  and t.kind_id <> 7; -- No es capitulo

-- Tabla participa
select c.person_id as id_actor, c.movie_id as id_contenido
from cast_info c, title t
where c.movie_id = t.id -- condicion de join
  and (c.role_id = 1 or c.role_id = 2) -- contenido en el que actua un actor
  and t.kind_id <> 6  -- No es video game
  and t.kind_id <> 7; -- No es capitulo


-- Tabla interpreta
select c.person_id as id_actor, c.movie_id as id_contenido, c.person_role_id as id_personaje
from cast_info c, title t
where c.movie_id = t.id -- condicion de join
  and (c.role_id = 1 or c.role_id = 2) -- contenido en el que actua un actor
  and t.kind_id <> 6  -- No es video game
  and t.kind_id <> 7  -- No es capitulo
  and c.person_role_id is not null; -- Personaje no nulo