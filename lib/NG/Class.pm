package NG::Class;
use strict;
use warnings;

=head2 def
    def_class Animal => undef => ['sex', 'leg_color'] => {
        sound => sub {  .... },
        run => sub { .... },
    };
    
    def_class Dog => Animal => ['head_color'] => {
        eat => sub { ... },
        run => sub { ... },   # override method
    };
    
    my $x = Dog->new;
    $x->eat('bone');
=cut
sub def {
    my ($class, $parent, $attrs, $methods) = @_;

    eval "package $class";
    eval "use $class";
    if( $parent ne 'undef' ) {
        *t = eval('*'.$class.'::ISA');
        *t = [$parent];
    }

    for my $method ( keys %{$methods} ) {
        if(ref($methods->{$method}) eq 'CODE'){
            *t = eval('*'.$class.'::'.$method);
            *t = $methods->{$method};
        }
    }

    for my $attr ( @{$attrs} ) {
        *t = eval('*'.$class.'::'.$attr);
        *t = sub :lvalue {
            shift->{$attr};
        };
    }

    *t = eval('*'.$class.'::new');
    *t = sub {
        my $o = bless {map {($_, undef)} @$attrs}, $class;
        my $args;
        my ($class, @args) = @_;
        if(scalar(@args)==1){
            $args = $args[0];
        }
        else{
            $args = \@args;
        }
        if(defined $methods->{build}){
            $o->build($args);
        }
        $o;
    }

}

1;
