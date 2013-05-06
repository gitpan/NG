use Test::More;
use Test::Deep;
use lib '../lib';
use NG::Array;
use NG::Hashtable;

my $ar = NG::Array->new(10, 3, 9, 7);

ok($ar->[0] == 10, "get");

my $ar2 = $ar->sort(sub {
                        my ($a, $b) = @_;
                        return $a <=> $b;
                    });

ok($ar2->[0] == 3, "sort");

my $sum = 0;
my $sumi = 0;

$ar->each(sub {
              my ($item, $i) = @_;
              $sum += $item;
              $sumi += $i;
          });

ok($sum == 29, "each");
ok($sumi == 6, "each index");

$ar->push(5);

ok($ar->[4] == 5, "push");

$ar->unshift(27);

ok($ar->[0] == 27, "unshift");

my $v = $ar->pop();

ok($v == 5, "pop 1");
ok($ar->[4] == 7, "pop 2");

ok($ar->size() == 5, "size");

$v = $ar->shift();
ok($v == 27, "shift 1");
ok($ar->[0] == 10, "shift 2");

$v = $ar->join(':');
ok($v eq '10:3:9:7', "join :");

my $h = $ar->zip(NG::Array->new(qw/a b c d/))->to_hash;
cmp_deeply $h, NG::Hashtable->new(qw/10 a 3 b 9 c 7 d/), "zip Arrays to hash";

$ar->push(7);
cmp_deeply $ar->uniq, NG::Array->new(10, 3, 9, 7), "uniq";

cmp_deeply $ar->grep(sub {
	$_ > 5
	}), NG::Array->new(10, 9, 7, 7), "grep";

ok($ar->min == 3, "min");

done_testing;
