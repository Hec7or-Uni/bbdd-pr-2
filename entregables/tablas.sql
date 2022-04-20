CREATE TABLE contenido (
  id      NUMBER,
  titulo  VARCHAR2(150) NOT NULL,
  estreno NUMBER        NOT NULL,
  CONSTRAINT pk_Con_id  PRIMARY KEY (id),
  CONSTRAINT ck_Con_estreno CHECK (estreno >= 1850)
);

CREATE TABLE generos (
  nombre        VARCHAR2(100),
  id_contenido  NUMBER,
  CONSTRAINT pk_Gen PRIMARY KEY (nombre, id_contenido),
  CONSTRAINT fk_Gen FOREIGN KEY (id_contenido) REFERENCES contenido(id)
);

CREATE TABLE peliculas (
  id  NUMBER,
  CONSTRAINT pk_Pel_id  PRIMARY KEY (id),
  CONSTRAINT fk_Pel_id  FOREIGN KEY (id) REFERENCES contenido(id)
);

-- Tiene N:M
CREATE TABLE relacion_peliculas (
  id_pelicula_a NUMBER,
  id_pelicula_b NUMBER,
  tipo          VARCHAR2(50)  NOT NULL,
  CONSTRAINT pk_RP    PRIMARY KEY (id_pelicula_a, id_pelicula_b),
  CONSTRAINT fk_RP_a  FOREIGN KEY (id_pelicula_a) REFERENCES peliculas(id),
  CONSTRAINT fk_RP_b  FOREIGN KEY (id_pelicula_b) REFERENCES peliculas(id)
);

CREATE TABLE series (
  id      NUMBER, 
  fin     NUMBER,
  CONSTRAINT pk_Ser_id  PRIMARY KEY (id),
  CONSTRAINT fk_Ser_id  FOREIGN KEY (id)  REFERENCES contenido(id),
  CONSTRAINT ck_Ser_fin CHECK (fin >= 1850)
);

CREATE TABLE capitulos (
  id        NUMBER, 
  nombre    VARCHAR2(100),
  estreno   NUMBER  NOT NULL,
  temporada NUMBER,
  episodio  NUMBER,
  CONSTRAINT pk_Cap_id  PRIMARY KEY (id, nombre),
  CONSTRAINT fk_Cap_id  FOREIGN KEY (id)  REFERENCES contenido(id),
  CONSTRAINT ck_Cap_estreno   CHECK (estreno >= 1850),
  CONSTRAINT ck_Cap_temporada CHECK (temporada >= 1),
  CONSTRAINT ck_Cap_episodio  CHECK (episodio >= 1)
);

CREATE TABLE personal (
  id        NUMBER,
  nombre    VARCHAR2(100) NOT NULL,
  genero    VARCHAR2(100),
  CONSTRAINT pk_P_id PRIMARY KEY (id)
);

CREATE TABLE actores (
  id  NUMBER,
  CONSTRAINT pk_Act PRIMARY KEY (id)
);

CREATE TABLE personajes (
  id          NUMBER, 
  nombre      VARCHAR2(100) NOT NULL,
  descripcion VARCHAR2(300),
  CONSTRAINT pk_Per_id PRIMARY KEY (id)
);

CREATE TABLE roles (
  rol VARCHAR2(100),
  CONSTRAINT pk_Rol PRIMARY KEY (rol)
);

CREATE TABLE colabora (
  id_personal   NUMBER,
  id_contenido  NUMBER,
  rol           VARCHAR2(100),
  CONSTRAINT pk_Col           PRIMARY KEY (id_personal, id_contenido, rol),
  CONSTRAINT fk_Col_personal  FOREIGN KEY (id_personal)   REFERENCES personal(id),
  CONSTRAINT fk_Col_contenido FOREIGN KEY (id_contenido)  REFERENCES contenido(id),
  CONSTRAINT fk_Col_rol       FOREIGN KEY (rol)           REFERENCES roles(rol)
);

CREATE TABLE participa (
  id_actor      NUMBER,
  id_contenido  NUMBER,
  CONSTRAINT pk_Par           PRIMARY KEY (id_contenido, id_actor),
  CONSTRAINT fk_Par_actor     FOREIGN KEY (id_actor)      REFERENCES actores(id),
  CONSTRAINT fk_Par_contenido FOREIGN KEY (id_contenido)  REFERENCES contenido(id)
);

CREATE TABLE interpreta (
  id_actor      NUMBER,
  id_contenido  NUMBER,
  id_personaje  NUMBER,
  CONSTRAINT pk_Int           PRIMARY KEY (id_actor, id_contenido, id_personaje),
  CONSTRAINT fk_Int_personaje FOREIGN KEY (id_personaje)            REFERENCES personajes(id),
  CONSTRAINT fk_Int_participa FOREIGN KEY (id_actor, id_contenido)  REFERENCES participa(id_actor, id_contenido)
);