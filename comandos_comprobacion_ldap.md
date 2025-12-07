# Instalacion Servidor
## Comprobar que el servicio está funcionando
systemctl status slapd
sudo ss -tulpn | grep ldap
## Ver configuración del servidor
sudo slapcat -n 0
sudo slapcat -n 1

# Archivos LDIF
## ou
cat ou.ldif
## grupos
cat grp.ldif
## usuarios
cat usr.ldif
  
# importar Usuarios y grupos
cat importar.sh

cat gimportar.sh

# LDAP terminal
## Configuracion
cat /etc/nslcd.conf
grep -E 'passwd|group|shadow' /etc/nsswitch.conf

## Acceso
getent passwd jpena
ldapsearch -x -H ldap://10.0.0.3 -b "dc=san-gva,dc=mylocal"

# LDAP grafico
