
use Test::More tests => 6;

BEGIN {
	use_ok('Filter::BoxString', 'use Filter::BoxString')
};

my $basic_box
    = "     \n"
    . " xxx \n"
    . " xxx \n"
    . " xxx \n"
    . "     \n";

my $trimmed_box
    = "\n"
    . " xxx\n"
    . " xxx\n"
    . " xxx\n"
    . "\n";

my $metachar_box
    = "                \n"
    . " {}[]()^\$.|*+?\\ \n"
    . "                \n";

my $hackers_box
    = "       \n"
    . "TEXTBOX\n"
    . "       \n";

my $nested_box
    = "             \n"
    . " \$a = +---+  \n"
    . "      | X |  \n"
    . "      +---+; \n"
    . "             \n";

is(
    eval {

       $b = +-----+
            |     |
            | xxx |
            | xxx |
            | xxx |
            |     |
            +-----+;
    },
    $basic_box,
    'correct basic box'
);

is(
    eval {

        $b = +
             |
             | xxx
             | xxx
             | xxx
             |
             +;
    },
    $trimmed_box,
    'correct trimmed box'
);

is(
    eval {

        $b = +----------------+
             |                |
             | {}[]()^\$\.|*+?\\ |
             |                |
             +----------------+;
    },
    $metachar_box,
    'correct metacharacter box'
);

is(
    eval {

        $b = +-------+
             |       |
             |TEXTBOX|
             |       |
             +-------+;
    },
    $hackers_box,
    "correct hacker's box"
);

is(
    eval {

        $b = +-------------+
             |             |
             | \$a = +---+  |
             |      | X |  |
             |      +---+; |
             |             |
             +-------------+;
    },
    $nested_box,
    "correct nested box"
);

