generate random password (works with busybox)

> date +%s|sha1sum |base64|head -c32

needs urandom and coreutils

> tr -dc '[:alnum:]*$!%&/' </dev/urandom 2>/dev/null|head -c32

needs openssl

> openssl rand -base64 33
