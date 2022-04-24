--CONSULTA 1
--Porcentaje de películas con hasta 3 actores o actrices
SELECT R / T * 100 FROM
(SELECT COUNT(*) as R FROM contenido C WHERE (SELECT COUNT(*) FROM participa P WHERE C.id = P.id_contenido)  < 4),
(SELECT COUNT(*) as T FROM contenido C);


--CONSULTA2
--Título de las películas y series de terror en las que el mismo personaje 
--ha sido interpretado por al menos 50 diferentes actores o actrices, 
--junto con el nombre del personaje y el número de actores distintos que lo han interpretado
SELECT DISTINCT C.titulo,P.nombre,(SELECT COUNT(*) FROM interpreta B WHERE A.id_personaje = B.id_personaje AND A.id_contenido = B.id_contenido) 
FROM interpreta A, generos G, personajes P, contenido C 
WHERE A.id_contenido = G.id_contenido AND G.nombre = 'terror' AND 
(SELECT COUNT(*) AS Z FROM interpreta B WHERE A.id_personaje = B.id_personaje AND A.id_contenido = B.id_contenido) > 49 AND 
P.id = A.id_personaje AND C.id = A.id_contenido;
