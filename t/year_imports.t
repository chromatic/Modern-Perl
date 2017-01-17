#! perl

use Test::More 0.98;

use Modern::Perl ();

$SIG{__WARN__} = sub
{
    return if $_[0] =~ /Number found where operator expected/;
    return if $_[0] =~ /Do you need to predeclare/;
    return if $_[0] =~ /future reserved word/;
    return if $_[0] =~ /given is experimental/;
    warn shift
};

sub _get_year {
    my $year = shift;
    return $year eq '()' ? $year : "'$year'";
}

sub test_lexical_subs_for
{
    # lexical subs removed from feature.pm in 5.25.2
    return if $] >= 5.025002;

    my $year = _get_year(shift);
    eval qq|use Modern::Perl $year; my sub foo {}|;
    isnt $@, '', qq|use Modern::Perl '$year' should not enable lexical subs|;
}

sub test_switch_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; sub { given (0) {} }|;
    is $@, '', qq|use Modern::Perl $year enables switch|;
}

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
{
    local $SIG{__WARN__} = sub { $warning = shift };
    eval 'fc("tschüß") eq fc("TSCHÜSS")';
    isnt $@, '', q|use Modern::Perl () does not enable fc|;
}

{
    use Modern::Perl '2009';
    test_switch_for( '2009' );
    eval 'sub { say 0 }';
    is $@, '', q|use Modern::Perl '2009' enables say|;
    eval 'state $x';
    is $@, '', q|use Modern::Perl '2009' enables state|;
    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

{
    use Modern::Perl '2010';
    test_switch_for( '2010' );
    eval 'sub { say 0 }';
    is $@, '', q|use Modern::Perl '2010' enables say|;
    eval 'state $x';
    is $@, '', q|use Modern::Perl '2010' enables state|;
    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

if ($] >= 5.012)
{
    my $year = 2011;
    eval qq{
        use Modern::Perl '$year';
        test_switch_for( '$year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2011' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2011' enables state|;
        is uc "\xdf", "SS", '2011 enables unicode_strings';
    };
}

if ($] >= 5.014)
{
    my $year = 2012;

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( '$year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2012' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2012' enables state|;
        is uc "\xdf", "SS", '2012 enables unicode_strings';
    };
}

if ($] >= 5.016)
{
    my $year = 2013;
    local $@;
    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( '$year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2013' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2013' enables state|;
        is uc "\xdf", "SS", '2013 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is \$@, '', q|use Modern::Perl '2013' enables current_sub|;
        eval '\$[ = 10';
        like \$warning, qr/Use of assignment to \\\$\\[ is deprecated/,
            q|use Modern::Perl '2013' disables array_base|;
        eval 'fc("tschüß") eq fc("TSCHÜSS")';
        is \$@, '', q|use Modern::Perl '2013' enables fc|;
        test_lexical_subs_for( '$year' );
    };
    is $@, '', 'this block should succeed';
}

if ($] >= 5.018)
{
    my $year = 2014;
    local $@;

    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( '$year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2014' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2014' enables state|;
        is uc "\xdf", "SS", '2014 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is \$@, '', q|use Modern::Perl '2014' enables current_sub|;
        eval '\$[ = 10';
        like \$warning, qr/Use of assignment to \\\$\\[ is deprecated/,
            q|use Modern::Perl '2014' disables array_base|;
        eval 'fc("tschüß") eq fc("TSCHÜSS")';
        is \$@, '', q|use Modern::Perl '2014' enables fc|;
        test_lexical_subs_for( '2014' );
    };
    is $@, '', 'this block should succeed';
}

if ($] >= 5.020)
{
    my $year = 2015;
    local $@;

    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( '$year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2015' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2015' enables state|;
        is uc "\xdf", "SS", '2015 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is \$@, '', q|use Modern::Perl '2015' enables current_sub|;
        eval '\$[ = 10';
        like \$warning, qr/Use of assignment to \\\$\\[ is deprecated/,
            q|use Modern::Perl '2015' disables array_base|;
        eval 'fc("tschü¼Ã")eq fc("TSCHÃS")';
        is \$@, '', q|use Modern::Perl '2015' enables fc|;
        test_lexical_subs_for( '2015' );
    };
    is $@, '', 'this block should succeed';
}

if ($] >= 5.024)
{
    my $year = 2016;
    local $@;

    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( $year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2016' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2016' enables state|;
        is uc "\xdf", "SS", '2016 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is \$@, '', q|use Modern::Perl '2016' enables current_sub|;
        eval '\$[ = 10';
        like \$warning, qr/Use of assignment to \\\$\\[ is deprecated/,
            q|use Modern::Perl '2016' disables array_base|;
        eval 'fc("tschü¼Ã")eq fc("TSCHÃS")';
        is \$@, '', q|use Modern::Perl '2016' enables fc|;
        eval 'my \$r = [ 1, [ 2, 3 ], 4 ]; \$r->[1]->@*';
        is \$@, '', q|use Modern::Perl '2016' enables postderef_qq|;
        test_lexical_subs_for( '2016' );
    };
    is $@, '', 'this block should succeed';
}

if ($] >= 5.024)
{
    my $year = 2017;
    local $@;

    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    eval qq{
        use Modern::Perl '$year';
        test_switch_for( $year' );
        eval 'sub { say 0 }';
        is \$@, '', q|use Modern::Perl '2017' enables say|;
        eval 'state \$x';
        is \$@, '', q|use Modern::Perl '2017' enables state|;
        is uc "\xdf", "SS", '2017 enables unicode_strings';
        eval 'sub { return __SUB__ }';
        is \$@, '', q|use Modern::Perl '2017' enables current_sub|;
        eval '\$[ = 10';
        like \$warning, qr/Use of assignment to \\\$\\[ is deprecated/,
            q|use Modern::Perl '2017' disables array_base|;
        eval 'fc("tschü¼Ã")eq fc("TSCHÃS")';
        is \$@, '', q|use Modern::Perl '2017' enables fc|;
        eval 'my \$r = [ 1, [ 2, 3 ], 4 ]; \$r->[1]->@*';
        is \$@, '', q|use Modern::Perl '2017' enables postderef_qq|;
        test_lexical_subs_for( '2017' );
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
