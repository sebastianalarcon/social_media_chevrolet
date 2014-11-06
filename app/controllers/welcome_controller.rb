class WelcomeController < ApplicationController
	def index
		call_media()
	end

	def call_media
		if($first_time == true)
			$client.search("#bogota", :result_type => "recent").take(20).each do |tweet|
				id= tweet.id
				text = tweet.text
				user = tweet.user.screen_name
				image = tweet.user.profile_image_url.to_s
				image.slice!("_normal")
				date = tweet.created_at
				newmedia= Medium.new(id_media:id, user:user, text:text, image_url:image, approve_state:"Por Aprobación", show_state:"No Mostrado",social_net_origin:"Twitter",media_created_at:date)
				newmedia.save
			end

			@instagram = Instagram.tag_recent_media("bogota").each do |insta|
				image = insta.images.standard_resolution.url
				if(insta.caption!=nil)
					text = insta.caption.text
				else
					text =""
				end
				
				user = insta.user.username
				id = insta.id
				date = Time.at(insta.created_time.to_i)
				newmedia= Medium.new(id_media:id, user:user, text:text, image_url:image, approve_state:"Por Aprobación", show_state:"No Mostrado",social_net_origin:"Instagram",media_created_at:date)
				newmedia.save
			end

			$first_time=false
		end
	end
end
