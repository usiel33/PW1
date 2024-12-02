#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $query = CGI->new;
my $page_name = $query->param("page_name");
my $content = $query->param("content");

if ($page_name && $content) {
    my $file_path = "./data/$page_name.md";
    open(my $fh, '>', $file_path) or die "No se pudo crear el archivo: $!";
    print $fh $content;
    close($fh);

    print $query->redirect("/cgi-bin/list.pl");
} else {
    print "Content-type: text/html\n\n";
    print "<p>Error: Nombre o contenido de la página no válidos.</p>";
}
