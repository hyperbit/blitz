EZPub
=====

An online eBook (.epub) reader, PoweredbySpritz™.

![Alt text](http://ezpub.herokuapp.com/assets/screenshot1-ee0466f2fbda80144381a8bb6a32065f.jpg)

# Overview

![Alt text](http://ezpub.herokuapp.com/assets/screenshot2-dadcda55eaa2c4b9002d7a743520f066.jpg)

EZPub allows users to upload eBook (.epub) files to be read with Spritz reading technology. The uploaded file contents are parsed and rendered into plain text (left side of screenshot). It is also unzipped and (temporarily) saved to disk to be able to display the actual eBook into view (right side of screenshot). The algorithm is as follows:

1. User uploads a .epub file through [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
2. File is parsed and processed using [epub-parser](https://github.com/KitaitiMakoto/epub-parser)
3. File is then unzipped using [zipruby](https://bitbucket.org/winebarrel/zip-ruby/wiki/Home). Unzipped contents are (temporarily) saved to disk on Heroku server
4. Text content (to be Spritz'd) from each page of the eBook is parsed using [Nokogiri](http://nokogiri.org/)
5. Pages paginated with [will_paginate-bootstrap](https://github.com/bootstrap-ruby/will_paginate-bootstrap)

Seems like overkill, but each technology does their own part to ultimately render page content to plain text and display the actual eBook to the view.

# Contributions

Feel free to fork and send some pull requests. Any suggestions for improvement are welcomed, but I am especially looking to add background processes with a progress bar to display to the user.