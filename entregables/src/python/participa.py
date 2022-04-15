f = open("dataBBDD2/cast_info.csv","r",encoding="utf-8")
fOut = open("SQL/participa.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    try:
        a = int(campos[2])
        fOut.write("INSERT INTO participa (id_contenido, id_personaje) VALUES ("+ campos[1] + "," + campos[2] + ");\n")
    except:
        pass