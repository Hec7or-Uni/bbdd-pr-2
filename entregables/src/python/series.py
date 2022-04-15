f = open("dataBBDD2/title.csv","r",encoding="utf-8")
fOut = open("SQL/series.sql","w",encoding="utf-8")
f.readline()
for l in f:
    l = l[:-1]
    campos = l.split(";")
    t = int(campos[2])
    if(t == 2 or t == 5):
        campos[3] = campos[3].replace("\"","")
        a = campos[7].split("-")
        fOut.write("INSERT INTO series (id, estreno, fin) VALUES ("+ campos[0] + "," + campos[3] + "," + a[1] + ");\n")