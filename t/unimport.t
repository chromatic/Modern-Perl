#! perl

use Test::More 0.98;
use Modern::Perl;

eval 'say "# say() should be available";';
is $@, '', 'say() should be available';

{
    no Modern::Perl;
    eval 'say "# say() should be unavailable when unimported"';
    like $@, qr/syntax error.+near "say /,
        'unimport should disable say feature';
    eval '$x = 1';
    is $@, '', 'unimport should disable strictures';

    my $warnings;
    local $SIG{__WARN__} = sub { $warnings = shift };
    my $y =~ s/hi//;
    unlike $warnings, qr/Use of uninitialized value/,
        'unimport should disable warnings';
}

done_testing;
