package WebService::PivotalTracker;
use 5.008005;
use Mouse;

our $VERSION = "0.01";

use Furl;
use Carp ();
use JSON qw(decode_json encode_json);

my $api_base_uri = 'https://www.pivotaltracker.com/services/v5/';

has 'token' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

# TODO: support object response
# has 'use_raw_response' => (
#     is      => 'ro',
#     isa     => 'Bool',
#     default => 1,
# );

has 'timeout' => (
    is      => 'ro',
    isa     => 'Int',
    default => 10,
);

has 'api_base_uri' => (
    is      => 'ro',
    isa     => 'Str',
    default => $api_base_uri,
);

has 'ua' => (
    is       => 'ro',
    isa      => 'Furl',
    lazy     => 1,
    required => 1,
    default  => sub {
        my ($self) = @_;
        Furl->new( timeout => $self->timeout );
    },
);

no Mouse;

sub _request {
    my ($self, $method, $end_point, $data_json, @additional_header) = @_;

    my $ua = $self->ua;
    my $uri = $self->api_base_uri . $end_point;
    my $req = Furl::Request->new($method, $uri, ['X-TrackerToken' => $self->token, @additional_header], $data_json);
    my $res = $ua->request($req);
    unless ( $res->is_success ) {
        Carp::croak $res->status_line;
    }
    return if ( $res->code eq '204' );# No Content
    return decode_json($res->content);
}

sub get {
    my ($self, $end_point) = @_;
    return $self->_request('GET', $end_point);
}

sub post {
    my ($self, $end_point, $data_href) = @_;
    my $data_json = encode_json($data_href);
    my @additional_header = ( 'Content-Type' => 'application/json' );
    return $self->_request('POST', $end_point, $data_json, @additional_header);
}

sub delete {
    my ($self, $end_point) = @_;
    return $self->_request('DELETE', $end_point);
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::PivotalTracker - Web API client for PivotalTracker

=head1 SYNOPSIS

    use WebService::PivotalTracker;
    my $pivotal = WebService::PivotalTracker->new( token => ... );
    my $project_id = ...;
    my $story_id   = ...;
    my $response = $pivotal->get("/projects/$project_id/stories/$story_id");


=head1 DESCRIPTION

WebService::PivotalTracker is API client for Pivotal Tracker.

=head1 METHODS

=head2 C<$class->new( token => 'your api token' )>

create instance

=head2 C<$self->get($end_point)>

call API using GET request

=head2 C<$self->post($end_point, $data_href)>

call API using POST request

=head2 C<$self->delete($end_point)>

call API using DELETE request


=head1 SEE ALSO

L<http://www.pivotaltracker.com/help/api/rest/v5>, L<http://search.cpan.org/dist/WWW-PivotalTracker/>

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

