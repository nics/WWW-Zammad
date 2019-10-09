# NAME

WWW::Zammad - A client for the Zammad API

# SYNOPSIS

    my $zammad = WWW::Zammad->new(
        url      => $zammad_url,
        username => $zammad_username,
        password => $zammad_password,
    );

    my $hits = $zammad->user->search({query => "email:$email"});

    my $ticket = $zammad->ticket->create({...});
    if (my $err = $zammad->ticket->last_error) {
        ...
    }

# OVERVIEW

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

# AUTHOR

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

# LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
