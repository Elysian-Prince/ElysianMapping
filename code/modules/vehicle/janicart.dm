//PIMP-CART
/obj/vehicle/janicart
	name = "janicart (pimpin' ride)"
	desc = "A brave janitor cyborg gave its life to produce such an amazing combination of speed and utility."
	icon_state = "pussywagon"
	key_type = /obj/item/key/janitor
	var/obj/item/storage/bag/trash/mybag
	var/floorbuffer = FALSE

/obj/vehicle/janicart/Destroy()
	QDEL_NULL(mybag)
	return ..()

/obj/vehicle/janicart/handle_vehicle_offsets()
	..()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			switch(buckled_mob.dir)
				if(NORTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 4
				if(EAST)
					buckled_mob.pixel_x = -12
					buckled_mob.pixel_y = 7
				if(SOUTH)
					buckled_mob.pixel_x = 0
					buckled_mob.pixel_y = 7
				if(WEST)
					buckled_mob.pixel_x = 12
					buckled_mob.pixel_y = 7


/obj/item/key/janitor
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon_state = "keyjanitor"


/obj/item/janiupgrade
	name = "floor buffer upgrade"
	desc = "An upgrade for mobile janicarts."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "upgrade"
	origin_tech = "materials=3;engineering=4"

/obj/vehicle/janicart/Move(atom/OldLoc, Dir)
	. = ..()
	if(floorbuffer)
		var/turf/tile = loc
		if(isturf(tile))
			tile.clean_blood()
			for(var/obj/effect/E in tile)
				if(E.is_cleanable())
					qdel(E)



/obj/vehicle/janicart/examine(mob/user)
	. = ..()
	if(floorbuffer)
		. += "It has been upgraded with a floor buffer."


/obj/vehicle/janicart/attackby(obj/item/I, mob/user, params)
	var/fail_msg = "<span class='notice'>There is already one of those in [src].</span>"

	if(istype(I, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, fail_msg)
			return
		if(!user.drop_item())
			return
		to_chat(user, "<span class='notice'>You hook [I] onto [src].</span>")
		I.forceMove(src)
		mybag = I
		update_icon(UPDATE_OVERLAYS)
		return
	if(istype(I, /obj/item/janiupgrade))
		if(floorbuffer)
			to_chat(user, fail_msg)
			return
		floorbuffer = TRUE
		qdel(I)
		to_chat(user,"<span class='notice'>You upgrade [src] with [I].</span>")
		update_icon(UPDATE_OVERLAYS)
		return
	if(mybag && user.a_intent == INTENT_HELP && !is_key(I))
		mybag.attackby(I, user)
	else
		return ..()

/obj/vehicle/janicart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"
	if(floorbuffer)
		. += "cart_buffer"


/obj/vehicle/janicart/attack_hand(mob/user)
	if(..())
		return TRUE
	else if(mybag)
		mybag.forceMove(get_turf(user))
		user.put_in_hands(mybag)
		mybag = null
		update_icon(UPDATE_OVERLAYS)
