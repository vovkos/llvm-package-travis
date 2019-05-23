#
# the goal of this patch is to erase this line:
#
# 	(void)flow; /* Remove this workaround after PR17897 is fixed */
#
# otherwise, Debug builds with Clang stop with 'undefined reference'
#

use strict;

my $fileName = $ARGV [0] || die ("Usage: yaml-patch.pl <YAMLTraits.h>\n");
open (my $file, "<", $fileName) || die ("Can't open $fileName for reading: $!\n");

my @body;

while (my $s = <$file>)
{
	if ($s !~ m/PR17897/)
	{
		push (@body, $s);
	}
}

open (my $file, ">", $fileName) || die ("Can't open $fileName for writing: $!\n");
print $file (@body);
