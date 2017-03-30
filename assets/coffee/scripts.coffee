$ ->
	$window = $(window)
	$body = $('body')
	$main = $('main')
	$nav = $('nav')
	$home = $('#home')
	$photos = $('#photos')
	$spotlight = $('.spotlight')
	transEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd'

	$('.bg').each (i, bg) ->
		$bg = $(bg)
		if imgUrl = $bg.data('image')
			image = new Image
			image.src = imgUrl
			$(image).on 'load', (image) ->
				$bg.css
					'backgroundImage': 'url('+image.target.src+')'
				if(i == 0)
					$bg.addClass('show')

	maskPaper = new (paper.PaperScope)
	canvas = document.getElementById('canvas')
	$canvas = $(canvas)

	onScroll = (e) ->
		if $('section.things').eq(0).offset().top - $window.scrollTop() <= 0
			$nav.addClass('fixed')
		else
			$nav.removeClass('fixed')
	
	resize = () ->
		$canvas.css
			width: $window.innerWidth(),
			height: $window.innerHeight()

	changePhoto = (e) ->
		$curPhoto = $('#photos .bg.show')
		$nextPhoto = $curPhoto.next()
		if !$nextPhoto.length || !$nextPhoto.is('.bg')
			$nextPhoto = $('#photos .bg').first()	
		$curPhoto.removeClass('show')
		$nextPhoto.addClass('show')
		$('.thing.opened').each (i, thing) ->
			toggleThing(thing)

	toggleThing = (x) ->
		if($(x).is('.thing'))
			$thing = $(x)
		else
			$target = $(x.target)
			x.preventDefault()
			$thing = $target.parents('.thing')
		$more = $thing.find('.more')
		$inner = $more.find('.inner')
		console.log $more
		if !$thing.is('.opened')
			hoverThing($thing)
			if $inner.html().length
				height = $inner.innerHeight()
				$thing.addClass('opened')
				$more.css('height', height)
		else
			$thing.removeClass('opened')
			unhoverThing($thing)
			$more.css('height', '')

	hoverThing = (x) ->
		if($(x).is('.thing'))
			$thing = $(x)
		else
			$target = $(x.target)
			$thing = $target.parents('.thing')
		$siblings = $thing.parents('section').find('.thing')
		if $thing.is('.opened') || $siblings.filter('.opened').length
			return
		$thing.addClass('hover').removeClass('hidden')
		$('.hide').addClass('hidden')

	unhoverThing = (x) ->
		if($(x).is('.thing'))
			$thing = $(x)
		else
			$target = $(x.target)
			$thing = $target.parents('.thing')
		$siblings = $thing.parents('section').find('.thing')
		if $thing.is('.opened') || $siblings.filter('.opened').length
			return
		$thing.removeClass('hover')
		if(!$('.thing.hover').length)
			$('.hide').removeClass('hidden')
			$siblings.each (i, elem) ->
				setTimeout () ->
					$(elem).removeClass('hidden')
				, i*10

	clickNavLink = (e) ->
		e.preventDefault()
		slug = $(this).attr('href').replace('#', '')
		$curSect = $main.find('section.show')
		$nextSect = $('#'+slug)
		if !$nextSect.is('.opened')
			$curSect.removeClass 'show'
			$nextSect.addClass 'opened'
			$curSect.on transEnd, () ->
				$curSect.addClass 'none'
			$.ajax
				url: '/api?page='+slug
				dataType: 'html'
				error: (jqXHR, status, err) ->
					console.log(jqXHR, status, err)
				success: (response, status, jqXHR) ->
					$nextSect.append response
					$nextSect.removeClass 'none'
					$nextSect.addClass 'show'
		else if !$curSect.is('#'+slug)
			$curSect.removeClass 'show'
			$curSect.on transEnd, () ->
				$curSect.addClass 'none'
				$nextSect.removeClass 'none'
				$nextSect.addClass 'show'

	hoverNavLink = () ->
		$main.addClass('no-mix')
		$photos.addClass('navigating')

	unhoverNavLink = () ->
		$main.removeClass('no-mix')
		$photos.removeClass('navigating')

	$main.on 'mouseenter', '.thing .hover', hoverThing
	$main.on 'mouseleave', '.thing .hover', unhoverThing
	$main.on 'click', '.thing a.open', toggleThing
	$('#photos').on 'click', changePhoto
	$('nav .button a').on 'click', clickNavLink
	$('nav .button a').on 'mouseenter', hoverNavLink
	$('nav .button a').on 'mouseleave', unhoverNavLink
	$window.scroll(onScroll).scroll()
	$window.resize(resize).resize()

	return