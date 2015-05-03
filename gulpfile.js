// Generated by CoffeeScript 1.9.2
(function() {
  var browserify, config_file, data, destinations, fs, gulp, jade, koutoSwiss, plumber, public_dir, rename, source_dir, sources, stylus, uglify, webserver;

  gulp = require('gulp', jade = require('gulp-jade', stylus = require('gulp-stylus', koutoSwiss = require('kouto-swiss', rename = require('gulp-rename', plumber = require('gulp-plumber', webserver = require('gulp-webserver', browserify = require('gulp-browserify', uglify = require('gulp-uglify', data = require('gulp-data', fs = require('fs')))))))))));

  public_dir = 'public';

  source_dir = 'src';

  config_file = 'config.json';

  sources = {
    stylus: source_dir + '/stylus/app.styl',
    jade: [source_dir + '/jade/**/*.jade', '!' + source_dir + '/jade/includes/*.jade'],
    coffee: source_dir + '/coffee/**/*.coffee'
  };

  destinations = {
    css: public_dir + '/assets/css',
    html: public_dir,
    js: public_dir + '/assets/js'
  };

  gulp.task('stylus', function() {
    return gulp.src(sources.stylus).pipe(plumber()).pipe(stylus({
      use: koutoSwiss()
    })).pipe(rename("app.min.css")).pipe(gulp.dest(destinations.css));
  });

  gulp.task('jade', function() {
    return gulp.src(sources.jade).pipe(plumber()).pipe(data(function(file) {
      return JSON.parse(fs.readFileSync(config_file));
    })).pipe(jade({
      pretty: true
    })).pipe(gulp.dest(destinations.html));
  });

  gulp.task('coffee', function() {
    return gulp.src(sources.coffee, {
      read: false
    }).pipe(plumber()).pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    })).pipe(rename("app.min.js")).pipe(gulp.dest(destinations.js));
  });

  gulp.task('webserver', function() {
    return gulp.src(public_dir).pipe(webserver({
      port: 8888,
      livereload: true,
      open: true
    }));
  });

  gulp.task('watch', function() {
    gulp.watch(sources.stylus, ['stylus']);
    gulp.watch(sources.jade, ['jade']);
    return gulp.watch(sources.coffee, ['coffee']);
  });

  gulp.task('default', ['webserver', 'watch']);

}).call(this);
