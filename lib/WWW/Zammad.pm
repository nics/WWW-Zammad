package WWW::Zammad;

use strict;
use warnings;

our $VERSION = '0.01';

use Class::Load qw(try_load_class);
use MIME::Base64 qw(encode_base64);
use Carp;
use WWW::Zammad::Group;
use WWW::Zammad::Object;
use WWW::Zammad::OnlineNotification;
use WWW::Zammad::Organization;
use WWW::Zammad::Tag;
use WWW::Zammad::Ticket;
use WWW::Zammad::TicketArticle;
use WWW::Zammad::TicketAttachment;
use WWW::Zammad::TicketPriority;
use WWW::Zammad::TicketState;
use WWW::Zammad::User;
use WWW::Zammad::UserAccessToken;
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

sub organization {
    my ($self) = @_;
    WWW::Zammad::Organization->new(client => $self);
}

sub group {
    my ($self) = @_;
    WWW::Zammad::Group->new(client => $self);
}

sub object {
    my ($self) = @_;
    WWW::Zammad::Object->new(client => $self);
}

sub online_notification {
    my ($self) = @_;
    WWW::Zammad::Resource::OnlineNotification->new(client => $self);
}

sub tag {
    my ($self) = @_;
    WWW::Zammad::Tag->new(client => $self);
}

sub ticket {
    my ($self) = @_;
    WWW::Zammad::Ticket->new(client => $self);
}

sub ticket_article {
    my ($self) = @_;
    WWW::Zammad::Resource::TicketArticle->new(client => $self);
}

sub ticket_attachment {
    my ($self) = @_;
    WWW::Zammad::Resource::TicketAttachment->new(client => $self);
}

sub ticket_priority {
    my ($self) = @_;
    WWW::Zammad::Resource::TicketPriority->new(client => $self);
}

sub ticket_state {
    my ($self) = @_;
    WWW::Zammad::TicketState->new(client => $self);
}

sub user {
    my ($self) = @_;
    WWW::Zammad::User->new(client => $self);
}

sub user_access_token {
    my ($self) = @_;
    WWW::Zammad::UserAccessToken->new(client => $self);
}

1;

__END__

=pod

=head1 NAME

WWW::Zammad - A client for the Zammad API

=head1 OVERVIEW

    user                all search get create update delete me
    organization        all search get create update delete
    group               all        get create update delete
    object              all        get create update        migrate
    online_notification all        get        update delete mark_as_read
    tag                 all search     create update delete
    ticket              all search get create update delete tags,add_tag,remove_tag
    ticket_article                 get create               by_ticket
    ticket_attachment                                       download
    ticket_priority     all        get create update delete
    ticket_state        all        get create update delete
    user_access_token   all            create        delete

=head1 AUTHOR

Nicolas Steenlant, C<< <nicolas.steenlant at ugent.be> >>

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

