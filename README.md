## Solución al ejercicio de despliegue de la app de temperaturas con Apache + modWSGI

Ejecutar:

```bash 
$ vagrant plugin install vagrant-docker-compose
$ vagrant up
```
> La BBDD de SQLite estaba dando un error. En esta versión se usa MySQL en el programa Flask. Para ello se ha modificado el fichero `__init__.py` que tiene la cadena de conexión y se ha añadido un fichero `docker-compose.yml` para levantar el contenedor de MySQL.

Navegar a `localhost:8080` o modificar en `Vagrantfile`
