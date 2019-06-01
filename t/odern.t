#! perl

use Test::More;

use odern::Perl ();

{
    eval "use odern::Perl; sub say { 0 }";
    is $@, "", 'use odern::Perl enables say';
}

{
    eval "use odern::Perl '3030'; ok( 0 )";
    like $@, qr/Unknown date '3030' requested/,
        q|use odern::Perl '3030' throws year error|;
}

done_testing;
