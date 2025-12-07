# Instalacion Servidor
## Comprobar que el servicio está funcionando
Se instala y configura OpenLDAP con slapd, generando la base dc=san-gva,dc=mylocal.
Se verifica que el demonio funciona y se consulta la configuración interna mediante slapcat.
~~~
systemctl status slapd
~~~
## Ver configuración del servidor
~~~
sudo slapcat -n 1
~~~
# Archivos LDIF
## ou
~~~
cat ou.ldif
~~~
## grupos
~~~
cat grp.ldif
~~~
## usuarios
~~~
cat usr.ldif
~~~
# importar Usuarios y grupos
~~~
cat importar.sh
~~~
~~~
cat gimportar.sh
~~~
# LDAP terminal
## Configuracion
~~~
cat /etc/nslcd.conf
~~~
~~~
grep -E 'passwd|group|shadow' /etc/nsswitch.conf
~~~
~~~
systemctl status nslcd
~~~
## Acceso
~~~
getent passwd jpena
~~~
~~~
ldapsearch -x -H ldap://10.0.0.3 -b "dc=san-gva,dc=mylocal"
~~~
# LDAP grafico
~~~
grep pam_mkhomedir /etc/pam.d/common-session
~~~
# Arbol DIT en LAM
~~~
ldapsearch -x -LLL -b "dc=san-gva,dc=mylocal"
~~~
