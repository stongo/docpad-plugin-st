# Export Plugin
module.exports = (BasePlugin) ->

	# Load helper utility
	Utility = require("hoek")
	st = require("st")

	# Set defaults
	defaults = {
		path: "public_html/", # resolved against the process cwd
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

		dot: false # allow dot-files to be fetched normally, false return 403 for any url with a dot-file part

		passthrough: false # calls next/returns instead of returning a 404 error, false returns a 404 when a file or an index is not found
	}

	# Define Plugin
	class St extends BasePlugin

		# Plugin name
		name: 'st'

		# Copy out folder to public html folder after successful site generation
		generated: (opts, next) ->
			# Prepare
			docpad = @docpad
			docpadConfig = docpad.getConfig()
			wrench = require('wrench')
			path = require('path')
			config = @config
			staticPath = config.path or defaults.path

			# Set out directory
			# the trailing / indicates to cp that the files of this directory should be copied over
			# rather than the directory itself
			outPath = path.normalize "#{docpadConfig.outPath}"
			staticPath = path.normalize "#{staticPath}"

			if outPath.slice(-1) is '/'
				staticPath.slice(0, -1)

			staticPath = path.join process.cwd(), staticPath

			docpad.log "debug", "Copying out folder. outPath: #{outPath}, staticPath: #{staticPath}"

			###ncp outPath, staticPath, (err) ->
				return next(err) if err
				docpad.log "Done copying out folder to #{staticPath}"
				return next()###

			wrench.copyDirRecursive outPath, staticPath, {forceDelete: true}, (err) ->
				return next(err) if err
				docpad.log "Done copying out folder to #{staticPath}"
				return next()

		# Server Extend Event
		serverExtend: (opts) ->
			plugin = @
			docpad = @docpad
			{server} = opts
			config = @config
			settings = if config then Utility.applyToDefaults(defaults, config) else defaults

			# create st mount
			mount = st(settings)

			server.use(mount)

			return

			# Chain
			@
