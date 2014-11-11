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

	ajax1 = (url,type,data,success, error)->
		$.ajax
			url: url
			type: type
			dataType: 'text'
			data: data
			error : error
			success : success

	addtotab = (type) ->


	$("#ask_button").on "click", ->
		$('.content').html("")
		$(".loader").fadeIn()
		data={}
		success = ( json ) ->
			setTimeout (->
				$(".loader").fadeOut()	
			), 1500
			
			if json[0]
				$('.content').append(
					"<div class='row text-center'>"+
						"<div class='columns large-6'>"+
							"<p>Texto</p>"+
						"</div>"+
						"<div class='columns large-2' style='padding-top:3rem'>"+
							"<p>Imagen</p>"+
						"</div>"+
						"<div class='columns large-2'>"+
								"<p>Aprobar</p>"+
						"</div>"+
						"<div class='columns large-2'>"+
								"<p>No Aprobar</p>"+
						"</div>"+
					"</div>"
					)
				$(json).each (index,object) ->
					paneltab = ""
					if object["social_net_origin"] == "Twitter"
						paneltab = $('#paneltwitter')
					else
						paneltab = $('#panelinstagram')

					paneltab.append(
						"<div class='row'>"+
							"<div class='columns large-6'>"+
								"<p>"+object["text"]+"</p>"+
							"</div>"+
							"<div class='columns large-2'>"+
								"<img class='image_content' src='"+object["image_url"]+"''>"+
							"</div>"+
							"<div class='columns large-2'>"+
								"<div class='btn_admin approve text-center' data-media-id="+object["id_media"]+" data-origin="+object["social_net_origin"]+">"+
									"<p>Aprobar</p>"+
								"</div>"+
							"</div>"+
							"<div class='columns large-2'>"+
								"<div class='btn_admin disapprove text-center' data-media-id="+object["id_media"]+" data-origin="+object["social_net_origin"]+">"+
									"<p>No Aprobar</p>"+
								"</div>"+
							"</div>"+
						"</div>"
						)


		ajax("media/get_media.json","POST", data, success)

		
	$('.content').on 'click','.approve' , ->
		r = confirm("¿Está seguro que quiere APROBAR este contenido?")
		if r == true
			self = $(this)
			data ={
				id: $(this).data("media-id"),
				origin: $(this).data("origin")
			}

			success = ( text ) ->
				if text == "Completo"
					self.parents(".row").fadeOut()
					setTimeout (->
						self.parents(".row").remove()
					), 1000

					$(".alert div").html("Contenido Aprobado Satisfactoriamente")
					$("body").animate({ scrollTop: 0 }, "slow");
					$(".alert").fadeIn()
					setTimeout (->
						$(".alert").fadeOut()
					), 2000
			error = (jqXHR, textStatus, errorThrown) ->
				if textStatus == "Error"
					$(".alert div").html("Se ha presentado un error")
					$("body").animate({ scrollTop: 0 }, "slow");
					$(".alert").fadeIn()
					setTimeout (->
						$(".alert").fadeOut()
					), 2000

			ajax1("media/approve_media","POST", data, success, error)

	$('.content').on 'click','.disapprove' , ->
		r = confirm("¿Está seguro que quiere NO APROBAR este contenido?")
		if r == true
			self = $(this)
			data ={
				id: $(this).data("media-id"),
				origin: $(this).data("origin")
			}
			success = ( text ) ->
				if text == "Completo"
					self.parents(".row").fadeOut()
					setTimeout (->
						self.parents(".row").remove()
					), 1000

					$(".alert div").html("Contenido No Aprobado Satisfactoriamente")
					$("body").animate({ scrollTop: 0 }, "slow");
					$(".alert").fadeIn()
					setTimeout (->
						$(".alert").fadeOut()
					), 2000
			error = (jqXHR, textStatus, errorThrown) ->
				if textStatus == "Error"
					$(".alert div").html("Se ha presentado un error")
					$("body").animate({ scrollTop: 0 }, "slow");
					$(".alert").fadeIn()
					setTimeout (->
						$(".alert").fadeOut()
					), 2000
			ajax1("media/disapprove_media","POST", data, success, error)

	$("#ask_button").trigger("click")