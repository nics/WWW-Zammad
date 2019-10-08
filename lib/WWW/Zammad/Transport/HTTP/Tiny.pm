package WWW::Zammad::Transport::HTTP::Tiny;

use strict;
use warnings;

our $VERSION = '0.01';

use HTTP::Tiny;
use Moo;
use namespace::clean;

with 'WWW::Zammad::Role::Transport';

has _client =>
    (is => 'ro', init_arg => 0, lazy => 1, builder => '_build_client',);

sub _build_client {
    HTTP::Tiny->new;
}

sub get {
    my ($self, $url, $params, $headers) = @_;
    $url = $self->_url_with_params($url, $params);
    my $res = $self->_client->get($url, {headers => $headers});
    [$res->{status}, $res->{headers}, $res->{content}];
}

sub post {
    my ($self, $url, $body, $headers) = @_;
    my $res
        = $self->_client->post($url, {content => $body, headers => $headers});
    [$res->{status}, $res->{headers}, $res->{content}];
}

sub put {
    my ($self, $url, $body, $headers) = @_;
    my $res
        = $self->_client->put($url, {content => $body, headers => $headers});
    [$res->{status}, $res->{headers}, $res->{content}];
}

sub delete {
    my ($self, $url, $params, $headers) = @_;
    $url = $self->_url_with_params($url, $params);
    my $res = $self->_client->get($url, {headers => $headers});
    [$res->{status}, $res->{headers}, $res->{content}];
}

sub _url_with_params {
    my ($self, $url, $params) = @_;
    if ($params) {
        my $str = $self->_client->www_form_urlencode($params);
        return "$url?$str" if length($str);
    }
    $url;
}

1;
