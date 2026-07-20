# setup frankenphp as a user service

### directory layout

```
..../fphp/etc/Caddyfile
..../fphp/etc/ini.d/php.ini
..../fphp/etc/envfile
..../fphp/bin/frankenphp-linux-x86_64
..../fphp/bin/server.sh
..../fphp/web/index.php
..../fphp/lib/ --> PHP_BASE module includes
..../fphp/php/ --> PHP_HOME module includes
```

### ~/.local/share/systemd/user/fphp.service

```
[Unit]
Description=FrankenPHP User Server

[Service]
Restart=on-failure
ExecStart=~/fphp/bin/server.sh
TimeoutStopSec=5s
PrivateTmp=true

[Install]
WantedBy=default.target
```

### ~/fphp/bin/server.sh

```bash
#!/bin/sh

XDIR=$(cd $(dirname $0) && pwd)
PDIR=$(cd $XDIR/.. && pwd)
XRUN=$(cd $XDIR/../run && pwd)

export PHP_INI_DIR=$PDIR/etc
export PHP_BASE=$PDIR/lib
export PHP_HOME=$PDIR/php
export PHP_INI_SCAN_DIR=$PDIR/etc/ini.d

mkdir -p $XRUN
cd $XRUN
echo "SERVER_ROOT=$PDIR/web" > $PDIR/etc/envfile
echo "DATA_ROOT=$PDIR/data" >> $PDIR/etc/envfile
echo "OUT_ROOT=$PDIR/out" >> $PDIR/etc/envfile
echo "XBIN_ROOT=$XDIR" >> $PDIR/etc/envfile

/usr/bin/env \
	HOME=$HOME \
	XDG_CONFIG_HOME=$PDIR \
	PHP_INI_DIR=$PHP_INI_DIR \
	PHP_BASE=$PHP_BASE \
	PHP_HOME=$PHP_HOME \
	PHP_INI_SCAN_DIR=$PHP_INI_SCAN_DIR \
$XDIR/frankenphp-linux-x86_64 run \
	--envfile $PDIR/etc/envfile \
	--config $PDIR/etc/Caddyfile \
	--watch 
```

### ~/fphp/etc/Caddyfile

```
{
    http_port   8880
    log {
		output  stderr
		level   debug
	}
	# Enable FrankenPHP
	frankenphp
	# Configure when the directive must be executed
	order php_server before file_server
}
http://127.0.0.1:8880 {

    root * {$SERVER_ROOT}
    # Enable compression (optional)
  	encode zstd br gzip
  	# Execute PHP files in the current directory and serve assets
   	php_server {
        split .php
    }

    handle_errors {
        rewrite * /404.html
        templates
        file_server
    }
}
```

### ~/fphp/etc/ini.d/php.ini

```
include_path = ".:${PHP_HOME}:${PHP_BASE}"
```
