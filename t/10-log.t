use Test::More 'no_plan';
use lib '../lib';
use NG::Log;

my $log = new NG::Log;

isa_ok $log, 'NG::Log';

my $logpath = 't/log.txt';
NG::Log::process_log($logpath, sub {
    my ($fields) = @_;    # 第一个参数是 Array 类型
    isa_ok $fields, 'NG::Array';
    ok $fields->get(1) ~~ /^\d{3}&abc$/;  # 获取第2个字段
});

NG::Log::process_log($logpath, sub {
    my ($fields) = @_;
    is $fields->get(1), 'abc', 'split using &';
}, '&');
