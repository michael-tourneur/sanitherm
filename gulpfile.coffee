gulp = require 'gulp',
coffee = require 'gulp-coffee',
jade = require 'gulp-jade',
stylus = require 'gulp-stylus',
koutoSwiss = require 'kouto-swiss',
rename    = require 'gulp-rename',
plumber    = require 'gulp-plumber',
webserver = require 'gulp-webserver',
data = require 'gulp-data',
fs = require 'fs'

public_dir = 'public'
source_dir = 'src'
config_file = 'config.json'

sources =
	stylus: source_dir + '/stylus/app.styl'
	jade: [source_dir + '/jade/**/*.jade', '!'+ source_dir + '/jade/includes/*.jade']
	coffee: source_dir + '/coffee/**/*.coffee'

destinations =
	css: public_dir + '/assets/css'
	html: public_dir
	js: public_dir + '/assets/js'

gulp.task 'stylus', ->
	console.log('test');
	gulp.src sources.stylus
		.pipe plumber()
		.pipe stylus
        	use: 
        		koutoSwiss()
		.pipe rename "app.min.css" 
		.pipe gulp.dest destinations.css

gulp.task 'jade', ->
	gulp.src sources.jade
		.pipe plumber()
		.pipe data (file) ->
			JSON.parse fs.readFileSync config_file
		.pipe jade
			pretty: true

	.pipe gulp.dest destinations.html

gulp.task 'coffee', ->
	gulp.src sources.coffee
    .pipe plumber()
    .pipe coffee()
    .pipe rename "app.min.js" 
    .pipe gulp.dest(destinations.js)

gulp.task 'webserver', () ->
	gulp.src public_dir
	.pipe webserver
		port: 8888,
		livereload: true,
		open: true

gulp.task 'watch', ->
	gulp.watch sources.stylus, ['stylus']
	gulp.watch sources.jade, ['jade']
	gulp.watch sources.coffee, ['coffee']

gulp.task 'default', ['webserver', 'watch']
