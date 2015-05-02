qwest = require 'qwest'
validate = require '../libs/validate.min.js'

app = () ->
	menuOpen = false
	initMap = () ->
		script = document.createElement('script');
		script.type = 'text/javascript';
		script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
			  '&signed_in=true&callback=callbackMap';
		document.body.appendChild(script);

	initMenu = () ->
		document.querySelector('#nav').addEventListener "click", () ->
			d = document.querySelector "#navContainer"

			if menuOpen
				d.className = d.className + " hidden"
			else
				d.className = d.className.replace /hidden/, ""

			menuOpen = !menuOpen

	initScroll = () ->

		document.addEventListener "scroll", (e) ->
			# console.log(document.documentElement.scrollTop)

	initLink = () ->
		buttons = document.querySelectorAll('button[data-href]')
		links = document.querySelectorAll('a[href]')

		addClickEventOnButtons = (element) ->
			element.addEventListener "click", (e) ->
				url = this.getAttribute 'data-href';
				
				if(url.indexOf("#") > -1)
					e.preventDefault()
					scrollTo url			

		addClickEventOnLinks = (element) ->
			element.addEventListener "click", (e) ->
				url = this.getAttribute 'href';
				console.log url
				if(url.indexOf("#") > -1)
					e.preventDefault()
					scrollTo url

		if buttons
			for element, index in buttons
				addClickEventOnButtons element

		if links
			for element, index in links
				addClickEventOnLinks element

		scrollTo = (el) ->
			window.scroll 0, getPosition(document.querySelector(el)).y - 50

	initForm = () ->

		apiKey = 'key-d0810d75bfab8b1da39c9eab3894eda7'
		mailURL = 'https://'+apiKey+'@api.mailgun.net/v3/mg.sanitherm-plomberie.fr'
		from = 'michael.tourneur@gmail.com'
		subject = 'Un plombier vite!'

		resetInput = (element) ->
			element.className = element.className.replace /error/, ""

		errorInput = (element) ->
			element.className = element.className + " error"

		resetForm = () ->
			inputs = document.querySelectorAll('#proposal input, #proposal textarea')
			if inputs

				for element, index in inputs
					resetInput element

		document.forms['formDevis'].addEventListener "submit", () ->
			resetForm()

		document.forms['formDevis'].addEventListener "reset", () ->
			resetForm()

		validator = new FormValidator 'formDevis', [
			name: 'civilite',
			display: 'required',
			rules: 'required'
		,
			name: 'nom',
			display: 'required',
			rules: 'required'
		,
			name: 'adresse',
			rules: 'required'
		,
			name: 'code',
			rules: 'required'
		,
			name: 'ville',
			display: 'password confirmation',
			rules: 'required'
		,
			name: 'tel',
			rules: 'required',
		,
			name: 'email',
			rules: 'required',
		,
			name: 'comment',
			rules: 'required',
		], (errors, event) ->
			event.preventDefault()

			if errors.length > 0
				for error, index in errors
					errorInput error.element
			else

				to = document.querySelector('input[name="email"]').value
				console.log to
				data = {
					from: from
					subject: subject
					to: to
					html: 'fsdfdsfd'
				}
				headers = {
					'Access-Control-Allow-Origin': '*'
				}
				qwest.post mailURL, data, headers
				.then (response) ->
					console.log response
				.catch (e, url) ->
					console.log e, url
				
	getPosition = (obj) ->
		curleft = curtop = 0;
		while (obj)
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
			obj = obj.offsetParent
		return {
			x: curleft,
			y: curtop
		}

	initScroll()
	initMenu()
	initLink()
	initMap()
	initForm()

window.callbackMap = () ->
	mapOptions =
		zoom: 8,
		center: new google.maps.LatLng '-34.397', '150.644'
		disableDefaultUI: true

	map = new google.maps.Map document.getElementById 'map-canvas', mapOptions

	map.setOptions 
		draggable: true,
		zoomControl: false,
		scrollwheel: false,
		disableDoubleClickZoom: true


window.addEventListener "load", () ->
	app()

