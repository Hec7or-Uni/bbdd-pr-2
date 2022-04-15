f = open("dataBBDD2/title.csv","r",encoding="utf-8")
fOut = open("SQL/peliculas.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    # print(campos)
    t = int(campos[2])
    if(t == 1 or t == 3 or t == 4):
        campos[3] = campos[3].replace("\"","")
        fOut.write("INSERT INTO peliculas (id, estreno) VALUES ("+ campos[0] + "," + campos[3] + ");\n")