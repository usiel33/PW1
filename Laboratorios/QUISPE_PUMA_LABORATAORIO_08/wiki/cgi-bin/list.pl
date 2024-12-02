#!/usr/bin/perl
use strict;
use warnings;

print "Content-type: text/html\n\n";

my $directory = "./data/";
opendir(my $dh, $directory) or die "No se puede abrir el directorio: $!";

print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/styles.css">
    <title>Listado</title>
</head>
<body>
    <header>
        <h1>Listado de Páginas</h1>
    </header>
    <div class="container">
HTML

while (my $file = readdir($dh)) {
    next if $file =~ /^\./; # Ignorar archivos ocultos
    my $name = $file;
    $name =~ s/\.md$//; # Quitar la extensión .md

    print <<"HTML";
    <div class="list-item">
        <a href="/cgi-bin/view.pl?name=$name" class="link">$name</a>
        <a href="/cgi-bin/edit.pl?name=$name" class="button edit">E</a>
        <a href="/cgi-bin/delete.pl?name=$name" class="button delete">X</a>
    </div>
HTML
}

closedir($dh);

print <<"HTML";
        <a href="/new.html" class="button">Crear Nueva Página</a>
        <a href="../index.html" class="button">Volver al Inicio</a>
    </div>
    <footer>
        <p>2024 Usiel Suriel Quispe Puma</p>
    </footer>
</body>
</html>
HTML
