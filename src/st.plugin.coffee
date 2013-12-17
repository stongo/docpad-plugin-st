# Export Plugin
module.exports = (BasePlugin) ->

	# Load helper utility
	Utility = require("hoek")
	st = require("st")

	# Set defaults
	defaults = {
		path: "out/", # resolved against the process cwd
		url: "/", # defaults to '/'
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
	}

	# Define Plugin
	class RestAPI extends BasePlugin

		# Plugin name
		name: 'st'

		# Server Extend Event
		# Add all of our REST Routes
		serverExtend: (opts) ->
			plugin = @
			docpad = @docpad
			{server} = opts
			config = @config
			options = config.st
			settings = if options then Utility.applyToDefaults(defaults, options) else defaults

			# create st mount
			mount = st(settings)

			return server.use(mount)

			# Chain
			@