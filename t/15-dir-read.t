use Test::More;
use lib '../lib';
use NG::Dir;

my $d = new NG::Dir;
isa_ok $d, 'NG::Dir';

my $list = $d->read('/');
isa_ok $list, 'NG::Array';

$d->read('.', sub {
    my ($dir, $file) = @_;
    ok $file, 'is file' if -f $dir.$file;
});

done_testing();
