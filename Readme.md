# Basic postfix smtp relay Docker setup

This is a very basic smtp relay only for use on a local LAN.  It will allow specific FROM addresses to relay mails
out to a smarthost.

## Usage

You can build the image by doing :
```bash
docker build -t myrelay:1.0 .
```
Then run it like this :
```bash
docker run -d \
  -e POSTFIX_HOSTNAME=fred.example.com \
  -e POSTFIX_RELAY=smtp.example.com \
  -e POSTFIX_NETWORKS="192.168.0.0/16" \
  -e POSTFIX_SENDERS="alice@example.com bob@example.com" \
  -p 2555:25 \
  myrelay:1.0
```
That should then start listening on port 2555 for smtp connections.  You can use netcat to try it :
```bash
$ nc localhost 2555
220 fred.example.com ESMTP Postfix (Ubuntu)
HELO smtp.domain.com
250 fred.example.com
MAIL FROM:<bad@example.com>
250 2.1.0 Ok
RCPT TO:<bob@secure.net>
454 4.7.1 <bob@secure.net>: Relay access denied
^D

$ nc localhost 2555
220 fred.example.com ESMTP Postfix (Ubuntu)
HELO smtp.domain.com
250 fred.example.com
MAIL FROM:<alice@example.com>
250 2.1.0 Ok
RCPT TO:<bob@secure.net>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
hello
.
250 2.0.0 Ok: queued as DAF12A0159
^D
```
There is also an example `docker-compose.yml` file if you want to run it like that.
```bash
export IMAGE_NAME=myrelay:1.0
export POSTFIX_RELAY=smtp.example.com
export POSTFIX_HOSTNAME=www.example.com
export POSTFIX_SENDERS="alice@example.com bob@example.com"
export POSTFIX_PORT=2555
docker-compose up -d
```
