#!/usr/bin/perl

use strict;
use warnings;

#wndchrm_debug classify  -l -B1112,760,280,280 NewNotRotated-ml.fit G\ -\ 9\(fld\ 37\ wv\ TL\ -\ DIC\ -\ Open\).tif

sub RunWNDCHRM_atROI($$$$)
{
	my $X = $_[0];
	my $Y = $_[1];
	my $deltaX = $_[2];
	my $deltaY = $_[3];

	my $wndchrm = "~/src/svn.irp.nia.nih.gov/clean_trunk/iicbu/wndchrm/branches/wndchrm-1.30/wndchrm";
	my $training_fit = "NewNotRotated-ml.fit";
	my $test_image = 'G\ -\ 9\(fld\ 37\ wv\ TL\ -\ DIC\ -\ Open\).tif';

	my $test_image_reg_exp = 'G - 9\(fld 37 wv TL - DIC - Open\)\.tif';

	my $cmd = "$wndchrm classify -l -s1 -B$X,$Y,$deltaX,$deltaY $training_fit $test_image";
	print "Running wndchrm command:\n $cmd \n";
	my @output = `$cmd`;

	#print "Here was the output: $output\n\n";
	foreach (@output) {
		if( /^$test_image_reg_exp\s+\S+\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/ ) {
			print "Caught marginal probabilities $1, $2, $3, $4\n";
			return ($1, $2, $3, $4 );
		}
	}

	return -1;
}

sub PrintLetter {
	my $aref = @_;
	my $max = 0;
	foreach (@$aref) {
		if( $_ > $max ) {
			$max = $_;
		}
	}

	if( $$aref[0] == $max ) {
		print 'B';
	} elsif( $$aref[1] == $max ) {
		print 'D';
	} elsif( $$aref[2] == $max ) {
		print 'H';
	} else {
		print 'T';
	}
}

sub main {

	my $image_width = 1392;
	my $image_height = 1040;
	my $kernel_width = 280;
	my $kernel_height = 280;
	my $granularity = 30;

	my $deltaX = int( $image_width / $granularity );
	my $deltaY = int( $image_height / $granularity );

	my $col = 0;
	my $row = 0;

	my @results_matrix;

	for( my $x = 0; $x <= $image_width - $kernel_width; $x += $deltaX ) {
		$row = 0;
		for( my $y = 0; $y <= $image_height - $kernel_height; $y += $deltaY ) {
			print "col $col, row $row, x: $x, y: $y, kernel width: $kernel_width, kernel height: $kernel_height\n";
			@{ $results_matrix[$col][$row] } = RunWNDCHRM_atROI( $x, $y, $kernel_width, $kernel_height );
			$row++;
		}
		$col++
	}

	for( my $x = 0; $x <= $#results_matrix; $x++ ) {
		for( my $y = 0; $y <= $#{ $results_matrix[0] }; $y++ ) {
			PrintLetter( $results_matrix[$x][$y] );
		}
		print "\n";
	}
	return 0;
}

&main;
