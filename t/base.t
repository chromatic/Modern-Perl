#! perl

use Test::More 0.98;

BEGIN
{
    delete $INC{'IO/File.pm'};
    delete $INC{'IO/Handle.pm'};

    use_ok( 'Modern::Perl' ) or exit;
    ok $INC{'IO/File.pm'},   'M::P should load IO::File';
    ok $INC{'IO/Handle.pm'}, 'M::P should load IO::Handle';

    Modern::Perl->import();
}

eval 'say "# say() should be available";';
is( $@, '', 'say() should be available' );

eval '$x = 1;';
like( $@, qr/Global symbol "\$x" requires explicit/,
    'strict should be enabled' );

my $warnings;
local $SIG{__WARN__} = sub { $warnings = shift };
my $y =~ s/hi//;
like( $warnings, qr/Use of uninitialized value/, 'warnings should be enabled' );

eval<<'END_CLASSES';

package A;

$A::VERSION = 1;

package B;

@B::ISA = 'A';

package C;

@C::ISA = 'A';

package D;

use Modern::Perl;

@D::ISA = qw( B C );

END_CLASSES

package main;

is_deeply( mro::get_linear_isa( 'D' ), [qw( D B C A )], 'mro should use C3' );

if ($] > 5.011003)
{
    eval q|
    use Modern::Perl;
    BEGIN
    {
      ok exists $^H{feature_unicode},
        '... and should unilaterally enable unicode_strings, when available';
    }
    |;
}

done_testing;
