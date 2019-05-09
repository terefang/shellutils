generate random password (works with busybox)

> date '+%s' | sha1sum | base64 | head -c32

needs urandom and coreutils

> tr -dc '[:alnum:]*$!%&/' </dev/urandom 2>/dev/null | head -c32

needs openssl

> openssl rand -base64 33

works with busybox

> dd if=/dev/urandom count=1 bs=512 2>/dev/null|base64 -w 0|tr -c -d '0-9A-Za-z'|cut -c 1-40
