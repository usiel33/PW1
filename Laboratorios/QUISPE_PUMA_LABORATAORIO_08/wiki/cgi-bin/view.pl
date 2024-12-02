#!/usr/bin/perl
use strict;
use warnings;
use CGI;

# Crear un objeto CGI para manejar solicitudes y parámetros
my $query = CGI->new;
my $name = $query->param("name");
my $file_path = "./data/$name.md";

# Configuración de cabecera HTTP
print "Content-type: text/html\n\n";

if (-e $file_path) {
    # Abrir el archivo Markdown
    open(my $fh, '<', $file_path) or die "No se pudo abrir el archivo: $!";
    my @lines = <$fh>;
    close($fh);

    # Unir las líneas del archivo para procesarlas como un único string
    my $content = join("", @lines);

    # Reemplazar elementos de Markdown por su representación HTML
    $content =~ s/^###### (.*?)$/<h6>$1<\/h6>/gm; # Encabezado de nivel 6
    $content =~ s/^##### (.*?)$/<h5>$1<\/h5>/gm; # Encabezado de nivel 5
    $content =~ s/^#### (.*?)$/<h4>$1<\/h4>/gm; # Encabezado de nivel 4
    $content =~ s/^### (.*?)$/<h3>$1<\/h3>/gm; # Encabezado de nivel 3
    $content =~ s/^## (.*?)$/<h2>$1<\/h2>/gm; # Encabezado de nivel 2
    $content =~ s/^# (.*?)$/<h1>$1<\/h1>/gm; # Encabezado de nivel 1
    $content =~ s/\*\*(.*?)\*\*/<strong>$1<\/strong>/g; # Negrita
    $content =~ s/\*(.*?)\*/<em>$1<\/em>/g; # Cursiva
    $content =~ s/\~\~(.*?)\~\~/<del>$1<\/del>/g; # Tachado
    $content =~ s/\`(.*?)\`/<code>$1<\/code>/g; # Código en línea
    $content =~ s/```\n(.*?)\n```/<pre><code>$1<\/code><\/pre>/gs; # Bloque de código
    $content =~ s/\[(.*?)\]\((.*?)\)/<a href="$2">$1<\/a>/g; # Enlaces

    # Generar el contenido HTML de salida
    print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/styles.css">
    <title>$name</title>
</head>
<body>
    <header>
        <h1>$name</h1>
    </header>
    <div class="container">
        $content
        <a href="/cgi-bin/list.pl" class="button">Regresar a Listado</a>
    </div>
    <footer>
        <p>2024 Usiel Suriel Quispe Puma</p>
    </footer>
</body>
</html>
HTML
} else {
    # Mostrar mensaje de error si el archivo no existe
    print "<p>Error: El archivo no existe.</p>";
}
