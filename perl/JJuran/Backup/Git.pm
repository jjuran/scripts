package JJuran::Backup::Git;

use warnings;
use strict;


my $var_git = "$ENV{HOME}/var/git";

my $mirrors = $ENV{GIT_MIRROR_DIR};

die "GIT_MIRROR_DIR not set\n"  if !defined $mirrors;

die "Mirror directory $mirrors doesn't exist\n"  if !-d $mirrors;


sub mirror_repo
{
	my ( $group, $name ) = @_;
	
	my $repo_dir = "$var_git/$group/$name";
	
	die "$repo_dir is not a Git repository\n"  if !-d "$repo_dir/.git";
	
	my $group_dir = "$mirrors/$group";
	
	my $mirror_dir = "$group_dir/$name.git";
	
	if ( !-d $mirror_dir )
	{
		mkdir $group_dir  if -d $group_dir;
		
		my @cmd = ( qw( git init --bare ), $mirror_dir );
		
		system( @cmd ) == 0 or die "Failed to git init $mirror_dir\n";
	}
	
	print "Mirroring $group/$name:\n";
	
	my @cmd =
	(
		'git',
		"--work-tree=$repo_dir",
		"--git-dir=$repo_dir/.git",
		'push',
		'--mirror',
		"$mirrors/$group/$name.git"
	);
	
	system( @cmd ) == 0 or die "git push --mirror of $group/$name failed\n";
	
	print "\n";
}

sub mirror_all
{
	my @repos = glob "$var_git/*/*/.git";
	
	foreach my $repo ( @repos )
	{
		my ( $group, $name ) = $repo =~ m{ ([^/]+) / ([^/]+) / \.git $}x or die;
		
		mirror_repo( $group, $name );
	}
}

1;

