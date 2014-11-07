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
		panelheight= $(".panelmediatoshow").height()
		panelwidth= $(".panelmediatoshow").width()
		$(".panelmediatoshow").css("top",(window.innerHeight/2)-(panelheight/2))
		$(".panelmediatoshow").css("left",(window.innerWidth/2)-(panelwidth/2))
		
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
		

		corbatinheight= $(".corbatin").height()
		corbatinwidth= $(".corbatin").width()
		$(".corbatin").css("top",(window.innerHeight/2)-(corbatinheight/2)-128)
		$(".corbatin").css("left",(window.innerWidth/2)-(corbatinwidth/2)-64)


		success = ( json ) ->
		#	idgrid = 1
			console.log json[0]
			#$(json).each (index,object) ->
			$(".panelmediatoshow").html("")
			$(".panelmediatoshow").append(
				"<div class='row'>"+
					"<div class='columns large-7'>"+
						"<p class='media_text'>"+
							json[0].text+
						"</p>"+
					"</div>"+
					"<div class='columns large-5'>"+
						"<img src='"+json[0].image_url+"'>"+
					"</div>"+
				"</div>"
				)
			$(".panelmediatoshow").show( "scale", {}, 2000, -> 
				setTimeout (->
					$old = $('.panelmediatoshow .columns.large-5 img');
					#First we copy the arrow to the new table cell and get the offset to the document
					$new = $old.clone().appendTo('#1');
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
					  .css('zIndex', 1000);
					$new.hide();
					$old.hide();
					#animate the $temp to the position of the new img
					$temp.animate( {'top': newOffset.top, 'left':newOffset.left, 'width':"128px", 'height':"128px"}, 'slow', ->
					   #callback function, we remove $old and $temp and show $new
					   $new.show()
					   $old.remove()
					   $temp.remove()
					)
					$(".panelmediatoshow").fadeOut()
				), 1000


				)

			

			
		#		doit = true
		#		while doit
		#			a = $(".corbatin .grid").children("#"+idgrid)
		#			console.log("a: "+a)
		#			if a.children().length == 0
		#				a.append("<img src='"+object.image_url+"'>")
		#				doit = false
		#			
		#			idgrid+=1

		data = {}

		ajax("/media/show_media.json","GET", data, success)



