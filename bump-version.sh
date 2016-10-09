#!/bin/sh

if [ $# -ne 1 ]; then
    echo usage: $0 VERSION
    exit
fi
VERSION=$1

if [ `uname` = 'Darwin' -a -e /usr/local/bin/gsed ]; then
    SED=/usr/local/bin/gsed
else
    SED=sed
fi

# FIXME: want to add leading two spaces.
${SED} -i.bak "/^\s*:version / c\
:version \"${VERSION}\"" robocar-apps.asd

${SED} -i.bak "/^\s*(defvar \*version\*/ c\
(defvar *version* \"${VERSION}\")" src/robocar-apps.lisp

echo ${VERSION} > VERSION
