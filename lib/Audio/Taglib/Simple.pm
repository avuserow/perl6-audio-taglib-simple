use v6;

use NativeCall;

class Audio::Taglib::Simple {
	has $.file is readonly;
	has $.taglib-file is readonly;
	has $!taglib-tag;
	has $!taglib-audio;

	#= Open the provided file to read its tags.
	method new(Str $file) {
		die "File does not exist" unless $file.path ~~ :e;

		my $taglib-file = taglib_file_new($file);
		die "Invalid audio file" unless $taglib-file;
		self.bless(:$file, :$taglib-file);
	}

	method !setup-file-tag() {
		unless $!taglib-tag {
			$!taglib-tag = taglib_file_tag($.taglib-file);
		}
	}

	method title() returns Str {
		self!setup-file-tag;
		return taglib_tag_title($!taglib-tag);
	}

	method artist() returns Str {
		self!setup-file-tag;
		return taglib_tag_artist($!taglib-tag);
	}

	method album() returns Str {
		self!setup-file-tag;
		return taglib_tag_album($!taglib-tag);
	}

	method comment() returns Str {
		self!setup-file-tag;
		return taglib_tag_comment($!taglib-tag);
	}

	method genre() returns Str {
		self!setup-file-tag;
		return taglib_tag_genre($!taglib-tag);
	}

	method year() returns Int {
		self!setup-file-tag;
		return taglib_tag_year($!taglib-tag);
	}

	method track() returns Int {
		self!setup-file-tag;
		return taglib_tag_track($!taglib-tag);
	}

	method !setup-file-audio() {
		unless $!taglib-audio {
			$!taglib-audio = taglib_file_audioproperties($.taglib-file);
		}
	}

	method length() returns Duration {
		self!setup-file-audio;
		return Duration.new(taglib_audioproperties_length($!taglib-audio));
	}

	method bitrate() returns Int {
		self!setup-file-audio;
		return taglib_audioproperties_bitrate($!taglib-audio);
	}

	method samplerate() returns Int {
		self!setup-file-audio;
		return taglib_audioproperties_samplerate($!taglib-audio);
	}

	method channels() returns Int {
		self!setup-file-audio;
		return taglib_audioproperties_channels($!taglib-audio);
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

	# Audio Properties APIs
	sub taglib_audioproperties_length(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_bitrate(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_samplerate(OpaquePointer) returns Int is native('libtag_c') {...};
	sub taglib_audioproperties_channels(OpaquePointer) returns Int is native('libtag_c') {...};
}


# vim: ft=perl6
