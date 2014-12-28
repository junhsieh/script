#!/bin/sh

srcUser="git"
srcDir=/home/${srcUser}
destUser="jun root"
destDir=""
vimbakDir=""
userGroup=""

for du in $destUser; do
  if [ "${du}" = "root" ]; then
    destDir=/${du}
  else
    destDir=/home/${du}
  fi

  vimbakDir=${destDir}/.vimbak
  userGroup=`id -gn ${du}`

  /bin/rm -r ${destDir}/.vim
  /bin/rm -r ${destDir}/.vimrc
  /bin/cp -r ${srcDir}/.vim ${destDir}
  /bin/cp -r ${srcDir}/.vimrc ${destDir}

  if [ ! -d ${vimbakDir} ]; then
    /bin/mkdir -p ${vimbakDir}
  fi

  /usr/bin/find ${destDir}/.vim -print0 | xargs -0 -I {} /usr/sbin/chown ${du}:${userGroup} {}
  /usr/bin/find ${destDir}/.vimbak -print0 | xargs -0 -I {} /usr/sbin/chown ${du}:${userGroup} {}
  /usr/sbin/chown ${du}:${userGroup} ${destDir}/.vimrc

  /bin/chmod 750 ${vimbakDir}
done

