package WWW::Zammad::Role::Log;

use strict;
use warnings;
use Log::Any ();
use Moo::Role;
use namespace::clean;

has log => (is => 'lazy',);

sub _build_log {
    Log::Any->get_logger;
}

1;

