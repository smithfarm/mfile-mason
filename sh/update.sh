#!/bin/bash

# define local working directory
DIRPREFIX='/home/smithfarm/src/'
DIRNAME='mfile-mason'

# ensure we are in that directory
cd $DIRPREFIX$DIRNAME

# get mfile version number
VERNUM=`head -n 1 VERSION`
TMPFILE=Changelog.tmp

# get mfile version number
VERNUM=`head -n 1 VERSION`
TMPFILE=Changelog.tmp

# get release description
echo "Changelog entry for this update:"
read CHGLOGENTRY
echo $CHGLOGENTRY

# update Changelog
CMD="sed \"1 i `date +%Y-%m-%d` Version $VERNUM $CHGLOGENTRY\" Changelog >$TMPFILE"
eval $CMD
mv $TMPFILE Changelog

# commit changes to local git repo
CMD="git commit -a -m \"$CHGLOGENTRY\""
eval $CMD

