/datum/event/anomaly/anomaly_grav
	name = "Anomaly: Gravitational"
	startWhen = 3
	announceWhen = 20
	anomaly_path = /obj/effect/anomaly/grav

/datum/event/anomaly/anomaly_grav/announce()
	GLOB.minor_announcement.Announce("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert", 'sound/AI/anomaly_gravity.ogg')
