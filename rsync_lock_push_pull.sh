#!/bin/sh
runRsync () {
  mode=${1}
  lockFile=/tmp/myhost-rsync.lock
  runCount=0
  runMax=5

  date "+rsync update starts at %Y-%m-%d %H:%M:%S"

  while [ $runCount -lt $runMax ]; do
    ### program to execute.
    if [ $mode = "PULLING" ]; then
      echo "PULLING ..... " $mode
      #lockf -t 0 ${lockFile} /usr/local/bin/php /home/myname/tmp/test.php
      lockf -t 0 ${lockFile} /usr/local/bin/rsync -avu --ipv4 --stats --safe-links --password-file=/usr/local/etc/rsyncd.passwd_rsyncbot rsyncbot@1.2.3.4::myhost-hq0 /home/myhost_bak/myhost-hq0/
    elif [ $mode = "PUSHING" ]; then
      echo "PUSHING .... " $mode
      #lockf -t 0 ${lockFile} /usr/local/bin/php /home/myname/tmp/test.php
      lockf -t 0 ${lockFile} /usr/local/bin/rsync -avu --ipv4 --stats --safe-links --password-file=/usr/local/etc/rsyncd.passwd_rsyncbot /home/myhost_bak/myhost-hq0/ rsyncbot@1.2.3.4::myhost-hq0
    fi

    ### checking the exit status of the previous command.
    if [ $? -eq 0 ]; then
      break
    fi

    runCount=`expr $runCount + 1`

    if [ $runCount -eq $runMax ]; then
      break
    fi

    sleep 10
  done;

  date "+rsync update ends at %Y-%m-%d %H:%M:%S"
}

#umask 27

### pulling from remote files to local
runRsync "PULLING"

### pushing from local files to remote
#runRsync "PUSHING"

echo '[DONE]'

