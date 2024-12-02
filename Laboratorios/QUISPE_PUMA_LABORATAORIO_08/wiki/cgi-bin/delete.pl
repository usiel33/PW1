#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $query = CGI->new;
my $name = $query->param("name");
my $file_path = "./data/$name.md";

if (-e $file_path) {
    unlink($file_path) or die "No se pudo borrar el archivo: $!";
}

print $query->redirect("/cgi-bin/list.pl");
