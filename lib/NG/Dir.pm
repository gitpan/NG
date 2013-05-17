use File::Copy::Recursive ();
use File::Find;
use NG::Array;
use NG::Class;
NG::Class::def 'NG::Dir' => 'NG::File' => [] => {
    read => sub {
        my $self = shift;
        if ( ref( $_[-1] ) eq 'CODE' ) {
            my $cb      = pop @_;
            my @dirpath = @_;
            File::Find::find(
                sub {
                    $cb->( $File::Find::dir, $_ );
                },
                @dirpath
            );
        }
        else {
            my $dirpath = shift;
            return NG::Array->new( glob("$dirpath/*") );
        }
    },
    make   => sub { shift; File::Copy::Recursive::pathmk(@_) },
    remove => sub { shift; File::Copy::Recursive::pathrm(@_) },
};
