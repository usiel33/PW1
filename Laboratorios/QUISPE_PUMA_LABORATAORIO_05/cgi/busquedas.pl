#!/usr/bin/perl
use strict;
use warnings;
use CGI ':standard';

print header('text/html');
print start_html('Resultados de Búsqueda');

# Obtener parámetros de la URL
my $nombre = param('nombre') || '';
my $departamento = param('departamento') || '';

# Definir las columnas para extraer del CSV
my @columnas = (
    "NOMBRE",                 # Nombre Universidad
    "PERIODO_LICENCIAMIENTO", # Periodo Licenciamiento
    "DEPARTAMENTO_LOCAL",     # Departamento Local
    "DENOMINACION_PROGRAMA"   # Denominación Programa
);

# Leer el archivo CSV
open my $file, '<', '/usr/local/apache2/htdocs/data/universidades.csv' or die "No se puede abrir el archivo: $!";
my $header = <$file>;

# Identificar índices de las columnas
my %col_indices;
my @headers = split /\|/, $header;
for my $i (0..$#headers) {
    $col_indices{$headers[$i]} = $i;
}

# Validar que las columnas necesarias existen
for my $col (@columnas) {
    die "Columna $col no encontrada en el archivo" unless exists $col_indices{$col};
}

# Imprimir resultados de la tabla
print "<table border='1'><tr><th>Nombre Universidad</th><th>Periodo Licenciamiento</th><th>Departamento Local</th><th>Denominación Programa</th></tr>";

while (my $line = <$file>) {
    chomp $line;
    my @fields = split /\|/, $line;

    # Aplicar filtros si están definidos
    next if $nombre && $fields[$col_indices{'NOMBRE'}] !~ /\Q$nombre\E/i;
    next if $departamento && $fields[$col_indices{'DEPARTAMENTO_LOCAL'}] !~ /\Q$departamento\E/i;

    # Imprimir filas
    print "<tr>";
    print "<td>$fields[$col_indices{'NOMBRE'}]</td>";
    print "<td>$fields[$col_indices{'PERIODO_LICENCIAMIENTO'}]</td>";
    print "<td>$fields[$col_indices{'DEPARTAMENTO_LOCAL'}]</td>";
    print "<td>$fields[$col_indices{'DENOMINACION_PROGRAMA'}]</td>";
    print "</tr>";
}


print "</table>";
print end_html;

close $file;
