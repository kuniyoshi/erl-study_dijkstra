#!/usr/bin/perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Data::Dumper;
use Template;
use Path::Class qw( file );

my @erls = map { file( $_ ) }
           glob "lib/*.erl";

my $template = Template->new;
$template->process(
    \*DATA,
    { erls => \@erls },
    \my $makefile,
)
    or die $template->error;

say { file( "Makefile" )->openw } $makefile;

exit;

__DATA__
.PHONY: s self c compile

c: compile
compile: $(subst lib/,ebin/,$(addsuffix .beam,$(basename $(wildcard lib/*.erl))))

s: self
self:
	perl Makefile.pl

[% FOREACH erl IN erls -%]
ebin/[% GET erl.basename.replace( ".erl", ".beam" ) %]: [% GET erl %]
	erlc -I include -o ebin $<
[% END # FOREACH erl IN erls -%]
