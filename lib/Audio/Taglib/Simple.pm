use v6;

use NativeCall;

my class X::InvalidAudioFile is Exception {
	has $.file;
	has $.text;
	method message() {
		"Failed to parse file $.file: $.text"
	}
}

class Audio::Taglib::Simple {
	has $.file is readonly;
	has $.taglib-file is readonly;
	has $!taglib-tag;
	has $!taglib-audio;

	has Str $.title is readonly;
	has Str $.artist is readonly;
	has Str $.album is readonly;
	has Str $.comment is readonly;
	has Str $.genre is readonly;
	has Int $.year is readonly;
	has Int $.track is readonly;
	has Duration $.length is readonly;
	has Int $.bitrate is readonly;
	has Int $.samplerate is readonly;
	has Int $.channels is readonly;

	#= Open the provided file to read its tags.
	method new(Str $file) {
		unless $file.path ~~ :e {
			X::InvalidAudioFile.new(
				file => $file,
				text => 'File does not exist',
			).throw;
		}
		self.bless(:$file);
	}

	submethod BUILD(:$file) {
		$!taglib-file = taglib_file_new($file);
		unless $!taglib-file {
			X::InvalidAudioFile.new(
				file => $file,
				text => 'File not recognized or parseable by TagLib',
			).throw;
		}

		# set up stuff that taglib cares about
		$!taglib-tag = taglib_file_tag($!taglib-file);
		$!taglib-audio = taglib_file_audioproperties($!taglib-file);

		# load tags
		$!title = taglib_tag_title($!taglib-tag);
		$!artist = taglib_tag_artist($!taglib-tag);
		$!album = taglib_tag_album($!taglib-tag);
		$!comment = taglib_tag_comment($!taglib-tag);
		$!genre = taglib_tag_genre($!taglib-tag);
		$!year = taglib_tag_year($!taglib-tag);
		$!track = taglib_tag_track($!taglib-tag);
		$!length = Duration.new(taglib_audioproperties_length($!taglib-audio));
		$!bitrate = taglib_audioproperties_bitrate($!taglib-audio);
		$!samplerate = taglib_audioproperties_samplerate($!taglib-audio);
		$!channels = taglib_audioproperties_channels($!taglib-audio);
	}

	method set-title(Str $in) {
		taglib_tag_set_title($!taglib-tag, $in);
		$!title = $in;
	}

	method set-artist(Str $in) {
		taglib_tag_set_artist($!taglib-tag, $in);
		$!artist = $in;
	}

	method set-album(Str $in) {
		taglib_tag_set_album($!taglib-tag, $in);
		$!album = $in;
	}

	method set-comment(Str $in) {
		taglib_tag_set_comment($!taglib-tag, $in);
		$!comment = $in;
	}

	method set-genre(Str $in) {
		taglib_tag_set_genre($!taglib-tag, $in);
		$!genre = $in;
	}

	method set-year(Int $in) {
		taglib_tag_set_year($!taglib-tag, $in);
		$!year = $in;
	}

	method set-track(Int $in) {
		taglib_tag_set_track($!taglib-tag, $in);
		$!track = $in;
	}

	method save() returns Bool {
		return Bool(taglib_file_save($!taglib-file));
	}

	# Routines we use automatically for the actual API calls
	sub taglib_file_new(Str) returns OpaquePointer is native('libtag_c') {...};

	# XXX use this someday when we can represent the enum of the types
	#sub taglib_file_new_type(Str, Enum) returns OpaquePointer is native('libtag_c') {...};
	sub taglib_file_tag(OpaquePointer) returns OpaquePointer is native('libtag_c') {...};
	sub taglib_file_audioproperties(OpaquePointer) returns OpaquePointer is native('libtag_c') {...};

	# Tag APIs
	sub taglib_tag_title(OpaquePointer) returns Str is native('libtag_c') {...};
	sub taglib_tag_artist(OpaquePointer) returns Str is native('libtag_c') {...};
	sub taglib_tag_album(OpaquePointer) returns Str is native('libtag_c') {...};
	sub taglib_tag_comment(OpaquePointer) returns Str is native('libtag_c') {...};
	sub taglib_tag_genre(OpaquePointer) returns Str is native('libtag_c') {...};
	sub taglib_tag_year(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_tag_track(OpaquePointer) returns Int is native('libtag_c') {...};

	# Tag manipulation APIs
	sub taglib_file_save(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_tag_set_title(OpaquePointer, Str) is native('libtag_c') {...};
	sub taglib_tag_set_artist(OpaquePointer, Str) is native('libtag_c') {...};
	sub taglib_tag_set_album(OpaquePointer, Str) is native('libtag_c') {...};
	sub taglib_tag_set_comment(OpaquePointer, Str) is native('libtag_c') {...};
	sub taglib_tag_set_genre(OpaquePointer, Str) is native('libtag_c') {...};
	sub taglib_tag_set_year(OpaquePointer, Int) is native('libtag_c') {...};
	sub taglib_tag_set_track(OpaquePointer, Int) is native('libtag_c') {...};

	# Audio Properties APIs
	sub taglib_audioproperties_length(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_bitrate(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_samplerate(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_channels(OpaquePointer) returns Int is native('libtag_c') {...};
}


# vim: ft=perl6
