package WWW::Zammad::Role::Transport;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

with 'WWW::Zammad::Role::Log';

for my $method (qw(get post put delete)) {
    requires $method;

    around $method => sub {
        my $orig = shift;
        my $self = shift;
        if ($self->log->is_debug) {
            $self->log->debugf("$method request: %s", \@_);
        }
        my $res = $orig->($self, @_);
        if ($self->log->is_debug) {
            $self->log->debugf("$method response: %s", $res);
        }
        $res;
    };
}

1;
