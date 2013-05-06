use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::SHashtable;
use NG::Array;

my $hash = new NG::SHashtable;

isa_ok $hash, 'NG::SHashtable';

$hash->put( 'key1', 1 );
$hash->put( 'key2', 2 );
$hash->put( 'key3', 3 );

is $hash->get('key1'), 1;

my $array = new NG::Array;
$hash->each(
    sub {
        my ( $key, $val ) = @_;
        $array->push( $key );
    }
);

cmp_deeply $array, NG::Array->new( 'key1', 'key2', 'key3' );
