#!/usr/bin/perl

open (IN, $ARGV[0]);

my @genes; 

while (<IN>)
{
	push @genes, (split/\n/);
}

close IN;

my $genelist = join('|', @genes);

## Physical
## Direct

my @phys;

open (IN2, "<", "physical.tsv");

while (<IN2>)
{
	push @phys, [split/\t/];
}

close IN2;

open (OUT1, ">", "$ARGV[0]_Interactors.txt");
open (OUT2, ">", "$ARGV[0]_Total_Network.txt");
open (OUT3, ">", "$ARGV[0]_Attributes.txt");
open (OUT4, ">", "$ARGV[0]_Direct_Network.txt");

print OUT1 "Physical Interactions:\nDirect Interactions:\nGene #1\tGene #2\n";
print OUT2 "source\ttarget\tinteraction\n";
print OUT3 "node_id\tnode_type\n";
print OUT4 "source\ttarget\tinteraction\n";

for (my $i = 0; $i < scalar @phys; $i++)
{
	if ($phys[$i][0] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($phys[$i][1] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/) 
		{
			if ($phys[$i][0] !~ /$phys[$i][1]/) 
			{
				print OUT1 "$phys[$i][0]\t$phys[$i][1]\n";
				print OUT2 "$phys[$i][0]\t$phys[$i][1]\tpp\n";
				print OUT3 "$phys[$i][0]\tsource\n$phys[$i][1]\tsource\n";
				print OUT4 "$phys[$i][0]\t$phys[$i][1]\tpp\n";				
			}
		}
	}
}

print OUT1 "\n\n";


## Physical
## Shared


my @allphys;

for (my $i = 0; $i < scalar @phys; $i++)
{
	if ($phys[$i][0] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($phys[$i][1] !~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
		{
			push @allphys, [$phys[$i][0],$phys[$i][1]];
		}
	}
	elsif ($phys[$i][1] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($phys[$i][0] !~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
		{
			push @allphys, [$phys[$i][1],$phys[$i][0]];
		}
	}
}

print OUT1 "Physical Interactions:\nShared Interactions:\nShared Interactor\tInput Genes\n";

my %results = ();

for (my $k = 0; $k < scalar @allphys; $k++)
{
	$results{$allphys[$k][1]} .= "$allphys[$k][0]\t";
}

my @p2;

for my $key ( keys %results ) 
{
	my $value = $results{$key};
	if ($value =~ /\t\S+\t/) 
	{
		print OUT1 "$key\t$value\n";
		push @p2, $key;
	}
}

print OUT1 "\n\n";

my $sharedlist = join('|', @p2);

for (my $i = 0; $i < scalar @allphys; $i++)
{
	if ($allphys[$i][1] =~ /(?<![\w\d:])($sharedlist)(?![\w\d:])/)
	{
		print OUT2 "$allphys[$i][1]\t$allphys[$i][0]\tpp\n";
		print OUT3 "$allphys[$i][0]\tsource\n";
		print OUT3 "$allphys[$i][1]\ttarget\n";
	}
}


## Genetics
## Direct


my @genet;

open (IN3, "<", "genetic.tsv");

while (<IN3>)
{
	push @genet, [split/\t/];
}

close IN3;

print OUT1 "Genetic Interactions:\nDirect Interactions:\nGene #1\tGene #2\n";
for (my $i = 0; $i < scalar @genet; $i++)
{
	if ($genet[$i][0] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($genet[$i][1] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/) 
		{
			if ($genet[$i][0] !~ /\|/){
				if ($genet[$i][1] !~ /\|/){
					print OUT1 "$genet[$i][0]\t$genet[$i][1]\n";
					print OUT2 "$genet[$i][0]\t$genet[$i][1]\tgi\n";
					print OUT3 "$genet[$i][0]\tsource\n$genet[$i][1]\tsource\n";
					print OUT4 "$genet[$i][0]\t$genet[$i][1]\tgi\n";
				}
			}
		}
	}
}

print OUT1 "\n\n";


## Genetics
## Shared


print OUT1 "Genetic Interactions:\nShared Interactions:\nShared Interactor\tInput Genes\n";

my @allgenet; my @allgenet1;

for (my $l = 0; $l < scalar @genet; $l++)
{
	if ($genet[$l][0] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($genet[$l][1] !~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
		{
			if ($genet[$l][0] !~ /\|/)
			{
				if ($genet[$l][1] !~ /\|/)
				{
					push @allgenet1, [$genet[$l][0],$genet[$l][1]];
				}	
			}	
		}
	}
	elsif ($genet[$l][1] =~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
	{
		if ($genet[$l][0] !~ /(?<![\w\d:])($genelist)(?![\w\d:])/)
		{
			if ($genet[$l][1] !~ /\|/)
			{
				if ($genet[$l][0] !~ /\|/)
				{
					push @allgenet1, [$genet[$l][1],$genet[$l][0]];
				}
			}
		}
	}
	
}

my @allgenet2 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] } @allgenet1;

for (my $p = 0; $p < scalar @allgenet2; $p++)
{
	if ($allgenet2[$p][0] =~ /$allgenet2[$p-1][0]/)
	{
		if ($allgenet2[$p][1] =~ /$allgenet2[$p-1][1]/) 
		{
			next;
		}
		else 
		{
			push @allgenet, [$allgenet2[$p][0],$allgenet2[$p][1]];
		}
	}
	else 
	{
		push @allgenet, [$allgenet2[$p][0],$allgenet2[$p][1]];
	}
}

my %gresults = ();

for (my $n = 0; $n < scalar @allgenet; $n++)
{
	$gresults{$allgenet[$n][1]} .= "$allgenet[$n][0]\t";
}

my @g2;

for my $gkey ( keys %gresults ) 
{
	my $gvalue = $gresults{$gkey};
	if ($gvalue =~ /\t\S+\t/) 
	{
		if ($gvalue !~ /\|/)
		{
			if ($gkey !~ /\|/)
			{
				print OUT1 "$gkey\t$gvalue\n";
				push @g2, $gkey;
			}
		}
	}
}


my $sharedglist = "|". join('|', @g2)."|";

for (my $i = 0; $i < scalar @allgenet; $i++)
{
	if ($allgenet[$i][1] =~ /(?<![\w\d:])($sharedglist)(?![\w\d:])/)
	{
		print OUT2 "$allgenet[$i][1]\t$allgenet[$i][0]\tgi\n";
		print OUT3 "$allgenet[$i][0]\tsource\n";
		print OUT3 "$allgenet[$i][1]\ttarget\n";
	}
}


close OUT1;
close OUT2;
close OUT3;
close OUT4;
