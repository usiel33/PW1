# Base image
FROM debian:latest

# Desactivar interacción durante la instalación
ENV DEBIAN_FRONTEND="noninteractive"

# Instalar Apache y Perl (sin cpanminus para evitar instalación de muchos módulos extra)
RUN apt-get update && \
    apt-get install -y apache2 perl libwww-perl libjson-perl libtext-csv-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Habilitar el módulo CGI en Apache
RUN a2enmod cgid

# Crear y configurar el directorio para scripts CGI
RUN mkdir -p /usr/lib/cgi-bin/ && \
    chown -R www-data:www-data /usr/lib/cgi-bin/

# Copiar el script Perl y archivo CSV al directorio CGI
COPY ./cgi/busquedas.pl /usr/lib/cgi-bin/busquedas.pl
COPY ./data/universidades.csv /usr/lib/cgi-bin/universidades.csv

# Copiar el archivo CSS y HTML al directorio de Apache
COPY ./css /var/www/html/css/
COPY ./html/index.html /var/www/html/

# Asignar permisos de ejecución al script CGI
RUN chmod +x /usr/lib/cgi-bin/busquedas.pl

# Configurar el ScriptAlias y permisos en el archivo de configuración de Apache
RUN echo "ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" >> /etc/apache2/apache2.conf && \
    echo "<Directory \"/usr/lib/cgi-bin\">\n    AllowOverride None\n    Options +ExecCGI\n    AddHandler cgi-script .pl\n    Require all granted\n</Directory>" >> /etc/apache2/apache2.conf

# Configurar un nombre de servidor para evitar advertencias
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Exponer el puerto 80 para el servidor web
EXPOSE 80

# Comando para iniciar Apache en primer plano
CMD ["apachectl", "-D", "FOREGROUND"]
