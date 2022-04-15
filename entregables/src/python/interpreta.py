f = open("dataBBDD2/cast_info.csv","r",encoding="utf-8")
fOut = open("SQL/interpreta.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    t = int(campos[5])
    if(t == 1 or t == 2):
        try:
            a = int(campos[2])
            fOut.write("INSERT INTO interpreta (id_personal, id_contenido, id_personaje) VALUES ("+ campos[0] + "," + campos[1] + "," + campos[2] + ");\n")
        except:
            pass