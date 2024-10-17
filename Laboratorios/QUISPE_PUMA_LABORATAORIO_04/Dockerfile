# Usa la imagen oficial de Apache como base
FROM httpd:latest

# Instalar Perl en el contenedor
RUN apt-get update && apt-get install -y perl

# Habilitar el módulo CGI en Apache y configurar el directorio cgi-bin
RUN sed -i '/^#LoadModule cgid_module/s/^#//' /usr/local/apache2/conf/httpd.conf && \
    echo "ScriptAlias /cgi-bin/ \"/usr/local/apache2/cgi-bin/\"" >> /usr/local/apache2/conf/httpd.conf && \
    echo "<Directory \"/usr/local/apache2/cgi-bin\">" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    AllowOverride None" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    Options +ExecCGI" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    AddHandler cgi-script .pl" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    Require all granted" >> /usr/local/apache2/conf/httpd.conf && \
    echo "</Directory>" >> /usr/local/apache2/conf/httpd.conf

# Copiar los archivos de la calculadora al servidor Apache
COPY ./index.html /usr/local/apache2/htdocs/
COPY ./css /usr/local/apache2/htdocs/css
COPY ./cgi-bin /usr/local/apache2/cgi-bin

# Otorgar permisos de ejecución a los scripts Perl en cgi-bin
RUN chmod +x /usr/local/apache2/cgi-bin/*.pl

# Exponer el puerto 80 para el servidor
EXPOSE 80