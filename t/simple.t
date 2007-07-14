
use Test::More tests => 23;
use E'Mail::Acme;#'

my $email = E'Mail::Acme;#'

isa_ok($email, "E'Mail::Acme");

$email->{Received} = [
  q/from sir-mx-a-lot.example.com by salt-n-pep-l.perl4.museum; Thu, 12 Jul 2007 02:09:46 -0400 (EDT)/,
  q/from mr-bad.example.com by sir-mx-a-lot.example.com; Thu, 12 Jul 2007 01:01:13 -0400 (EDT)/,
];

$email->{From}     = q<rjbs@example.com>;
$email->{To}       = q'The PEP (Perl Email Project) List <pep-l@perl.xxx>';

push @$email,
  "Dear PEP Suckers,",
  "",
  "Somebody should write a SIMPLE Email::Simple replacement.",
  "",
  "In fact, someone has.  Me!  SO LONG, SUCKERS!",
  "",
  "-- ",
  "rjbs"
;

splice @$email, 7, 0, "your former leader";

$email->[8] = "ricardo\nsignes";

my $expected_header = <<'END_STRING';
Received: from sir-mx-a-lot.example.com by salt-n-pep-l.perl4.museum; Thu, 12 Jul 2007 02:09:46 -0400 (EDT)
Received: from mr-bad.example.com by sir-mx-a-lot.example.com; Thu, 12 Jul 2007 01:01:13 -0400 (EDT)
From: rjbs@example.com
To: The PEP (Perl Email Project) List <pep-l@perl.xxx>
END_STRING

my $expected_body = <<'END_STRING';
Dear PEP Suckers,

Somebody should write a SIMPLE Email::Simple replacement.

In fact, someone has.  Me!  SO LONG, SUCKERS!

-- 
your former leader
ricardo
signes
END_STRING

$expected_header =~ s/\n/\x0d\x0a/g;
$expected_body   =~ s/\n/\x0d\x0a/g;

my $expected = "$expected_header\x0d\x0a$expected_body";

is(
  "" . $email,
  $expected,
  "message stringifies properly",
);

is(
  $email->{''},
  $expected_header,
);

{
  my $email = E'Mail::Acme;#'
  
  $email->{From} = q(sadist@marquis.sad);

  my $field = $email->{From};
  
  is($field, 'From: sadist@marquis.sad' . "\x0d\x0a", "header stringifies");

  is(
    $field->[0],
    'sadist@marquis.sad',
    "0th field value is correct",
  );

  is(
    $field->[1],
    undef,
    "1st value is undef",
  );

  is(
    $field->[2],
    undef,
    "2nd value is undef",
  );

  $field->[1] = 'pantaloon@dubloon.oon';

  is(
    $field->[0],
    'sadist@marquis.sad',
    "0th field value is correct",
  );

  is(
    $field->[1],
    'pantaloon@dubloon.oon',
    "1st field value is correct",
  );

  is(
    $field->[2],
    undef,
    "2nd value is undef",
  );

  splice @$field, 1, 0, "dude";

  is(
    $field->[0],
    'sadist@marquis.sad',
    "0th field value is correct",
  );

  is(
    $field->[1],
    'dude',
    "1st field value is correct",
  );

  is(
    $field->[2],
    'pantaloon@dubloon.oon',
    "1st field value is correct",
  );

  is(
    $field->[3],
    undef,
    "2nd value is undef",
  );

  splice @$field, 0, 1, "dude";

  is(
    $field->[0],
    'dude',
    "0th field value is correct",
  );

  is(
    $field->[1],
    'dude',
    "1st field value is correct",
  );

  is(
    $field->[2],
    'pantaloon@dubloon.oon',
    "1st field value is correct",
  );

  is(
    $field->[3],
    undef,
    "2nd value is undef",
  );
  
  @$email = "Hey, dude.\nWhat's up?";

  is_deeply(
    [ @$email ],
    [ "Hey, dude.", "What's up?" ],
    "direct assignment to lines",
  );

  push @$email, "-- \nrjbs\n";

  is_deeply(
    [ @$email ],
    [ "Hey, dude.", "What's up?", "-- ", "rjbs" ],
    "then pushed real good",
  );

  is($email->[-1], "rjbs", "last line is correct");

  # print $email "manager, e-mail enterprises";
  # is($email->[-1], "manager, e-mail enterprises", "print to push");

  is_deeply($email->[ @$email ], [], "message is single-part");

  my $part = E'Mail::Acme;#'
  $part->{'content-type'} = "text/plain";
  push @$part, "This is plain text.";

  push @$email, $part;

  is_deeply($email->[ @$email ], [ $part ], "message subparts are ok");
}

# use Data::Dumper;
# diag Dumper($email->()->('header'));
# diag Dumper("" . $email->()->('header')->{received});
# diag Dumper(scalar $email->()->('header')->{received});
# diag Dumper($email->()->('header')->{received});

