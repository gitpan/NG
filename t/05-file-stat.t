use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::File;
use NG::Time;

my $f = NG::File->new('/tmp');
isa_ok $f, 'NG::File';

my $stat = $f->fstat;
isa_ok $stat, 'NG::Hashtable';

is $stat->{mode}, '1777';
is $stat->{uid}, 0;

isa_ok $stat->{atime}, 'NG::Time';
is $stat->{atime}->year, NG::Time->now->year;
