use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::Time;

my $t = new NG::Time;
isa_ok $t, 'NG::Time';

is $t->strftime("%Y", $t->now), $t->now->year;
