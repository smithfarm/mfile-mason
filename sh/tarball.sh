#!/bin/bash
# 
# tarball.sh
#

# define local working directory
DIRPREFIX='/home/ncutler/src/'
DIRNAME='mfile-mason'

# ensure we are in that directory
cd $DIRPREFIX$DIRNAME

# get mfile version number
VERNUM=`head -n 1 VERSION`
TMPFILE=Changelog.tmp

# create tar archive of present release
( mkdir -p ../mfile-releases && cd .. && tar cfz mfile-releases/mfile-$VERNUM.tar.gz \
	--exclude-from $DIRNAME"/EXCLUDE" \
	$DIRNAME )

