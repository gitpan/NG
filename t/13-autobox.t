use Test::More;
use Test::Deep;
use lib '../lib';
use NG::Autobox;

cmp_deeply 2->to(4), NG::Array->new(2, 3, 4);

is "test"->length, 4, "string length";

cmp_deeply "Hello World"->lc->words, NG::Array->new('hello', 'world');

done_testing;
