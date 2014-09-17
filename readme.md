# add-mindmap-site

This is a bash script to collect mindmaps exported from [iThoughts](http://toketaware.com/ithoughts-ios) as website archives. It extracts the mindmap `.zip` archive into a subfolder of a local web root, which defaults to `~/Sites/mindmaps-site/` but can be changed at the top of the script. A link to the newly added mindmap is then added as a new list item in the index of the web root. This currently requires python Markdown to be installed, with its `markdown_py` script on your `$PATH`. This script can be automated with a Hazel rule so that mindmap exports are automatically added to the mindmaps site.

If you copy the `template/` folder into the web root, the script will use a very basic html5 template for the listing.

Note: There is nothing special about the archives being iThoughts mindmaps, the only requirement is that the zip file with the website has one `.html` file in the root (it gets renamed to `index.html` since iThoughts uses a hash) and its links are all relative.
