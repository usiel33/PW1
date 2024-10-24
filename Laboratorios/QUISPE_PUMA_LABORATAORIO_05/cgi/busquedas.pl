#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);
use Text::CSV;

# Crear el objeto CGI
my $cgi = CGI->new;

# Definir la cabecera de la respuesta
print $cgi->header('text/html; charset=UTF-8');

# Obtener los parámetros del formulario
my $nombre_universidad = $cgi->param('nombre_universidad') // '';
my $periodo_licenciamiento = $cgi->param('periodo_licenciamiento') // '';
my $departamento_local = $cgi->param('departamento_local') // '';
my $denominacion_programa = $cgi->param('denominacion_programa') // '';

# Cargar y procesar el archivo CSV
my $file = 'Programas de Universidades.csv'; # Ruta al archivo CSV
my @resultados;

# Usar Text::CSV para leer el archivo
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

open my $fh, '<:encoding(utf8)', $file or die "No se puede abrir '$file': $!";
while (my $row = $csv->getline($fh)) {
    my ($nombre, $periodo, $departamento, $denominacion) = @$row;

    # Filtrar los resultados según las consultas
    if (($nombre_universidad eq '' || $nombre =~ /$nombre_universidad/i) &&
        ($periodo_licenciamiento eq '' || $periodo == $periodo_licenciamiento) &&
        ($departamento_local eq '' || $departamento =~ /$departamento_local/i) &&
        ($denominacion_programa eq '' || $denominacion =~ /$denominacion_programa/i)) {
        push @resultados, $row; # Agregar el resultado a la lista
    }
}
close $fh;

# Mostrar los resultados
print $cgi->start_html('Resultados de la Búsqueda');
print $cgi->h1('Resultados de la Búsqueda');

if (@resultados) {
    print $cgi->start_table;
    print $cgi->Tr($cgi->th(['Nombre Universidad', 'Periodo Licenciamiento', 'Departamento Local', 'Denominación Programa']));
    foreach my $resultado (@resultados) {
        print $cgi->Tr($resultado);
    }
    print $cgi->end_table;
} else {
    print $cgi->p('No se encontraron resultados.');
}

print $cgi->a({ href => '../index.html' }, 'Volver a buscar');
print $cgi->end_html;
