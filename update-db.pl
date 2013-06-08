#!/usr/bin/perl 

use strict;
use warnings;

use DBI;
use Config::IniFiles;

use lib './lib';
use Paste::Conf;

my $config_file = 'paste.conf';

my $config = Config::IniFiles->new( -file => $config_file );
unless ($config) {
    my $error = "$!\n";
    $error .= join( "\n", @Config::IniFiles::errors );
    die "Could not load configfile '$config_file': $error";
}

my $dbname = $config->val( 'database', 'dbname' )
    || die "Databasename not specified in config";
my $dbdriver = $config->val( 'database', 'driver' )
    || die "Database driver not specified in config";
my $dbuser = $config->val( 'database', 'dbuser' )
    || die "Databaseuser not specified in config";
my $dbpass = $config->val( 'database', 'dbpassword' ) || '';

my $dbi_dsn = Paste::Conf->get_db_conf_string(
    {dbname => $dbname, driver => $dbdriver,},
);

my $dbh =
    DBI->connect( $dbi_dsn, $dbuser, $dbpass,
    { RaiseError => 0, PrintError => 0 } )
    or die "Could not connect to DB: " . $DBI::errstr;

my $rows_affected = $dbh->do("DELETE FROM LANG");

my $sth = $dbh->prepare( '
	INSERT INTO lang ("desc") VALUES (?) 
	' ) or die $dbh->errstr;

while ( my $l = <> ) {
    chomp($l);
    $sth->execute($l);
}

# vim: syntax=perl sw=4 ts=4 noet shiftround
