f = open("dataBBDD2/char_name.csv","r",encoding="utf-8")
fOut = open("SQL/personajes.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(",")
    campos[1] = campos[1].replace("\"","")
    fOut.write("INSERT INTO personajes (id, nombre, descripcion) VALUES ("+ campos[0] + ",\"" + campos[1] + "\",null);\n")