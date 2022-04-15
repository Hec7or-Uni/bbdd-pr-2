f = open("dataBBDD2/cast_info.csv","r",encoding="utf-8")
fOut = open("SQL/colabora.sql","w",encoding="utf-8")
f.readline()
roles=[
    "actor",
    "actress",
    "producer",
    "writer",
    "cinematographer",
    "composer",
    "costume designer",
    "director",
    "editor",
    "miscellaneous crew",
    "production designer",
    "guest"
]
for l in f:
    l = l[:-1]
    campos = l.split(";")
    fOut.write("INSERT INTO colabora (id_personal, id_contenido, rol) VALUES ("+ campos[0] + "," + campos[1] + ",\"" + roles[int(campos[5])-1] + "\");\n")