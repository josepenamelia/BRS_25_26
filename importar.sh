#!/bin/bash

# Obtener usuarios con uidNumber >= 1000
grep "x:[1-9][0-9][0-9][0-9]:" /etc/passwd > tmp.txt

# Crear o reiniciar archivo ldif
> tmp.ldif

# Recorrer el archivo tmp.txt con la lista de usuarios
while read linea
do
    # Mostrar la línea que vamos a procesar
    echo "$linea"

    # Obtener datos
    uid=$(echo "$linea" | cut -d: -f1)
    nomComp=$(echo "$linea" | cut -d: -f5 | cut -d, -f1)

    nomArray=($nomComp)
    nom=${nomArray[0]}
    if [ "$nom" == "" ]; then
        nom=$uid
    fi

    ape=${nomArray[1]}
    if [ "$ape" == "" ]; then
        ape=$uid
    fi

    inic=$(echo "$nom" | cut -c 1)$(echo "$ape" | cut -c 1)
    uidNum=$(echo "$linea" | cut -d: -f3)
    usrPass=$(grep "$uid:" /etc/shadow | cut -d: -f2)
    shell=$(echo "$linea" | cut -d: -f7)
    homedir=$(echo "$linea" | cut -d: -f6)

    # Volcar datos al archivo ldif
    {
        echo "dn: uid=$uid,ou=unidad,dc=somebooks,dc=local"
        echo "objectClass: inetOrgPerson"
        echo "objectClass: posixAccount"
        echo "objectClass: shadowAccount"
        echo "uid: $uid"
        echo "sn: $ape"
        echo "givenName: $nom"
        echo "cn: $nomComp"
        echo "displayName: $nomComp"
        echo "uidNumber: $uidNum"
        echo "gidNumber: 10000"
        echo "userPassword: $usrPass"
        echo "gecos: $nomComp"
        echo "loginShell: $shell"
        echo "homeDirectory: $homedir"
        echo "shadowExpire: -1"
        echo "shadowFlag: 0"
        echo "shadowWarning: 7"
        echo "shadowMin: 8"
        echo "shadowMax: 999999"
        echo "shadowLastChange: 10877"
        echo "mail: ${nomArray[0]}.${nomArray[1]}@somebooks.com"
        echo "postalCode: 29000"
        echo "o: somebooks"
        echo "initials: $inic"
        echo
    } >> tmp.ldif

done < tmp.txt

# Añadimos los nuevos usuarios a LDAP
ldapadd -x -D cn=admin,dc=somebooks,dc=local -W -f tmp.ldif

rm tmp.txt
rm tmp.ldif
