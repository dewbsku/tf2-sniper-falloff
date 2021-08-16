# tf2-sniper-falloff
Plugin that gives sniper rifle falloff

By default this plugin does nothing. Alter the plugin's behavior on the fly with the following cvars:
sm_sniperfalloff_enabled
sm_sniperfalloff_distance_min
sm_sniperfalloff_distance_max
sm_sniperfalloff_fraction
sm_sniperfalloff_headshotoverride
sm_sniperfalloff_distance_min_headshot
sm_sniperfalloff_distance_max_headshot
sm_sniperfalloff_fraction_headshot

Easily visualize the falloff function here: https://www.desmos.com/calculator/rxpyctzxlm

c1 = Initial Damage
c2 = Min falloff distance
c3 = Max falloff distance
c4 = The fraction of damage sniper rifles deal at max falloff