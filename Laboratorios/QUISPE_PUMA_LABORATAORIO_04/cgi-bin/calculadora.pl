#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Math::BigFloat;

my $cgi = CGI->new;

print $cgi->header('text/html');
print "<html><head><title>Resultado</title><link rel='stylesheet' href='../css/estilo.css'></head><body>";

# Obtener la expresión enviada desde el formulario
my $expresion = $cgi->param('expresion');

if ($expresion) {
    # Limpiar la expresión de posibles espacios en blanco
    $expresion =~ s/\s+//g;

    # Evaluar la expresión usando eval
    my $resultado = eval_expression($expresion);

    if (defined $resultado) {
        print "<h1>Resultado: $resultado</h1>";
    } else {
        print "<h1>Error: Expresión inválida. Asegúrate de usar un formato válido.</h1>";
    }
} else {
    print "<h1>Error: No se ingresó ninguna expresión</h1>";
}

# Añadir la clase 'btn' al enlace de 'Volver'
print "<br><a href='/' class='btn'>Volver</a>";
print "</body></html>";

sub eval_expression {
    my ($exp) = @_;

    # Intentar evaluar la expresión
    my $resultado;
    eval {
        $resultado = Math::BigFloat->new(eval $exp);
    };

    if ($@) {
        return undef; # Si hay un error en la evaluación
    }

    return $resultado;
}
