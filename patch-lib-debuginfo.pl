use strict;

my $fileName = $ARGV [0] || die ("Usage: patch-lib-debuginfo.pl <CMakeLists.txt>\n");
open (my $file, "<", $fileName) || die ("Can't open $fileName for reading: $!\n");

my @body;

while (my $s = <$file>)
{
	if ($s =~ m/add_subdirectory\s*\((PDB|CodeView|MSF)/)
	{
		next;
	}

	push (@body, $s)
}

open (my $file, ">", $fileName) || die ("Can't open $fileName for writing: $!\n");
print $file (@body);
