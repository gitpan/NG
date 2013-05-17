package NG::System;
use warnings;
use strict;
use autodie;
use base 'NG::Object';
use NG::Array;
use IPC::Open3;
use Symbol;
use Sys::CpuAffinity;
use Net::SSH::Any;
use Data::Dumper;
use Child;

sub new {
    my $pkg = shift;
    return bless {}, $pkg;
}

=head2 local_run
    local_run "ls", sub {
	    my ($out, $err) = @_;
	    $out->each(sub{
	       ...
	    })
	    ...
    }
=cut
sub local_run {
    my $inh  = gensym;
    my $outh = gensym;
    my $errh = gensym;
    my $cb;
    if ( ref($cb) ne 'CODE' ) {
        $cb = pop @_;
    }
    my @commands = @_;

    my $ret = open3( $inh, $outh, $errh, @commands );

    my $stdout = NG::Array->new;
    my $stderr = NG::Array->new;
    while (<$outh>) {
        chomp;
        $stdout->push($_);
    }
    while (<$errh>) {
        chomp;
        $stderr->push($_);
    }
    if ( defined $cb ) {
        $cb->( $stdout, $stderr );
        return $ret;
    }
    else {
        return $stdout;
    }
}

=head2 remote_run
TODO: async ssh command
    remote_run @hosts, $cmd, sub {
	    my ($out, $err) = @_;
    }
=cut
sub remote_run {
    my $cb    = pop @_;
    my $cmd   = pop @_;
    for my $host (@_) {
        my $ssh = Net::SSH::Any->new($host);
        my ($out, $err) = $ssh->capture2($cmd);
        $cb->($out, $err);
    };
}

=head2 taskset
    taskset($subpid, [0, 2])
=cut
sub taskset {
    my ( $pid, @cpus ) = @_;
    Sys::CpuAffinity::setAffinity( $pid, \@cpus );
}

=head2 fork_run
    Array->new(1, 2, 3)->each(sub {
        my $i = shift;
        System::fork_run(
            sub { my $parent = shift; my $ppid = $parent->pid; my $line = $parent->read; $parent->say("$ppid teach $line") },
            sub { my $child = shift; $child->say("$i");printf "%d learn: %s\n", $child->pid, $child->read; },
        );
    });
=cut
sub fork_run {
    my ( $code, $cb ) = @_;
    my $child = Child->new(sub {
        my ( $parent ) = @_;
        $code->($parent);
    }, pipe => 1);
    my $proc = $child->start;
    $cb->($proc);
};

1;
