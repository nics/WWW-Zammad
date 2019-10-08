package WWW::Zammad::Resource::TicketArticle;

use strict;
use warnings;
use Moo;
use namespace::clean;

extends 'WWW::Zammad::Resource';

sub by_ticket {
    my ($self, $ticket_id) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(join('/', $self->url, 'by_ticket', $ticket_id), {expand => 'true'}, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

