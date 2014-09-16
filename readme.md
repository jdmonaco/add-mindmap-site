# add-mindmap-site

This is a bash script to extract `.zip` files containing an [iThoughts](http://toketaware.com/ithoughts-ios) mindmap exported as a website. It extracts the mindmap website to a subfolder of a local web root, which defaults to `~/Sites/mindmaps-site/` but can be changed at the top of the script. Creating the index listing requires python Markdown to be installed, with its `markdown_py` script on your `$PATH`. This script can be automated with a Hazel rule so that mindmap exports are automatically added to the mindmaps site.

Note: There is nothing special about the archives being iThoughts mindmaps, the only requirement is that the zip file with the website has one `.html` file in the root (it gets renamed to `index.html` since iThoughts uses a hash) and its links are all relative.
