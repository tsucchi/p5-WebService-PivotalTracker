
# NAME

WebService::PivotalTracker - Web API client for PivotalTracker

# SYNOPSIS

    use WebService::PivotalTracker;
    my $pivotal = WebService::PivotalTracker->new( token => ... );
    my $project_id = ...;
    my $story_id   = ...;
    my $response = $pivotal->get("/projects/$project_id/stories/$story_id");

# DESCRIPTION

WebService::PivotalTracker is API client for Pivotal Tracker.

# METHODS

## `$class-`new( token => 'your api token' )>

create instance

## `$self-`get($end\_point)>

call API using GET request

## `$self-`post($end\_point, $data\_href)>

call API using POST request

## `$self-`delete($end\_point)>

call API using DELETE request

# SEE ALSO

[http://www.pivotaltracker.com/help/api/rest/v5](http://www.pivotaltracker.com/help/api/rest/v5), [http://search.cpan.org/dist/WWW-PivotalTracker/](http://search.cpan.org/dist/WWW-PivotalTracker/)

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>