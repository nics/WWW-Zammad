package WWW::Zammad::TicketAttachment;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'ticket_attachment'}

with 'WWW::Zammad::Role::Resource';

sub download {
    my ($self, $ticket_id, $article_id, $id) = @_;
    my $res
        = $self->transport->get(
        join('/', $self->url, $ticket_id, $article_id, $id),
        {}, $self->default_headers,);
    $self->_maybe_get_json($res, 200);
}

1;

