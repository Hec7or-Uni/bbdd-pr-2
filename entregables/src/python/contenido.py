f = open("dataBBDD2/title.csv","r",encoding="utf-8")
fOut = open("SQL/contenido.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    campos[1] = campos[1].replace("\"","")
    fOut.write("INSERT INTO contenido (id, titulo) VALUES ("+ campos[0] + ",\"" + campos[1] + "\");\n")