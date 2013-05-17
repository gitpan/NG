use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::File;
use NG::Array;

my $f = new NG::File;

isa_ok $f, 'NG::File';

my $log = 't/log.txt';

cmp_deeply $f->read($log), NG::Array->new( 'line1 123&abc', 'line2 321&abc' ), 'file read as array';

is $f->md5($log), '55dbbfe5cc8b26bca961406b6e35152e', 'file md5sum';
