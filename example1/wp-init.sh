#!/bin/sh

curl 'http://localhost/wp-admin/install.php?step=1' \
-H 'Pragma: no-cache' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Accept-Language: en-US,en;q=0.8,it;q=0.6' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'User-Agent: sysdig-init' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
-H 'Connection: keep-alive' --data 'language=' --compressed

sleep 1

curl 'http://localhost/wp-admin/install.php?step=2' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data 'weblog_title=test&user_name=test&admin_password=77dmV42exe%21aCrsRU7&pass1-text=77dmV42exe%21aCrsRU7&admin_password2=77dmV42exe%21aCrsRU7&admin_email=l%40gmail.com&Submit=Install+WordPress&language=' \
--compressed
