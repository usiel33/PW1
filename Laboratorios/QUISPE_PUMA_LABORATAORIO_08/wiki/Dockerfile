# Usar la imagen base de Ubuntu
FROM ubuntu:20.04

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar y configurar Apache, Perl, y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 perl libcgi-pm-perl dos2unix libtext-markdown-perl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Deshabilitar cgid y habilitar cgi, asegurando que se use mpm_prefork
RUN a2dismod mpm_event mpm_worker cgid && \
    a2enmod mpm_prefork cgi

# Crear directorios necesarios
RUN mkdir -p /usr/lib/cgi-bin/data

# Copiar archivos HTML y recursos al contenedor
COPY index.html /var/www/html/
COPY new.html /var/www/html/
COPY styles.css /var/www/html/
COPY ./cgi-bin/ /usr/lib/cgi-bin/
COPY ./data/ /usr/lib/cgi-bin/data/

# Ajustar permisos para scripts CGI y datos
RUN chmod 755 /usr/lib/cgi-bin/*.pl && \
    chmod -R 755 /usr/lib/cgi-bin/data && \
    chown -R www-data:www-data /usr/lib/cgi-bin /usr/lib/cgi-bin/data && \
    dos2unix /usr/lib/cgi-bin/*.pl

# Configurar Apache para ejecutar scripts CGI
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "\
<Directory \"/usr/lib/cgi-bin\">\n\
    AllowOverride None\n\
    Options +ExecCGI\n\
    AddHandler cgi-script .pl\n\
    Require all granted\n\
</Directory>\n\
<Directory \"/var/www/html\">\n\
    AllowOverride None\n\
    Options +Indexes +FollowSymLinks\n\
    Require all granted\n\
</Directory>\n" >> /etc/apache2/apache2.conf

# Asegurar que Apache registre logs a nivel debug
RUN echo "LogLevel debug" >> /etc/apache2/apache2.conf

# Configuración adicional para Apache y CGI
RUN echo "\
<IfModule mpm_prefork_module>\n\
    StartServers             5\n\
    MinSpareServers          5\n\
    MaxSpareServers         10\n\
    MaxRequestWorkers      150\n\
    MaxConnectionsPerChild   0\n\
</IfModule>\n" >> /etc/apache2/mods-enabled/mpm_prefork.conf

# Exponer el puerto 80 para la aplicación web
EXPOSE 80

# Comando para ejecutar Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
