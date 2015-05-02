app = () ->

	init = () ->
		script = document.createElement('script');
		script.type = 'text/javascript';
		script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
		      '&signed_in=true&callback=initMap';
		document.body.appendChild(script);

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
			console.log getPosition(document.querySelector(el)).y - 50
			window.scroll 0, getPosition(document.querySelector(el)).y - 50


	getPosition = (obj) ->
		curleft = curtop = 0;
		while (obj)
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
			obj = obj.offsetParent
		return {
			x: curleft,
			y: curtop
		};

	init()
	initLink()

window.initMap = () ->
	mapOptions =
		zoom: 8,
		center: new google.maps.LatLng -34.397, 150.644

	map = new google.maps.Map document.getElementById 'map-canvas', mapOptions

window.addEventListener "load", () ->
	app()

