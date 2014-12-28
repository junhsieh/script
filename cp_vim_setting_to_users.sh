#!/bin/sh

srcUser="git"
srcDir=/home/${srcUser}
destUser="jun svn root"
destDir=""
vimbakDir=""
chownArg=""

for du in $destUser; do
  if [ "${du}" = "root" ]; then
    destDir=/${du}
    chownArg=${du}:wheel
  else
    destDir=/home/${du}
    chownArg=${du}:${du}
  fi

  if [ ! -d ${destDir} ]; then
    continue;
  fi

  vimbakDir=${destDir}/.vimbak

  /bin/rm -r ${destDir}/.vim
  /bin/rm -r ${destDir}/.vimrc
  /bin/cp -r ${srcDir}/.vim ${destDir}
  /bin/cp -r ${srcDir}/.vimrc ${destDir}

  if [ ! -d ${vimbakDir} ]; then
    /bin/mkdir -p ${vimbakDir}
  fi

  /usr/sbin/chown ${chownArg} ${destDir}/.vimrc
  /usr/bin/find ${destDir}/.vim -print0 | xargs -0 -I {} /usr/sbin/chown ${chownArg} {}
  /usr/bin/find ${destDir}/.vimbak -print0 | xargs -0 -I {} /usr/sbin/chown ${chownArg} {}

  /bin/chmod 750 ${vimbakDir}
done

