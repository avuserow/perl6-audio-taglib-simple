use v6;

use Test;
use Audio::Taglib::Simple;

# copy the example file
IO::Path.new('t/silence.ogg').copy('t/edited.ogg');

my $tl = Audio::Taglib::Simple.new('t/edited.ogg');
is $tl.length, 30, 'sanity check: length after copy';

my %edits = (
	title => 'new title',
	artist => 'new artist',
	album => 'new album',
	comment => "new comment, time is { now }",
	genre => 'Other',
	year => 1999,
	track => 244,
);

for %edits.kv -> $key, $val {
	$tl."set-$key"($val);
	is $tl."$key"(), $val, "$key was updated in memory";
}

ok $tl.save(), 'file saved';

# check the edits
$tl = Audio::Taglib::Simple.new('t/edited.ogg');
for %edits.kv -> $key, $val {
	is $tl."$key"(), $val, "$key was updated on disk";
}

done;
