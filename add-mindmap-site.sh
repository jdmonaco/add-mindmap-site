#!/bin/bash

#
# Script to extract iThoughts web archives to a local web folder with index
#

# Set location of local web root for the mindmaps site
SITE="$HOME/Sites/mindmaps-site"

# Check for one argument -- path to zip file archive
if [[ $# -ne 1 ]]; then
    echo "Usage: `basename "$0"` archive-zip-file"
    exit 1
fi

ARCHIVE=$1
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
mkdir -p "$MAPPATH"
cd "$MAPPATH"

# Extract the zip file in the new web directory
unzip "$ARCHIVE" > /dev/null
mv `ls *.html` index.html

# Add markdown link for new mindmap to site index
MDLINK="[$MAPNAME]($MAPNAME \"$STEM\")"
MDINDEX="$SITE/index.md"
if [[ ! -e "$MDINDEX" ]]; then
    echo -e "# Mindmaps Index\n" > "$MDINDEX"
fi
echo "* $MDLINK" >> "$MDINDEX"

# Convert markdown listing index to html
INDEX="$SITE/index.html"
if [[ -z `which markdown_py` ]]; then
    echo "Cannot find markdown script (markdown_py)."
    exit 3
fi
markdown_py "$MDINDEX" > "$INDEX"
