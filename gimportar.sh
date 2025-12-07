#!/bin/bash

# Obtener grupos con uidNumber >= 1000
grep "x:[1-9][0-9][0-9][0-9]:" /etc/group > tmp.txt

# Crear o reiniciar archivo ldif
> tmp.ldif

# Recorrer el archivo tmp.txt con la lista de grupos
while read linea
do
    # Mostrar la línea que vamos a procesar
    echo "$linea"

    # Obtener datos
    cn=$(echo "$linea" | cut -d: -f1)            # Nombre del grupo
    gid=$(echo "$linea" | cut -d: -f3)           # GID del grupo
    usuarios=$(echo "$linea" | cut -d: -f4 | sed "s/,/ /g")  # Lista de usuarios

    # Volcar datos al archivo ldif
    {
        echo "dn: cn=$cn,ou=unidad,dc=somebooks,dc=local"
        echo "objectClass: posixGroup"
        echo "cn: $cn"
        echo "gidNumber: $gid"

        # Añadir usuarios
        for usuario in $usuarios; do
            echo "memberUid: $usuario"
        done

        echo
    } >> tmp.ldif

done < tmp.txt

# Añadimos los nuevos grupos a LDAP
ldapadd -x -D cn=admin,dc=somebooks,dc=local -W -f tmp.ldif

rm tmp.txt
rm tmp.ldif
