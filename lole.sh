#!/usr/bin/env bash
# Usage: MAIL_TO=addr@host ./send_telnet.sh
set -euo pipefail

FROM="noreply@example.com"
TO="${MAIL_TO:?Need MAIL_TO}"
SUBJECT="Newsletter – ${GITHUB_RUN_NUMBER:-local}"

# Build minimal RFC-5322 message
cat > message.txt <<EOF
From: $FROM
To: $TO
Subject: $SUBJECT
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

$(<html/newsletter.html)
EOF

# Netcat (nc) is more convenient than telnet for scripting
nc localhost 25 <<EOF
HELO $(hostname)
MAIL FROM:<$FROM>
RCPT TO:<$TO>
DATA
$(cat message.txt)
.
QUIT
EOF
echo "✅  Mail queued for $TO"
