# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
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
			if a.children().length == 0
				doit = false
				return a
			idgrid+=1


	animatephoto = ->
		a= findemptygrid()
		$old = $('.panelmediatoshow .columns.large-5 img.media_image')
		#First we copy the arrow to the new table cell and get the offset to the document
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
			.css('width',"128px")
			.css('height',"128px")
		$new.hide();
		$old.hide();

		#animate the $temp to the position of the new img
		
		$temp.animate( {'top': newOffset.top, 'left':newOffset.left, 'width':"128px", 'height':"128px"}, "slow", ->
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
					"<h2 class='text-center'>"+user+"</h2>"+
					"<img class='media_image' data-media-id="+id+" data-origin="+origin+" src='"+image+"'>"+						
				"</div>"+
				"<div class='columns large-5'>"+
					"<p class='media_text'>"+
						text+
					"</p>"+
				"</div>"+
			"</div>"
		)
		$(".panelmediatoshow").show()
		centercontent($(".panelmediatoshow .columns.large-5"), $(".media_text"),0,0)
		centercontent($(".panelmediatoshow .columns.large-5"), $(".media_image"),0,0)
		centercontent($(".panelmediatoshow .columns.large-2"), $(".social"),0,0)
		$(".panelmediatoshow").addClass("animated zoomIn")				


	if window.location.pathname == "/media/show_media"
		$(".header").remove()
		centercontent($(window), $(".panelmediatoshow"),-40,-40)
		$(".main_container").append("<div class='corbatin'></div>")
		idgrid = 1
		idgrid = buildgrid(1,11,0,4, $(".corbatin"),idgrid, "vertical_moved")
		idgrid = buildgrid(12,23,1,11, $(".corbatin"),idgrid, "")
		idgrid = buildgrid(23,34,0,4, $(".corbatin"),idgrid, "vertical_moved")
		centercontent($(window), $(".corbatin"),-64,-128)

		success = ( json ) ->
			$(json).each (index,object) ->
				$("#"+(index+1)).append("<img class='media_image' src='"+object["image_url"]+"'>")

		data = {}

		ajax("/media/media_showed.json","GET", data, success)


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

		data = {}

		ajax("/media/show_media.json","GET", data, success)