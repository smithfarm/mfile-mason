#!/bin/bash
# 
# release.sh
#
# This is a script that makes a tar archive of the present version of mfile
# and then increments the version number.

# define local working directory
DIRPREFIX='/home/ncutler/src/'
DIRNAME='mfile-mason'

# ensure we are in that directory
cd $DIRPREFIX$DIRNAME

# get mfile version number
VERNUM=`head -n 1 VERSION`
TMPFILE=Changelog.tmp

# parse version number using trick from stackoverflow.com
oIFS="$IFS"      # IFS is bash's argument separator, normally a space
IFS=.            # set it to a period
set -- $VERNUM   # take contents of VERNUM as the new set of arguments
IFS="$oIFS"      # return IFS the way it was

# increment version number (using new set of arguments obtained just above)
REV=`expr $3 + 1`    
VERNUM="$1.$2.$REV"
git tag ver-$VERNUM

# overwrite mfile/VERSION with incremented version number 
echo $VERNUM >VERSION

# get release description
echo "Changelog entry for this release:"
read CHGLOGENTRY

# update Changelog
CMD="sed \"1 i `date +%Y-%m-%d` Version $VERNUM $CHGLOGENTRY\" Changelog >$TMPFILE"
eval $CMD
mv $TMPFILE Changelog

# create tar archive of present release
( mkdir -p ../mfile-releases && cd .. && tar cfz mfile-releases/mfile-$VERNUM.tar.gz \
	--exclude-from $DIRNAME"EXCLUDE" \
	$DIRNAME )

# git
git commit -a -m "$CHGLOGENTRY"
echo -n "Pushing the commit to Github. . . "
git push -u origin master
echo "Done."

