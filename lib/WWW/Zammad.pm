package WWW::Zammad;

use strict;
use warnings;

our $VERSION = '0.01';

use Class::Load qw(try_load_class);
use MIME::Base64 qw(encode_base64);
use Carp;
use WWW::Zammad::Resource;
use Moo;
use namespace::clean;

has url          => (is => 'ro', required  => 1);
has username     => (is => 'ro', predicate => 1);
has password     => (is => 'ro', predicate => 1);
has http_token   => (is => 'ro', predicate => 1);
has oauth2_token => (is => 'ro', predicate => 1);
has on_behalf_of => (is => 'ro', predicate => 1);
has transport_class => (is => 'lazy');
has transport       => (is => 'lazy',);
has default_headers => (is => 'lazy');

sub _build_default_headers {
    my ($self) = @_;
    my $headers
        = {'User-Agent' => ref($self), 'Content-Type' => 'application/json',};
    $headers->{'X-On-Behalf-Of'} = $self->on_behalf_of
        if $self->has_on_behalf_of;
    $headers;
}

sub _build_transport_class {
    'HTTP::Tiny';
}

sub _build_transport {
    my ($self) = @_;
    my $class = 'WWW::Zammad::Transport::' . $self->transport_class;
    try_load_class($class) or croak("Could not load $class: $!");
    $class->new;
}

sub _set_authorization_header {
    my ($self) = @_;
    my $auth_header;
    if ($self->has_http_token) {
        $auth_header = 'Token token=' . $self->http_token;
    }
    elsif ($self->has_oauth2_token) {
        $auth_header = 'Bearer ' . $self->oauth2_token;
    }
    elsif (!$self->has_username) {
        croak "username is required";
    }
    elsif (!$self->has_password) {
        croak "password is required";
    }
    else {
        $auth_header = 'Basic '
            . encode_base64(join(':', $self->username, $self->password), '');
    }
    $self->default_headers->{'Authorization'} = $auth_header;
}

sub BUILD {
    my ($self) = @_;
    $self->_set_authorization_header;
}

sub group {
    my ($self) = @_;
    WWW::Zammad::Resource->new(resource => 'groups', client => $self);
}

sub object {
    my ($self) = @_;
    WWW::Zammad::Resource->new(
        resource => 'object_manager_attributes',
        client   => $self
    );
}

sub online_notification {
    my ($self) = @_;
    WWW::Zammad::Resource->new(
        resource => 'online_notifications',
        client   => $self
    );
}

sub tag_list {
    my ($self) = @_;
    WWW::Zammad::Resource->new(resource => 'tag_list', client => $self);
}

sub ticket {
    my ($self) = @_;
    WWW::Zammad::Resource->new(resource => 'tickets', client => $self);
}

sub ticket_article {
    my ($self) = @_;
    WWW::Zammad::Resource->new(
        resource => 'ticket_articles',
        client   => $self
    );
}

sub ticket_attachment {
    my ($self) = @_;
    WWW::Zammad::Resource->new(
        resource => 'ticket_attachment',
        client   => $self
    );
}

sub ticket_priority {
    my ($self) = @_;
    WWW::Zammad::Resource->new(
        resource => 'ticket_priorities',
        client   => $self
    );
}

sub ticket_states {
    my ($self) = @_;
    WWW::Zammad::Resource->new(resource => 'ticket_states', client => $self);
}

sub users {
    my ($self) = @_;
    WWW::Zammad::Resource->new(resource => 'users', client => $self);
}

1;

__END__

=pod

=head1 NAME

WWW::Zammad - A client for the Zammad API

=head1 AUTHOR

Nicolas Steenlant, C<< <nicolas.steenlant at ugent.be> >>

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
