# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as
# `perl Filter-BoxString.t'

#########################

use Test::More tests => 8;

BEGIN {
	use_ok('Filter::BoxString')
};

TEST:
{

    my $list = eval {
        my $list = +---------------+
                | 1. Milk       |
                | 2. Eggs       |
                | 3. Apples     |
                +---------------+;
    };
    my $expected_list 
        = " 1. Milk       \n"
        . " 2. Eggs       \n"
        . " 3. Apples     \n";
    is( $list, $expected_list, 'trailing whitespace preserved' );

    my $noodles = eval {
        my $noodles = +-----------------------+
                    | Ramen
                    | Shirataki
                    | Soba
                    | Somen
                    | Udon
                    +;
    };
    my $expected_noodles
        = " Ramen\n"
        . " Shirataki\n"
        . " Soba\n"
        . " Somen\n"
        . " Udon\n";
    is( $noodles, $expected_noodles, 'trailing whitespace dropped' );


    my $xml = eval {
        my $xml = +---------------------------------------+
                |<?xml version="1.0" encoding="UTF-8"?>
                |  <item>Milk</item>
                |  <item>Eggs</item>
                |  <item>Apples</item>
                |</shopping_list>
                +---------------------------------------+;
    };
    my $expected_xml 
        = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        . "  <item>Milk</item>\n"
        . "  <item>Eggs</item>\n"
        . "  <item>Apples</item>\n"
        . "</shopping_list>\n";
    is( $xml, $expected_xml, 'xml content' );


    my $beatles = eval {
        my $beatles = +
                    | Love Me Do
                    | I wanna hold your hand
                    | Lucy In The Sky With Diamonds
                    | Penny Lane
                    +------------------------------+;
    };
    my $expected_beatles
        = " Love Me Do\n"
        . " I wanna hold your hand\n"
        . " Lucy In The Sky With Diamonds\n"
        . " Penny Lane\n";
    is( $beatles, $expected_beatles, 'trailing whitespace dropped' );


    my $sql = eval {
        my $sql = +
                | SELECT *
                | FROM the_table
                | WHERE this = 'that'
                | AND those = 'these'
                | ORDER BY things ASC
                +;
    };
    my $expected_sql
        = " SELECT *\n"
        . " FROM the_table\n"
        . " WHERE this = 'that'\n"
        . " AND those = 'these'\n"
        . " ORDER BY things ASC\n";
    is( $sql, $expected_sql, 'sql content' );


    my $metachars = eval {
        my $metachars = +------------------------------------------------------------+
                        | \\  Quote the next metacharacter
                        | ^  Match the beginning of the line
                        | .  Match any character (except newline)
                        | \$  Match the end of the line (or before newline at the end)
                        | |  Alternation
                        | () Grouping
                        | [] Character class
                        +------------------------------------------------------------+;
    };
    my $expected_metachars
        = " \\  Quote the next metacharacter\n"
        . " ^  Match the beginning of the line\n"
        . " .  Match any character (except newline)\n"
        . " \$  Match the end of the line (or before newline at the end)\n"
        . " |  Alternation\n"
        . " () Grouping\n"
        . " [] Character class\n";
    is( $metacharacters, $expected_metacharacters, 'meta character content' );


    my $gibberish = eval {
        my $gibberish = +-----------------------------------+
                        | 
                        | 
                        +-----------------------------------+;
    };
    my $expected_gibberish
        = "\n"
        . "\n";
    is( $gibberish, $expected_gibberish, 'gibberish content' );

}

