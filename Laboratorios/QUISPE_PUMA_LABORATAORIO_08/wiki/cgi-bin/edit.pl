#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $query = CGI->new;
my $name = $query->param("name");
my $content = $query->param("content");
my $file_path = "./data/$name.md";

if ($content) {
    open(my $fh, '>', $file_path) or die "No se pudo guardar el archivo: $!";
    print $fh $content;
    close($fh);
    print $query->redirect("/cgi-bin/list.pl");
} elsif ($name) {
    open(my $fh, '<', $file_path) or die "No se pudo abrir el archivo: $!";
    my @lines = <$fh>;
    close($fh);

    my $current_content = join("", @lines);

    print "Content-type: text/html\n\n";
    print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/styles.css">
    <title>Editar Página</title>
</head>
<body>
    <header>
        <h1>Editar Página: $name</h1>
    </header>
    <div class="container">
        <form action="/cgi-bin/edit.pl" method="post">
            <textarea name="content" rows="10">$current_content</textarea>
            <input type="hidden" name="name" value="$name">
            <button type="submit">Guardar Cambios</button>
        </form>
        <a href="/cgi-bin/list.pl" class="button">Cancelar</a>
    </div>
    <footer>
        <p>2024 Usiel Suriel Quispe Puma</p>
    </footer>
</body>
</html>
HTML
}
