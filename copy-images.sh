#!/bin/bash

rsync -ravp --progress /tmp/kexec-assets/ helium:/srv/www/hackterm/
rsync -avp --progress run.sh helium:/srv/www/hackterm.sh
