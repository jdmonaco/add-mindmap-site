#!/bin/bash

#
# Script to extract iThoughts web archives to a local web folder with index
#

# Ensure Unicode encoding if running in non-terminal shell or subshell
export LANG=en_US.UTF-8

# Set location of local web root for the mindmaps site
SITE="$HOME/Sites/mindmaps-site"

# Check for one argument -- path to zip file archive
if [[ $# -ne 1 ]]; then
    echo "Usage: `basename "$0"` archive-zip-file"
    exit 1
fi

ARCHIVE=$1
if [[ `dirname "$1"` != /* ]]; then
    ARCHIVE="`pwd`/$1"
fi
BASE=`basename "$ARCHIVE"`
STEM=${BASE%.zip}

if [[ $BASE = $STEM ]]; then
    echo "Archive is not a zip file: $BASE."
    exit 2
fi

# Set up the new web directory for the archive contents
DATE=`date +"%Y-%m-%d"`
MAPNAME="$DATE $STEM"
MAPPATH="$SITE/$MAPNAME"
rm -rf "$MAPPATH"
mkdir -p "$MAPPATH"

# Extract the zip file in the new web directory
cd "$MAPPATH"
unzip "$ARCHIVE" > /dev/null
mv `ls *.html` index.html

# Add markdown link for new mindmap to top of index listing
cd "$SITE"
MDLINK="[$MAPNAME]($MAPNAME \"$STEM\")"
MDINDEX=.index.md
MDOLD=.old.md
touch $MDOLD

if [[ -e $MDINDEX ]]; then
    grep "^\*" $MDINDEX > $MDOLD
    rm $MDINDEX
fi

echo -e "# Mindmaps Index\n" > $MDINDEX

if ! grep "\[$MAPNAME\]" $MDOLD >/dev/null; then
    echo "* $MDLINK" >> $MDINDEX
fi

cat $MDOLD >> $MDINDEX && rm $MDOLD

# Convert markdown listing index to html
export LISTING=listing.html
if [[ -z `which markdown_py` ]]; then
    echo "Cannot find markdown script (markdown_py)."
    exit 3
fi
markdown_py $MDINDEX > $LISTING

# Embed listing in index.html template
INDEX=index.html
if [[ -d template ]]; then
    cp -an template/* .
    export PRE=pre.html
    export POST=post.html
    if [[ -e $PRE ]] && [[ -e $POST ]]; then
        cat $PRE > $INDEX
        cat $LISTING >> $INDEX
        cat $POST >> $INDEX
        rm $LISTING $PRE $POST
    else
        echo "Template requires $PRE and $POST."
        exit 4
    fi 
else
    mv $LISTING $INDEX
fi
