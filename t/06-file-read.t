use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::File;
use NG::Array;

my $f = new NG::File;

isa_ok $f, 'NG::File';

my $log = 't/log.txt';
my $got = NG::File::read_file($log);
is $got, "line1 123&abc\nline2 321&abc";

NG::File::read_file($log, sub {
    my ($line) = @_;
    cmp_deeply $line, NG::Array->new( 'line1 123&abc', 'line2 321&abc' );
});

my $list = NG::File::read_dir('/');
isa_ok $list, 'NG::Array';

NG::File::read_dir('.', sub {
    my ($dir, $file) = @_;
    ok $file, 'is file' if -f $dir.$file;
});
