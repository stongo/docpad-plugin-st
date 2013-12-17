# CRUD REST API Plugin for [DocPad](http://docpad.org)

<!-- BADGES/ -->

[![NPM version](http://badge.fury.io/js/docpad-plugin-st.png)](https://npmjs.org/package/docpad-plugin-st "View this project on NPM")

<!-- /BADGES -->


Add static caching for Express using the 'st' package


## Install

```
docpad install st
```


## Usage

Once installed, files will be served from a /static folder.

You can set your own custom st settings in the plugins config

```coffee
plugins:
	st:
		path: "src/static/", # resolved against the process cwd
		url: "static/", # defaults to '/'
		cache: # specify cache:false to turn off caching entirely
			fd:
				max: 1000, # number of fd's to hang on to
				maxAge: 1000*60*60, # amount of ms before fd's expire

			stat:
				max: 5000, # number of stat objects to hang on to
				maxAge: 1000 * 60, # number of ms that stats are good for

			content:
				max: 1024*1024*64, # how much memory to use on caching contents
				maxAge: 1000 * 60 * 10, # how long to cache contents for

			index:  # irrelevant if not using index:true
				max: 1024 * 8, # how many bytes of autoindex html to cache
				maxAge: 1000 * 60 * 10, # how long to store it for

			readdir:  # irrelevant if not using index:true
				max: 1000, # how many dir entries to cache
				maxAge: 1000 * 60 * 10, # how long to cache them for

		index: "index.html" # true for auto-index, the default, false returns 404's for directories

		dot: true # allow dot-files to be fetched normally, false return 403 for any url with a dot-file part

		passthrough: true # calls next/returns instead of returning a 404 error, false returns a 404 when a file or an index is not found 
```

<!-- HISTORY/ -->

## History
[Discover the change history by heading on over to the `HISTORY.md` file.](https://github.com/stongo/docpad-plugin-st/blob/master/HISTORY.md#files)

<!-- /HISTORY -->

<!-- LICENSE/ -->

## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

<!-- /LICENSE -->


