#! perl

use Test::More 0.98;

use Modern::Perl ();

$SIG{__WARN__} = sub
{
    return if $_[0] =~ /Number found where operator expected/;
    return if $_[0] =~ /Do you need to predeclare/;
    return if $_[0] =~ /future reserved word/;
    warn shift
};

eval 'sub { given (0) {} }';
isnt $@, '', 'use Modern::Perl () does not enable switch';
eval 'sub { say 0 }';
isnt $@, '', 'use Modern::Perl () does not enable say';
eval 'state $x;';
isnt $@, '', 'use Modern::Perl () does not enable state';
is uc "\xdf", "\xdf", 'Modern::Perl () does not enable unicode_strings';
eval 'sub { return __SUB__ }';
is $@, '', q|use Modern::Perl '2013' does not enable current_sub|;
my $warning = '';
local $SIG{__WARN__} = sub { $warning = shift };
eval 'fc("tschüß") eq fc("TSCHÜSS")';
isnt $@, '', q|use Modern::Perl () does not enable fc|;

{
    use Modern::Perl '2009';
    eval 'sub { given (0) {} }';
    is $@, '', q|use Modern::Perl '2009' enables switch|;
    eval 'sub { say 0 }';
    is $@, '', q|use Modern::Perl '2009' enables say|;
    eval 'state $x';
    is $@, '', q|use Modern::Perl '2009' enables state|;
    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

{
    use Modern::Perl '2010';
    eval 'sub { given (0) {} }';
    is $@, '', q|use Modern::Perl '2010' enables switch|;
    eval 'sub { say 0 }';
    is $@, '', q|use Modern::Perl '2010' enables say|;
    eval 'state $x';
    is $@, '', q|use Modern::Perl '2010' enables state|;
    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

if ($] >= 5.012)
{
    eval q{
        use Modern::Perl '2011';
        eval 'sub { given (0) {} }';
        is $@, '', q|use Modern::Perl '2011' enables switch|;
        eval 'sub { say 0 }';
        is $@, '', q|use Modern::Perl '2011' enables say|;
        eval 'state $x';
        is $@, '', q|use Modern::Perl '2011' enables state|;
        is uc "\xdf", "SS", '2011 enables unicode_strings';
    };
}

if ($] >= 5.014)
{
    eval q{
        use Modern::Perl '2012';
        eval 'sub { given (0) {} }';
        is $@, '', q|use Modern::Perl '2012' enables switch|;
        eval 'sub { say 0 }';
        is $@, '', q|use Modern::Perl '2012' enables say|;
        eval 'state $x';
        is $@, '', q|use Modern::Perl '2012' enables state|;
        is uc "\xdf", "SS", '2012 enables unicode_strings';
    };
}

if ($] >= 5.016)
{
    eval q{
        use Modern::Perl '2013';
        eval 'sub { given (0) {} }';
        is $@, '', q|use Modern::Perl '2013' enables switch|;
        eval 'sub { say 0 }';
        is $@, '', q|use Modern::Perl '2013' enables say|;
        eval 'state $x';
        is $@, '', q|use Modern::Perl '2013' enables state|;
        is uc "\xdf", "SS", '2013 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is $@, '', q|use Modern::Perl '2013' enables current_sub|;
        my $warning = '';
        local $SIG{__WARN__} = sub { $warning = shift };
        eval '$[ = 10';
        like $warning, qr/Use of assignment to \$\[ is deprecated/,
            q|use Modern::Perl '2013' disables array_base|;
        eval 'fc("tschüß") eq fc("TSCHÜSS")';
        is $@, '', q|use Modern::Perl '2013' enables fc|;
    };
    is $@, '', 'this block should succeed';
}

eval 'sub { given (0) {} }';
isnt $@, "", 'switch feature does not leak out';
eval 'sub { say 0 }';
isnt $@, '', 'say feature does not leak out';
eval 'state $x';
isnt $@, '', 'state feature does not leak out';
is uc "\xdf", "\xdf", 'unicode_strings feature does not leak out';

done_testing;
