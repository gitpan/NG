requires 'autodie';
requires 'autobox';
requires 'Try::Tiny';
requires 'AnyEvent::HTTP';
requires 'DBI';
requires 'File::Copy::Recursive';
requires 'Spreadsheet::ParseExcel';
requires 'Spreadsheet::WriteExcel';
requires 'HTML::Element', '>= 5.00';
requires 'HTML::TreeBuilder::XPath';
requires 'HTML::Selector::XPath';
requires 'Time::HiRes';
requires 'SQL::Abstract';
requires 'Child';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Deep';
}
