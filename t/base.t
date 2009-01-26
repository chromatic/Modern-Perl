#! perl

use Test::More tests => 3;

use Modern::Perl;

eval 'say "# say() should be available";';
is( $@, '', 'say() should be available' );

eval '$x = 1;';
like( $@, qr/Global symbol "\$x" requires explicit/,
    'strict should be enabled' );

my $warnings;
local $SIG{__WARN__} = sub { $warnings = shift };
my $y =~ s/hi//;
like( $warnings, qr/Use of uninitialized value/, 'warnings should be enabled' );
