class Medium < ActiveRecord::Base

	def self.save_media
		if(Registry.last !=nil)
			registry = Registry.last
			last_update= registry.last_registry
		end
		$client.search("#cmcdeveloper", :result_type => "all").take(50).each do |tweet|
			id= tweet.id
			text = tweet.text
			user = tweet.user.screen_name
			image = tweet.user.profile_image_url.to_s
			image.slice!("_normal")
			date = tweet.created_at
			puts(text)
			puts(date.to_i > last_update.to_i)
			if(date.to_i > last_update.to_i)
				newmedia= Medium.new(id_media:id, user:user, text:text, image_url:image, approve_state:"Por Aprobación", show_state:"No Mostrado",social_net_origin:"Twitter",media_created_at:date)
				begin
					newmedia.save
				rescue
				end
			end
		end

		@instagram = Instagram.tag_recent_media("cmcdeveloper").each do |insta|
			image = insta.images.standard_resolution.url
			if(insta.caption!=nil)
				text = insta.caption.text
			else
				text =""
			end
			
			user = insta.user.username
			id = insta.id
			date = Time.at(insta.created_time.to_i)

			if(date.to_i > last_update.to_i)
				newmedia= Medium.new(id_media:id, user:user, text:text, image_url:image, approve_state:"Por Aprobación", show_state:"No Mostrado",social_net_origin:"Instagram",media_created_at:date)
				begin
					newmedia.save
				rescue
				end
			end
		end
		if(Registry.last ==nil)
			registry= Registry.new(last_registry:DateTime.now.new_offset(0))
		else
			registry.last_registry = DateTime.now.new_offset(0)
		end
		registry.save
		puts("Save Media Method Called. Last Update: #{registry.last_registry}")
	end

	def self.testing
		puts("Testing")
	end
end
