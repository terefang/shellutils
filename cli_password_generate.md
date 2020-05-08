### generate passwords

generate random password (works with busybox)

> date '+%s' | sha512sum | base64 -w 0 | head -c64

needs urandom and coreutils

> tr -dc '[:alnum:]*$!%&/' </dev/urandom 2>/dev/null | head -c32

needs openssl

> openssl rand -base64 33

works with busybox

> dd if=/dev/urandom count=1 bs=512 2>/dev/null|base64 -w 0|tr -c -d '0-9A-Za-z'|cut -c 1-40

### password to hash

echo s3cr3t | openssl passwd -stdin -6

toybox|busybox mkpasswd -m sha512 s3cr3t

> $6$5TAr65zLQN23ny.D$Q8FNDyXdyH1my1vDegBm13tzbY89l3ecYBP7n22frn8D.cW.4AKn38R5q9pDQbRrgq5x0IJ/lv3sRz4h2Z0SD.

echo s3cr3t | openssl passwd -stdin -5

toybox|busybox mkpasswd -m sha256 s3cr3t

> $5$g0PUjG43Ptcj7Ooy$gR0p2F5wWzk7jEnPuYrm59.KnuvpO16JhrdE2ZgM.oC

echo s3cr3t | openssl passwd -stdin -apr1

> $apr1$UeWEgzUH$jhPrWxLK/DMwzzhljs3Mw/

echo s3cr3t | openssl passwd -stdin -1

toybox|busybox mkpasswd -m md5 s3cr3t

> $1$4hy.ekAE$lUiQVmEMtmmfub3HSBlQu0

toybox|busybox mkpasswd -m des s3cr3t

> Jv03Hfq1xNoNs
