# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
	window.idfullgrid = 1
	hashtag = "#findnewroads"
	#hashtag = "#FindnewRoads"

	testpanel = ->
		# ------------------------- This code is for testing ------------------------------------- #

		success = ( json ) ->
			$(".panelmediatoshow").html("")	
			$(".panelmediatoshow").addClass("twitter")
			$(".panelmediatoshow").append(
				"<div class='row'>"+
					"<div class='columns large-2 text-center'>"+
						"<img class='social' src='/assets/tw.png'>"+
					"</div>"+
					"<div class='columns large-5 text-center'>"+
						"<div class='image_parent_container'>"+
							"<div class='image_container'>"+
								"<img class='media_image' src='"+json[0].image_url+"'>"+
							"</div>"+
						"</div>"+
					"</div>"+
					"<div class='columns large-5'>"+
						"<h2 class='text-center'>"+json[0].user+"</h2>"+
						"<p class='media_text text-justify'>"+
							json[0].text.substring(0,139)+
						"</p>"+
					"</div>"+
				"</div>"
			)
			a= $(".media_text").text().replace(hashtag, '<span style="color:#2AB1EC;">'+hashtag+'</span>')
			$(".media_text").html(a)
			centercontent($(".panelmediatoshow .columns.large-2"), $(".social"),0,0)
			$(".panelmediatoshow").show()
					
		data = {}

		ajax("/media/show_media.json","GET", data, success)

		#---------------------------------------------------------------------------------------------#


	ajax = (url,type,data,success)->
		$.ajax
			url: url
			type: type
			dataType: 'JSON'
			data: data
			error : (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error:"+textStatus
			success : success

	ajax1 = (url,type,data,success)->
		$.ajax
			url: url
			type: type
			dataType: 'text'
			data: data
			error : (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error:"+textStatus
			success : success


	centercontent = (container, content, xadjustment, yadjustment) ->
		if $.isWindow(container[0])		
			container_width = container.innerWidth()
			container_height = container.innerHeight()
		else
			container_width = container.width()
			container_height = container.height()

		content_width = content.width()
		content_height = content.height()

		position_x = container_width/2 - content_width/2 + xadjustment
		position_y = container_height/2 - content_height/2 + yadjustment

		content.css({"top":position_y,"left":position_x})

	buildgrid = (x1,x2,y1,y2,container,idgrid, classtoadd) ->
		for i in [x1...x2]
			container.append("<div class='grid "+classtoadd+"' id=column"+i+"></div>")
			for j in [y1...y2]
				$("#column"+i).append("<div class='cellblock' id="+idgrid+"></div>")
				idgrid+=1
		return idgrid


	findemptygrid = ->
		doit = true
		idgrid = 1
		while doit
			a = $(".corbatin .grid").children("#"+idgrid)
			if a.children().length == 0 && idgrid<197
				
				doit = false
			else if a.children().length == 0 && idgrid >= 197
				a = "Full"
				doit = false
			idgrid+=1
		return a
			
	animatephoto = ->
		a= findemptygrid()
		if a == "Full"
			if window.idfullgrid == 197
				window.idfullgrid = 1
			
			a = $(".corbatin .grid").children("#"+window.idfullgrid)
			window.idfullgrid+=1

		$old = $('.panelmediatoshow .columns.large-5 img.media_image')
		#First we copy the arrow to the new table cell and get the offset to the document
		a.html("")	
		$new = $old.clone().appendTo("#"+a.attr('id'));
		newOffset = $new.offset();
		#Get the old position relative to document
		oldOffset = $old.offset();
		#we also clone old to the document for the animation

		$temp = $old.clone().appendTo('body');
		#hide new and old and move $temp to position
		#also big z-index, make sure to edit this to something that works with the page
		$temp
			.css('position', 'absolute')
			.css('left', oldOffset.left)
			.css('top', oldOffset.top)
			.css('z-index', 1000)
			.css('width',"53px")
			.css('height',"51px")
		$new.hide();
		$old.hide();

		#animate the $temp to the position of the new img

		$temp.animate( {'top': newOffset.top, 'left':newOffset.left, 'width':"53px", 'height':"51px"}, "slow", ->
			#callback function, we remove $old and $temp and show $new
			$new.show()
			$old.remove()
			$temp.remove()
			
			data ={
				id: $new.data("media-id"),
				origin: $new.data("origin")
			}
			 
			success = ( text ) ->

			error = (jqXHR, textStatus, errorThrown) ->

			ajax1("/media/showed","POST", data, success)			
		)


	showpanel  = (type, icon, user, id, origin, image, text)->
		$(".panelmediatoshow").html("")	
		$(".panelmediatoshow").addClass(type)
		$(".panelmediatoshow").append(
			"<div class='row'>"+
				"<div class='columns large-2 text-center'>"+
					"<img class='social' src='/assets/"+icon+".png'>"+
				"</div>"+
				"<div class='columns large-5 text-center'>"+
					"<div class='image_parent_container'>"+
						"<div class='image_container'>"+
							"<img class='media_image' data-media-id="+id+" data-origin="+origin+" src='"+image+"'>"+
						"</div>"+
					"</div>"+
				"</div>"+
				"<div class='columns large-5'>"+
					"<h2 class='text-center'>"+user+"</h2>"+
					"<p class='media_text text-justify'>"+
						text.substring(0,139)+
					"</p>"+
				"</div>"+
			"</div>"
		)
		if type=="twitter"
			a= $(".media_text").text().replace(hashtag, '<span style="color:#2AB1EC;">'+hashtag+'</span>')
			if $(".media_text").text().indexOf("#FindNewRoads") !=-1
				a= $(".media_text").text().replace("#FindNewRoads", '<span style="color:#2AB1EC;">'+hashtag+'</span>')

		else
			a= $(".media_text").text().replace(hashtag, '<span style="color:#36609F;">'+hashtag+'</span>')
			console.log $(".media_text").text().indexOf("#FindNewRoads") !=-1
			if $(".media_text").text().indexOf("#FindNewRoads") !=-1
				a= $(".media_text").text().replace("#FindNewRoads", '<span style="color:#36609F;">'+hashtag+'</span>')
		$(".media_text").html(a)
		$(".panelmediatoshow").show()
		centercontent($(".panelmediatoshow .columns.large-2"), $(".social"),0,0)
		$(".panelmediatoshow").addClass("animated zoomIn")				

	animatepromo = ->
		$(".promo span").removeClass("instagram")
		$(".promo").html("<img src='/assets/banner-de-twetts.jpg'>")
		top= $("#143").offset().top
		right = $("#204").offset().left
		left = $("#1").offset().left
		width = $(".promo").width()
		$(".promo").css("top",top)
		$(".promo").css("left",right+80)
		$(".promo").fadeIn()
		$(".promo").animate({'left':left-width-120}, 35000, ->
			TimersJS.timer 2000, (delta, now) ->
				$(".promo span").removeClass("twitter")
				$(".promo").html("<img src='/assets/banner-de-instagram.jpg'>")
				$(".promo").animate({'left':right+300}, 35000, ->
					$(".promo").fadeOut()
				)
			
		)
		


	if window.location.pathname == "/media/show_media"
		$(".header").remove()
		#centercontent($(window), $(".panelmediatoshow"),15,-6)
		$(".main_container").append("<div class='corbatin'></div>")
		idgrid = 1
		idgrid = buildgrid(1,14,0,4, $(".corbatin"),idgrid, "vertical_moved")
		idgrid = buildgrid(14,24,1,11, $(".corbatin"),idgrid, "")
		idgrid = buildgrid(24,37,0,4, $(".corbatin"),idgrid, "vertical_moved")
		#centercontent($(window), $(".corbatin"),-64,-128)	
		$(".corbatin").css("top",94)
		$(".corbatin").css("left",-84)

		success = ( json ) ->
			$(json).each (index,object) ->
				$("#"+(index+1)).append("<img class='media_image' src='"+object["image_url"]+"'>")

		data = {}
		ajax("/media/media_showed.json","GET", data, success)

		$("#startanimation").on "click", ->
			success = ( json ) ->
				TimersJS.multi 3000, json.length, ((repetition) ->
					if json[repetition].social_net_origin == "Twitter"
						showpanel("twitter","tw","@"+json[repetition].user, json[repetition].id_media, json[repetition].social_net_origin, json[repetition].image_url, json[repetition].text)
					else
						showpanel("instagram","ig",json[repetition].user, json[repetition].id_media, json[repetition].social_net_origin ,json[repetition].image_url, json[repetition].text)

					TimersJS.timer 2100, (delta, now) ->
						$(".panelmediatoshow").fadeOut()

					TimersJS.timer 2500, (delta, now) ->
						animatephoto()
						$(".panelmediatoshow").removeClass("twitter instagram")
						
				), ->
					console.log "The multi timer is complete"
					TimersJS.timer 1000, (delta, now) ->
						animatepromo()
					
			data = {}

			ajax("/media/show_media.json","GET", data, success)
