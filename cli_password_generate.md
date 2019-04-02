


date +%s|sha1sum |base64|head -c32

tr -dc '[:alnum:]' </dev/urandom 2>/dev/null|head -c32

openssl rand -base64 33


