# NAME

Audio::Taglib::Simple - Read, write ID3 and other audio metadata with TagLib

# SYNOPSIS

```perl6
my $taglib = Audio::Taglib::Simple.new("awesome.mp3");
say "artist: ", $taglib.artist;

$taglib.set-artist("Awesome Band");
$taglib.save()
```

See also examples/taglib.p6

# DESCRIPTION

This module uses NativeCall to provide bindings to TagLib's C API. The C API is
the "simple" API, which only provides commonly used fields that are abstracted
over all file types.

TagLib supports many audio and tag formats. Audio formats include MP3, MPC,
FLAC, MP4, ASF, AIFF, WAV, TrueAudio, WavPack, Ogg FLAC, Ogg Vorbis, Speex and
Opus file formats. Tag formats include ID3v1, ID3v2, APE, FLAC, Xiph,
iTunes-style MP4 and WMA. See their website for an exhaustive list.

TagLib is nice and fast. The example script runs on a directory of 501 files
(499 are MP3, 2 are non-audio) in around 4 seconds.

All of the API methods are read only. Modifying a file is not yet supported.

# METHODS

## new($file)

Prepares to read the provided file. Dies if the file does not exist or if
TagLib cannot parse it. TagLib attempts to guess the file type here.

## file

Readonly accessor to the file variable passed in.

## artist

## album

## title

## comment

## genre

## year

Returns the year associated with the song as an integer (e.g. 2004) or 0 if not
present.

## track

Returns the track number of this song as an integer (e.g. 12) or 0 if not
present.

## length

Returns the length of the file as a Duration. TagLib provides it as an integer.

## bitrate

Returns the bit rate of the file as an Int in kb/s. Example: 128.

## samplerate

Returns the sample rate of the file as an Int in Hz. Example: 44100.

## channels

Returns the number of channels present in the file as an Int. Example: 2.

## set-artist(Str)

## set-album(Str)

## set-title(Str)

## set-comment(Str)

## set-genre(Str)

## set-year(Int)

## save() returns Bool

Call save after one or more set-foo mutators to write out the changes.

# CAVEATS

- TagLib prints some warnings to STDERR directly.
- All fields are read from the metadata, and corrupted files can often have
  incorrect values for length. TagLib does not actually parse the music stream
  to find this out.
- Tags are read at object initialization time. This means that if some other
  process modifies the tags on the music file, you won't see changes unless you
  create a new object.

# TODO

See [TODO](TODO).

# SEE ALSO

[TagLib website](http://taglib.github.io)

[tag\_c.h from the TagLib project](https://github.com/taglib/taglib/blob/master/bindings/c/tag_c.h)

