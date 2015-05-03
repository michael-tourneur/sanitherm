qwest = require 'qwest'
validate = require 'validate-js'
VanillaModal = require 'vanilla-modal'
scrollTo = require '../libs/scrollTo.js'

window.app = () ->
	modal = new VanillaModal()
	menuOpen = false

	initMap = () ->
		lat = 43.144643
		long = 5.787034
		width = document.querySelector('#map').offsetWidth
		height = document.querySelector('#map').offsetHeight
		zoom = 14
		scale = 1
		if width > 640
			scale = 2
		if width > 640 * 2
			scale = 4
		mapURL = "https://maps.googleapis.com/maps/api/staticmap?center="+lat+","+long+"&zoom="+zoom+"&size="+width+"x"+height+"&markers=color:blue%7Clabel:S%7C"+lat+","+long+"&scale="+scale
		document.querySelector('#map').style.backgroundImage = "url('"+mapURL+"')"

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
			console.log(document.documentElement.scrollTop)

	initLink = () ->
		buttons = document.querySelectorAll('button[data-href]')
		links = document.querySelectorAll('a[href]')

		addClickEventOnButtons = (element) ->
			element.addEventListener "click", (e) ->
				url = this.getAttribute 'data-href';
				
				if(url.indexOf("#") > -1)
					e.preventDefault()
					scroll url			

		addClickEventOnLinks = (element) ->
			element.addEventListener "click", (e) ->
				url = this.getAttribute 'href';

				if(url.indexOf("#") > -1)
					e.preventDefault()
					scroll url

		if buttons
			for element, index in buttons
				addClickEventOnButtons element

		if links
			for element, index in links
				addClickEventOnLinks element

		scroll = (el) ->
			el = el.replace('#', '');
			scrollTo.smoothScroll el, - 58

	initGallery = () ->
		galleryURL = '/gallery.php'
		count = 0

		document.querySelector '#modal'
		.addEventListener "click", (e) ->
			if e.srcElement.className == "modal-inner"
				modal.close()

		initImage = (imagePath) ->
			
			imgContainer = document.createElement("div")
			imgContainer.className = 'col4'
			img = document.createElement("img")
			img.setAttribute('src', imagePath)
			imgContainer.appendChild img
			document.querySelector '#gallery'
			.appendChild imgContainer

			count += 1
			id = "modal-" + count
			img.href = id
			node = document.createElement("div")
			node.style.display = "none"
			node.id = id
			node.appendChild img.cloneNode()
			document.body.appendChild node

			img.addEventListener "click", () ->
				modal.open('#' + id)

		qwest.get galleryURL
		.then (response) ->
			response = JSON.parse response
			
			if response
				for imagePath, index in response
					initImage imagePath

	initForm = () ->
		mailURL = '/email.php'

		resetInput = (element) ->
			element.className = element.className.replace /error/, ""

		errorInput = (element) ->
			element.className = element.className + " error"

		resetForm = () ->
			inputs = document.querySelectorAll('#devis input, #devis textarea')
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
			# event.preventDefault()

			if errors.length > 0
				for error, index in errors
					errorInput error.element
			else

				formElements = document.getElementById("myForm").elements 
				data = {}
				for (i=0; i<formElements.length; i++)
					if (formElements[i].type!="submit")
						postData[formElements[i].name]=formElements[i].value

				qwest.post mailURL, data
				.then (response) ->
					modal.open('#success')
				.catch (e, url) ->
					modal.open('#error')

	# initScroll()
	initMenu()
	initLink()
	initGallery()
	initMap()
	initForm()

window.addEventListener "load", () ->
	app()