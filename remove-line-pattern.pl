use strict;

my $pattern = $ARGV[0];
my $fileName = $ARGV[1];

$pattern || $fileName || die("Usage: remove-line-pattern.pl <pattern> <file>\n");

open(my $file, "<", $fileName) || die("Can't open $fileName for reading: $!\n");

my @body;

while (my $s = <$file>)
{
	if ($s !~ m/$pattern/)
	{
		push(@body, $s);
	}
}

open(my $file, ">", $fileName) || die("Can't open $fileName for writing: $!\n");
print $file(@body);
