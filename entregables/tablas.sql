CREATE TABLE generos (
  nombre  VARCHAR2(100), 
  CONSTRAINT pk_Gen_nombre  PRIMARY KEY (nombre)
);

CREATE TABLE contenido (
  id      NUMBER,
  titulo  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_Con_id PRIMARY KEY (id)
);

CREATE TABLE peliculas (
  id      NUMBER,
  estreno NUMBER  NOT NULL,
  CONSTRAINT pk_Pel_id PRIMARY KEY (id),
  CONSTRAINT fk_Pel_id FOREIGN KEY (id) REFERENCES contenido(id),
  CONSTRAINT ck_Pel_estreno CHECK (estreno >= 1850)
);

CREATE TABLE series (
  id      NUMBER, 
  estreno NUMBER  NOT NULL,
  fin     NUMBER,
  CONSTRAINT pk_Ser_id PRIMARY KEY (id),
  CONSTRAINT fk_Ser_id FOREIGN KEY (id) REFERENCES contenido(id),
  CONSTRAINT ck_Ser_estreno CHECK (estreno >= 1850),
  CONSTRAINT ck_Ser_fin CHECK (estreno <= fin)
);

CREATE TABLE capitulos (
  id        NUMBER, 
  nombre    VARCHAR2(100),
  estreno   NUMBER  NOT NULL,
  temporada NUMBER,
  episodio  NUMBER
  CONSTRAINT pk_Cap_id PRIMARY KEY (id, nombre),
  CONSTRAINT fk_Cap_id FOREIGN KEY (id) REFERENCES contenido(id),
  CONSTRAINT ck_Cap_estreno   CHECK (estreno >= 1850),
  CONSTRAINT ck_Cap_temporada CHECK (temporada >= 1),
  CONSTRAINT ck_Cap_episodio  CHECK (temporada >= 1)
);

CREATE TABLE personal (
  id        NUMBER, 
  nombre    VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_Cap_id PRIMARY KEY (id)
);

CREATE TABLE personajes (
  id          NUMBER, 
  nombre      VARCHAR2(100) NOT NULL,
  descripcion VARCHAR2(300),
  CONSTRAINT pk_Cap_id PRIMARY KEY (id)
);

-- Tiene N:M
CREATE TABLE contenido_tiene_genero (
  id_contenido  NUMBER,
  nombre        NUMBER,
  CONSTRAINT pk_CTG PRIMARY KEY (id_contenido, nombre),
  CONSTRAINT fk_CTG_id_contenido FOREIGN KEY (id_contenido) REFERENCES contenido(id),
  CONSTRAINT fk_CTG_nombre       FOREIGN KEY (nombre)       REFERENCES generos(nombre)
);

-- Tiene N:M
CREATE TABLE relacion_peliculas (
  id_pelicula_a NUMBER,
  id_pelicula_B NUMBER,
  tipo          VARCHAR2(50)  NOT NULL,
  CONSTRAINT pk_RP    PRIMARY KEY (id_pelicula_a, id_pelicula_B),
  CONSTRAINT fk_RP_a  FOREIGN KEY (id_pelicula_a) REFERENCES peliculas(id),
  CONSTRAINT fk_RP_b  FOREIGN KEY (id_pelicula_B) REFERENCES peliculas(id)
);

-- Tiene N:M
CREATE TABLE colabora (
  id_personal   NUMBER,
  id_contenido  NUMBER,
  rol           VARCHAR2(100)  NOT NULL,
  CONSTRAINT pk_Col PRIMARY KEY (id_personal, id_contenido),
  CONSTRAINT fk_Col_personal  FOREIGN KEY (id_personal)  REFERENCES personal(id),
  CONSTRAINT fk_Col_contenido FOREIGN KEY (id_contenido) REFERENCES contenido(id)
);

-- Tiene N:M
CREATE TABLE participa (
  id_contenido NUMBER,
  id_personaje NUMBER,
  CONSTRAINT pk_Par PRIMARY KEY (id_contenido, id_personaje),
  CONSTRAINT fk_Par_contenido FOREIGN KEY (id_contenido) REFERENCES contenido(id),
  CONSTRAINT fk_Par_personaje FOREIGN KEY (id_personaje) REFERENCES personajes(id)
);

-- Tiene N:M
CREATE TABLE interpreta (
  id_personal  NUMBER,
  id_contenido NUMBER,
  id_personaje NUMBER,
  CONSTRAINT pk_Int PRIMARY KEY (id_personal, id_contenido, id_personaje),
  CONSTRAINT fk_Int_personal  FOREIGN KEY (id_personal)                REFERENCES personal(id),
  CONSTRAINT fk_Int_participa FOREIGN KEY (id_contenido, id_personaje) REFERENCES participa(id_contenido, id_personaje)
);

-- Tiene N:M
CREATE TABLE dirige (
  id_personal  NUMBER,
  id_contenido NUMBER,
  CONSTRAINT pk_Dir PRIMARY KEY (id_personal, id_contenido),
  CONSTRAINT fk_Dir_personal  FOREIGN KEY (id_personal)   REFERENCES personal(id),
  CONSTRAINT fk_Dir_contenido FOREIGN KEY (id_contenido)  REFERENCES contenido(id)
);
