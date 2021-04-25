extends Node

# States and a tracker
const ST_INGAME = 0
const ST_ENDING = 1
var state = ST_INGAME

# What level are we playing?
#  0 = sky
#  1 = ocean
#  Later = loops, faster spawning
var level = 1

# Make some things easier to test
const DMG_CAR = 10
const DMG_ROCKET = 20
const DMG_CLOUD = -1


