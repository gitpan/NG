use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::System;

my $s = new NG::System;
isa_ok $s, 'NG::System';

NG::System::local_run( 'w', sub {
    my ($out, $err) = @_;
    is substr($out->get(1), 0, 4), 'USER';
});

SKIP: {
    skip 'no password', 1;
    NG::System::remote_run( '127.0.0.1', 'w', sub {
        my ($out, $err) = @_;
    });
};

for my $i (qw /a b c/ ) {
    NG::System::fork_run(
        sub { my $parent = shift; my $ppid = $parent->pid; my $line = $parent->read; $parent->say("$ppid teach $line") },
        sub { my $child = shift; $child->say("$i");printf "%d learn: %s\n", $child->pid, $child->read; },
    );
};
