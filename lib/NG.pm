package NG;
use strict;
use warnings;
use Try::Tiny;

our $VERSION = '0.001_02';
use Spreadsheet::ParseExcel;
use NG::Autobox;
use NG::Array;
use NG::DB;
use NG::Excel;
use NG::Excel::Cell;
use NG::Excel::Sheet;
use NG::HTTP::Client;
use NG::EMail;
use NG::File;
use NG::Log;
use NG::System;
use NG::Time;

use base 'Exporter';
our @EXPORT = qw(
  local_run
  remote_run
  fork_run
  taskset

  web_get

  mail_send
  mail_get

  from_json
  from_yaml
  mkdir_p
  rm_r
  cp_r
  read_file
  read_dir
  file_stat

  process_log
  geo_ip

  db

  parse_excel

  def_class
);

sub local_run   { NG::System::local_run(@_) }
sub remote_run  { NG::System::remote_run(@_) }
sub for_run     { NG::System::fork_run(@_) }
sub taskset     { NG::System::taskset(@_) }
sub web_get     { NG::HTTP::Client::web_get(@_) }
sub mail_send   { NG::EMail::send(@_) }
sub mail_get    { NG::EMail::get(@_) }
sub from_json   { NG::File::from_json(@_) }
sub from_yaml   { NG::File::from_yaml(@_) }
sub mkdir_p     { NG::File::mkdir_p(@_) }
sub rm_r        { NG::File::rm_r(@_) }
sub cp_r        { NG::File::cp_r(@_) }
sub read_file   { NG::File::read_file(@_) }
sub read_dir    { NG::File::read_dir(@_) }
sub file_stat   { NG::File::fstat(@_) }
sub process_log { NG::Log::process_log(@_) }
sub geo_ip      { NG::Log::geo_ip(@_) }
sub def_class   { NG::Class::def(@_) }
sub db          { NG::DB->new(@_) }

sub parse_excel {
    my ( $filepath, $cb ) = @_;
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($filepath);
    if ( !defined $workbook ) {
        die $parser->error() . "\n";
    }
    my $ng_sheet_arr = NG::Array->new;
    for my $sheet ( $workbook->worksheets() ) {
        my ( $row_min, $row_max ) = $sheet->row_range();
        my ( $col_min, $col_max ) = $sheet->col_range();

        my $ng_sheet = NG::Excel::Sheet->new(
            name      => $sheet->get_name(),
            row_count => $row_max + 1,
            col_count => $col_max + 1,
        );

        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {
                my $cell = $sheet->get_cell( $row, $col );
                next unless $cell;

                my $ng_cell = NG::Excel::Cell->new( value => $cell->value(), );
                $ng_sheet->{cells}->[$row][$col] = $ng_cell;
            }
        }
        $ng_sheet_arr->push($ng_sheet);
    }

    my $ng_excel = NG::Excel->new($ng_sheet_arr);
    if ( defined $cb ) {
        $cb->($ng_excel);
        $ng_excel->save($filepath);
    }
    else {
        return $ng_excel;
    }
}


sub import {
    my $class = shift;
    strict->import;
    warnings->import;
    utf8->import;
    feature->import(':5.10');
    Try::Tiny->import;
    NG::Autobox::import($class);
    $class->export_to_level(1, $class, @EXPORT);
}

1;

__END__

=pod

=head1 NAME

NG - Newbie::Gift or Next::Generation?? hoho~

=head1 DESCRIPTION

Newbie::Gift is a repo lanched by Achilles Xu. He wants to write a sub-language 
which exports useful keywords as many as possible, has a simple Object-oriented 
syntax as php4 or java-0.1, and uses callback replace return values as nodejs.

Idea comes because Steven Little's Moe.

Before Achilles implement all the base object and syntax one day in the future,
I just try to write this module for only exporting some keywords useful to myself.

Maybe some day Achilles will give us a brand-new and beautiful syntax, maybe lisp-like.

Everyone interested click please: L<https://github.com/PerlChina/Newbie-Gift>.

=head1 SYNOPSIS

Though I like L<Function::Parameters> very much, but sub features maybe re-implemented
by Achilles, so I donot import them. By now, there are only few keywords export:

=over 4

=item local_run

Capsulate IPC::Open3 for STDOUT/STDERR, no more exec/system, idea from L<Rex>.

=item remote_run

TODO

=item taskset

=item web_get

Capsulate AnyEvent::HTTP and HTML::TreeBuilder, idea from L<Mojo::UserAgent> and 
L<Mojo::DOM>.

=item mail_send

=item mail_get

Capsulate Net::POP3 and Email::MIME and Encode, return headers and body respectively.
Just like action of C<<web_get>>.

=item from_json

Load JSON file to be a NG object(C<<Array>> or C<<Hashtable>>).

=item from_yaml

Load YAML file to be a NG object(C<<Array>> or C<<Hashtable>>).

=item mkdir_p

=item rm_r

=item cp_r

=item read_file

Capsulate open and while, use callback for each line.

=item read_dir

Capsulate glob and File::Find, use callback for find, while return value for glob.

=item file_stat

No one want calculate file mode and ctime/mtime/atime anymore. 
I implement a C<<Time>> object and file_stat will return such object.

=item process_log

Capsulate split for log process, use callback for each line and each field.

=item geo_ip

use Geo::IP or match ip from a YAML-like ipaddr database by yourself.

=item db

Capsulate DBI CRUD operator, idea from L<Dancer::Plugin::Database::Handle>.
But use L<SQL::Abstract> for %options.

=item parse_excel

=back

=head1 OBJECT

Now we implment few ojbect base on C<<Object>> as follow:

C<<Array>>, C<<Hashtable>>, C<<SHashtable>>,
C<<Time>>, C<<HTTP::DOM>>, C<<Excel>>

=head1 AUTHOR

Chenryn C<< <rao.chenlin@gmail.com> >>
Achilles C<< <formalin14@gmail.com> >>
Terrence C<< <hanliang1990@gmail.com> >>

=head1 COPYRIGHT & LICENSE
 
Copyright 2009-2012 chenryn, all rights reserved.
 
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.14 itself.

=cut
