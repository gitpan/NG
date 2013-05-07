use Test::More;
use lib '../lib';
use warnings;
use strict;
use NG::Class;
 
NG::Class::def Animal => undef => ['sex', 'leg_color'] => {
    sound => sub {
         return 1;
    },
    run => sub {
         return 100;
    },
};

NG::Class::def Dog => Animal => ['head_color'] => {
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

done_testing;
