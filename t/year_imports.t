#! perl

use Test::More 0.98;

use Modern::Perl ();

if ($ENV{PERL5OPT}) {
    plan( skip_all => "Cannot reliably test with PERL5OPT set" );
    exit 0;
}

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
    isnt $@, '', qq|use Modern::Perl $year should not enable lexical subs|;
}

sub test_switch_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; sub { given (0) {} }|;
    is $@, '', qq|use Modern::Perl $year enables switch|;
}

sub test_say_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; sub { say 0 }|;
    is $@, '', qq|use Modern::Perl $year enables say|;
}

sub test_state_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; state \$x;|;
    is $@, '', qq|use Modern::Perl $year enables state|;
}

sub test_cur_sub_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; sub { return __SUB__ }|;
    is $@, '', qq|use Modern::Perl $year enables current_sub|;
}

sub test_array_base_for {
    my $year = _get_year(shift);

    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };

    if (eval qq|use Modern::Perl $year; \$[ = 10|) {
        like $warning, qr/Use of assignment to \$\[ is deprecated/,
            qq|use Modern::Perl $year disables array_base|;
    }
    else {
        like $@, qr/Assigning non-zero to \$\[ is no longer possible/,
            qq|use Modern::Perl $year works without array_base|;
    }
}

sub test_fc_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; fc("tschüß") eq fc("TSCHÜSS")|;
    is $@, '', qq|use Modern::Perl $year enables fc|;
}

sub test_postderef_for {
    my $year = _get_year(shift);

    eval qq|use Modern::Perl $year; my \$r = [ 1, [ 2, 3 ], 4 ]; \$r->[1]->@*|;
    is $@, '', qq|use Modern::Perl $year enables postderef_qq|;
}

sub test_unicode_strings_for {
    my $year = _get_year(shift);

    eval qq{
        use Modern::Perl $year;
        is uc "\xdf", "SS", q|$year enables unicode_strings|;
    };
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

{
    my $warning = '';
    local $SIG{__WARN__} = sub { $warning = shift };
    eval 'fc("tschüß") eq fc("TSCHÜSS")';
    isnt $@, '', q|use Modern::Perl () does not enable fc|;
}

{
    use Modern::Perl '2009';

    test_switch_for( '2009' );
    test_say_for(    '2009' );
    test_state_for(  '2009' );

    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

{
    use Modern::Perl '2010';

    test_switch_for( '2010' );
    test_say_for(    '2010' );
    test_state_for(  '2010' );

    is uc "\xdf", "\xdf", 'but not unicode_strings';
}

if ($] >= 5.012)
{
    my $year = 2011;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.014)
{
    my $year = 2012;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.016)
{
    my $year = 2013;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.018)
{
    my $year = 2014;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.020)
{
    my $year = 2015;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.024)
{
    my $year = 2016;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_postderef_for(       $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.024)
{
    my $year = 2017;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_postderef_for(       $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.026)
{
    my $year = 2018;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_postderef_for(       $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.028)
{
    my $year = 2019;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_postderef_for(       $year );
    test_unicode_strings_for( $year );
}

if ($] >= 5.030)
{
    my $year = 2020;

    test_switch_for(          $year );
    test_say_for(             $year );
    test_state_for(           $year );
    test_cur_sub_for(         $year );
    test_array_base_for(      $year );
    test_lexical_subs_for(    $year );
    test_fc_for(              $year );
    test_postderef_for(       $year );
    test_unicode_strings_for( $year );
}

eval 'sub { given (0) {} }';
isnt $@, "", 'switch feature does not leak out';
eval 'sub { say 0 }';
isnt $@, '', 'say feature does not leak out';
eval 'state $x';
isnt $@, '', 'state feature does not leak out';
is uc "\xdf", "\xdf", 'unicode_strings feature does not leak out';

done_testing;
