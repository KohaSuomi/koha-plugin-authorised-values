package Koha::Plugin::Fi::KohaSuomi::AuthorisedValuesEndpoints::AuthValueController;

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use Modern::Perl;
use Mojo::Base 'Mojolicious::Controller';
use C4::Context;
use Try::Tiny;
use Koha::AuthorisedValues;

# my $CONFPATH = dirname($ENV{'KOHA_CONF'});
# my $KOHAPATH = C4::Context->config('intranetdir');

# # Initialize Logger
# my $log_conf = $CONFPATH . "/log4perl.conf";
# Log::Log4perl::init($log_conf);
# my $log = Log::Log4perl->get_logger('reports');

#This gets called from REST api

sub list {

    my $c = shift->openapi->valid_input or return;

    return try {

        my $avs = C4::Koha::GetAuthorisedValues();

        return $c->render( status => 200, openapi => $avs );

    }

    catch {

        $c->unhandled_exception($_);
    };
}

sub get {

    my $c = shift->openapi->valid_input or return;

    return try {

        my $av = Koha::AuthorisedValues->find( $c->validation->param('authorised_value_id') );

        unless ($av) {

            return $c->render( status  => 404,

                            openapi => { error => "Authorised value not found" } );

        }

        return $c->render( status => 200, openapi => $av->to_api );

    }

    catch {
        $c->unhandled_exception($_);
    }
}

sub listByCategory {
    
     my $c = shift->openapi->valid_input or return;

    return try {

        my $avs = Koha::AuthorisedValues->search( { category => $c->validation->param('authorised_value_category') } );

        unless ($avs) {

            return $c->render( status  => 404,

                            openapi => { error => "Authorised value category not found" } );

        }

        return $c->render( status => 200, openapi => $avs->to_api );

    }

    catch {
        $c->unhandled_exception($_);
    }  
}

1;