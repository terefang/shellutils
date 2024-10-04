## installing software packages

```
openssl
gnutls-utils
```

## creating a private key

```
openssl genrsa 2048 > host.private.key.pem

certtool -p --bits 2048 > host.private.key.pem
```

## looking at private key

```
openssl rsa -text -in host.private.key.pem

certtool -k --infile host.private.key.pem
```

## creating a request template file (old format, gnutls 2.x) host.tmpl

```
# X.509 Certificate options
organization = "acme acres fantasy corp llc"
unit = "acme acres design solutions"
country = AC

cn = "fantasy.acres.acme.ac"

dns_name = "*.fantasy.acres.acme.ac"
dns_name = "fantasy.acres.acme.ac"

tls_www_server
tls_www_client
#signing_key
#encryption_key
#time_stamping_key
#email_protection_key
```

## creating a request template file (new format, gnutls 3.x) host.tmpl

```
# X.509 Certificate options
dn = "cn=fantasy.acres.acme.ac,ou=acme acres design solutions,o=acme acres fantasy corp llc,c=AC"

dns_name = "*.fantasy.acres.acme.ac"
dns_name = "fantasy.acres.acme.ac"

tls_www_server
tls_www_client
#signing_key
#encryption_key
#time_stamping_key
#email_protection_key
```

## creating a certificate signing request (csr)

```
certtool -q --template host.tmpl --load-privkey host.private.key.pem > host.csr
```

## looking at csr

```
openssl req -text -in host.csr

certtool --crq-info --infile host.csr
```

## looking at certificate (pem/text file format)

```
openssl x509 -text -in host.crt.pem

certtool -i --infile  host.crt.pem
```

## looking at certificate (der/binary file format)

```
openssl x509 -text -inform der -in host.crt

certtool -i --inder --infile host.crt
```

## Creating a simple CA

```
XDIR=/path/to/ca/dir

cat > $XDIR/ca.tmpl <<EOT
# X.509 Certificate options
organization = "auth-ca"
cn = "rootca"
ca
expiration_days = 3600
EOT

certtool -p --bits 2048 > $XDIR/ca.key
certtool -s --load-ca-privkey $XDIR/ca.key --load-privkey $XDIR/ca.key --template $XDIR/ca.tmpl  > $XDIR/ca.crt
```

## Creating a Server Cert based on CA

```
XDIR=/path/to/ca/dir

cat > $XDIR/server.tmpl <<EOT
# X.509 Certificate options
organization = "auth-ca"
cn = "server"
tls_www_server
tls_www_client
expiration_days = 3600
EOT

certtool -p --bits 2048 > $XDIR/server.key
certtool -c --load-ca-certificate $XDIR/ca.crt --load-ca-privkey $XDIR/ca.key --load-privkey $XDIR/server.key --template $XDIR/server.tmpl  > $XDIR/server.crt
```

## Creating a Client Cert based on CA

```
XDIR=/path/to/ca/dir

CLIENT=client-$(uuidgen)

certtool -p --bits 2048 > $XDIR/$CLIENT.key

SER=$(certtool -k < $XDIR/$CLIENT.key|fgrep sha1|cut -f2 -d:|cut -b 1-12)

cat > $XDIR/$CLIENT.tmpl <<EOT
# X.509 Certificate options
organization = "auth-ca"
cn = "$CLIENT"
serial = 0x00$SER
tls_www_client
expiration_days = 3600
EOT

certtool -c --load-ca-certificate $XDIR/ca.crt --load-ca-privkey $XDIR/ca.key --load-privkey $XDIR/$CLIENT.key --template $XDIR/$CLIENT.tmpl  > $XDIR/$C.crt
cat $XDIR/$CLIENT.crt $XDIR/$CLIENT.key > $XDIR/$CLIENT.pem
certtool --to-p12 --outder --p12-name $CLIENT --password $CLIENT --load-ca-certificate $XDIR/ca.crt --load-certificate $XDIR/$CLIENT.crt --load-privkey $XDIR/$CLIENT.key > $XDIR/$CLIENT.p12
```
