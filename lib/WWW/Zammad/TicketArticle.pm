package WWW::Zammad::TicketArticle;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'ticket_articles'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::Get';
with 'WWW::Zammad::Role::Create';

sub by_ticket {
    my ($self, $ticket_id) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(
        join('/', $self->url, 'by_ticket', $ticket_id),
        {expand => 'true'},
        $self->default_headers
    );
    $self->_maybe_get_json($res, 200);
}

1;

