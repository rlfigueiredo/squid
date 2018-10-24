#!/usr/bin/perl

$infile = `cat squid.conf.solucont`;

@todos = split ( /\n/ , $infile ) ;

foreach $linha ( @todos ) {
	@cada = split ( // , $linha);
	if ( "$cada[0]" ne "#" && "$cada[0]" ne "") {
		print "$linha\n"
	}
	#print "$cada[0]\n";
}
