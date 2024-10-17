#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;

print $cgi->header('text/html');
print "<html><head><title>Resultado</title></head><body>";

# Obtener la expresión enviada desde el formulario
my $expresion = $cgi->param('expresion');

if ($expresion) {
    # Limpiar la expresión de posibles espacios en blanco
    $expresion =~ s/\s+//g;

    # Expresión regular para detectar números y operadores (+, -, *, /)
    if ($expresion =~ /^([\-]?\d+\.?\d*)([\+\-\*\/])([\-]?\d+\.?\d*)$/) {
        my $num1 = $1;
        my $operador = $2;
        my $num2 = $3;
        my $resultado;

        # Realizar la operación correspondiente
        if ($operador eq '+') {
            $resultado = $num1 + $num2;
        } elsif ($operador eq '-') {
            $resultado = $num1 - $num2;
        } elsif ($operador eq '*') {
            $resultado = $num1 * $num2;
        } elsif ($operador eq '/') {
            # Verificar que no se divida entre cero
            if ($num2 == 0) {
                $resultado = "Error: No se puede dividir entre cero";
            } else {
                $resultado = $num1 / $num2;
            }
        }

        print "<h1>Resultado: $resultado</h1>";
    } else {
        print "<h1>Error: Expresión inválida. Usa el formato: número operador número (ej: 5+3)</h1>";
    }
} else {
    print "<h1>Error: No se ingresó ninguna expresión</h1>";
}

print "<br><a href='../index.html'>Volver</a>";
print "</body></html>";
