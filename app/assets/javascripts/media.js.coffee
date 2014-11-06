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

	if window.location.pathname == "/media/show_media"
		$(".header").remove()
		$(".main_container").append("<div class='corbatin'></div>")
		idgrid=1
		for i in [1...11]
			$(".corbatin").append("<div class='grid vertical_moved' id=column"+i+"></div>")
			for j in [0...4]
				$("#column"+i).append("<div class='cellblock' id="+idgrid+"></div>")
				idgrid+=1

		for i in [12...23]
			$(".corbatin").append("<div class='grid' id=column"+i+"></div>")
			for j in [1...11]
				$("#column"+i).append("<div class='cellblock' id="+idgrid+"></div>")
				idgrid+=1

		for i in [23...34]
			$(".corbatin").append("<div class='grid vertical_moved' id=column"+i+"></div>")
			for j in [1...5]
				$("#column"+i).append("<div class='cellblock' id="+idgrid+"></div>")
				idgrid+=1

		success = ( json ) ->
			idgrid = 1
			$(json).each (index,object) ->
				doit = true
				console.log ("Object "+object)
				console.log ("id "+idgrid)
				while doit
					a = $(".corbatin .grid").children("#"+idgrid)
					console.log("a: "+a)
					if a.children().length == 0
						a.append("<img src='"+object.image_url+"'>")
						doit = false
					
					idgrid+=1

		data = {}

		ajax("/media/show_media.json","GET", data, success)


