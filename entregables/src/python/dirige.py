f = open("dataBBDD2/cast_info.csv","r",encoding="utf-8")
fOut = open("SQL/dirige.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    t = int(campos[5])
    if(t == 8):
        fOut.write("INSERT INTO dirige (id_personal, id_contenido) VALUES ("+ campos[0] + "," + campos[1] + ");\n")