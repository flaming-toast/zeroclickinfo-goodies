package DDG::Goodie::IsValid::JSON;
# ABSTRACT: Check whether the submitted data is valid JSON.

use DDG::Goodie;

use Try::Tiny;
use JSON qw(from_json);

attribution github  => ['https://github.com/AlexBio', 'AlexBio'  ],
            web     => ['http://ghedini.me', 'Alessandro Ghedini'];

zci answer_type => 'isvalid';
zci is_cached   => 1;

triggers any => 'json';

handle remainder => sub {
	return unless s/ ?(is )?valid\?? ?//gi;

	my ($result, $error) = try {
		from_json $_;
		return 'valid!';
	} catch {
		$_ =~ /^(.* at character offset \d+ .*) at/;
		return ('invalid: ', $1);
	};

	my $answer      = "Your JSON is $result";
	my $answer_html = $answer;

	$answer      .= $error if $error;
	$answer_html .= "<pre style=\"font-size:12px;"
                 .  "margin-top:5px;\">$error</pre>" if $error;

	return $answer, html => $answer_html
};

1;
