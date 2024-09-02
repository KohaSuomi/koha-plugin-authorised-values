#!/bin/bash

kohaplugindir="$(grep -Po '(?<=<pluginsdir>).*?(?=</pluginsdir>)' $KOHA_CONF)"
kohadir="$(grep -Po '(?<=<intranetdir>).*?(?=</intranetdir>)' $KOHA_CONF)"

rm -r $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints
rm $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints.pm

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "$SCRIPT_DIR/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints" $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints
ln -s "$SCRIPT_DIR/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints/AuthorisedValuesEndpoints.pm" $kohaplugindir/Koha/Plugin/Fi/KohaSuomi/AuthorisedValuesEndpoints.pm
DATABASE=`xmlstarlet sel -t -v 'yazgfs/config/database' $KOHA_CONF`
HOSTNAME=`xmlstarlet sel -t -v 'yazgfs/config/hostname' $KOHA_CONF`
PORT=`xmlstarlet sel -t -v 'yazgfs/config/port' $KOHA_CONF`
USER=`xmlstarlet sel -t -v 'yazgfs/config/user' $KOHA_CONF`
PASS=`xmlstarlet sel -t -v 'yazgfs/config/pass' $KOHA_CONF`

mysql --user=$USER --password="$PASS" --port=$PORT --host=$HOST $DATABASE << END
DELETE FROM plugin_data where plugin_class = 'Koha::Plugin::Fi::KohaSuomi::AuthorisedValuesEndpoints';
DELETE FROM plugin_methods where plugin_class = 'Koha::Plugin::Fi::KohaSuomi::AuthorisedValuesEndpoints';
END

perl $kohadir/misc/devel/install_plugins.pl
