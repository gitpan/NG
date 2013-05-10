use Test::More;
use Test::Deep;
use lib '../lib';
use warnings;
use strict;
use NG;
 
def_class Animal => ['sex', 'leg_color'] => {
    sound => sub {
         return 1;
    },
    run => sub {
         return 100;
    },
};

def_class Dog => Animal => ['head_color'] => {
    eat => sub {
        my $self = shift;
        $self->head_color = shift;
    },
    run => sub {
        my $self = shift;
        return $self->head_color;
    },
};

my $y = Animal->new;
isa_ok $y, 'Animal';
is $y->run, 100, 'animal run ok';

my $x = Dog->new;
isa_ok $x, 'Dog';
$x->eat('bone');
is $x->run, 'bone', 'eat ok';
is $x->sound, 1, 'parent sound ok';
cmp_deeply $x->meta->{methods}, [qw/dump run sound eat/], 'list all methods ok';

done_testing;
