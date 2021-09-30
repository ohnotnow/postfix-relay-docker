#!/bin/bash

set -e

echo "Starting postfix with :"
echo "Local hostname : ${POSTFIX_HOSTNAME}"
echo "Relay mail via : ${POSTFIX_RELAY}"
echo "Accept mail from : ${POSTFIX_NETWORKS}"
echo "Allow these senders : ${POSTFIX_SENDERS}"

postconf -e myhostname=${POSTFIX_HOSTNAME}
postconf -e relayhost="[${POSTFIX_RELAY}]"
postconf -e mynetworks="127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ${POSTFIX_NETWORKS}"
touch /etc/postfix/sender_access
for SENDER in ${POSTFIX_SENDERS}; do
    echo "${SENDER} permit" >> /etc/postfix/sender_access
done
postmap /etc/postfix/sender_access
postconf -e smtpd_sender_restrictions="check_sender_access hash:/etc/postfix/sender_access reject_unlisted_sender"
echo "${POSTFIX_HOSTNAME}" > /etc/mailname

exec "$@"
