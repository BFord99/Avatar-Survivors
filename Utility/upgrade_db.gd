extends Node

const ICON_PATH = "res://Art/UpgradeArt/"
const ABILITY_PATH = "res://Art/AbilityArt/"
const UPGRADES = {
	"rockShard1": {
		"icon": ABILITY_PATH + "earthShardIcon.png",
		"displayname": "Rock Shard",
		"details": "A chunk of ground is kicked at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"rockShard2": {
		"icon": ABILITY_PATH + "earthShardIcon.png",
		"displayname": "Rock Shard",
		"details": "A more durable chunk of ground is kicked",
		"level": "Level: 2",
		"prerequisite": ["rockShard1"],
		"type": "weapon"
	},
	"rockShard3": {
		"icon": ABILITY_PATH + "earthShardIcon.png",
		"displayname": "Rock Shard",
		"details": "An additional shard is kicked",
		"level": "Level: 3",
		"prerequisite": ["rockShard2"],
		"type": "weapon"
	},
	"rockShard4": {
		"icon": ABILITY_PATH + "earthShardIcon.png",
		"displayname": "Rock Shard",
		"details": "Two more shards are kicked",
		"level": "Level: 4",
		"prerequisite": ["rockShard3"],
		"type": "weapon"
	},
	"waterTornado1": {
		"icon": ABILITY_PATH + "waterTornadoIcon.png",
		"displayname": "Water Tornado",
		"details": "Conjure a violent rotating column of water",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"waterTornado2": {
		"icon": ABILITY_PATH + "waterTornadoIcon.png",
		"displayname": "Water Tornado",
		"details": "An additional tornado is created and tornados gain 25% additional knockback",
		"level": "Level: 2",
		"prerequisite": ["waterTornado1"],
		"type": "weapon"
	},
	"waterTornado3": {
		"icon": ABILITY_PATH + "waterTornadoIcon.png",
		"displayname": "Water Tornado",
		"details": "An additonal tornado is created and cooldown reduced by .5 second",
		"level": "Level: 3",
		"prerequisite": ["waterTornado2"],
		"type": "weapon"
	},
	"waterTornado4": {
		"icon": ABILITY_PATH + "waterTornadoIcon.png",
		"displayname": "Water Tornado",
		"details": "An additonal tornado is created and cooldown reduced by .5 second",
		"level": "Level: 4",
		"prerequisite": ["waterTornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "armor.png",
		"displayname": "Armor",
		"details": "Reduce incoming damage by an additional 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "armor.png",
		"displayname": "Armor",
		"details": "Reduce incoming damage by an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "armor.png",
		"displayname": "Armor",
		"details": "Reduce incoming damage by an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "armor.png",
		"displayname": "Armor",
		"details": "Reduce incoming damage by an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Speed",
		"details": "Movement speed increased by an additional 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
		"speed2": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Speed",
		"details": "Movement speed increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
		"speed3": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Speed",
		"details": "Movement speed increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
		"speed4": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Speed",
		"details": "Movement speed increased by 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
		"tome1": {
		"icon": ICON_PATH + "book.png",
		"displayname": "Tome",
		"details": "Incease the size of spells by 10% of base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
		"tome2": {
		"icon": ICON_PATH + "book.png",
		"displayname": "Tome",
		"details": "Incease the size of spells by an additional 10% of base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
		"tome3": {
		"icon": ICON_PATH + "book.png",
		"displayname": "Tome",
		"details": "Incease the size of spells by an additional 10% of base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
		"tome4": {
		"icon": ICON_PATH + "book.png",
		"displayname": "Tome",
		"details": "Incease the size of spells by an additional 10% of base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
		"scroll1": {
		"icon": ICON_PATH + "scroll.png",
		"displayname": "Scroll",
		"details": "Decrease the cooldown of spells by 10% of base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
		"scroll2": {
		"icon": ICON_PATH + "scroll.png",
		"displayname": "Scroll",
		"details": "Decrease the cooldown of spells by an additional 10% of base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
		"scroll3": {
		"icon": ICON_PATH + "scroll.png",
		"displayname": "Scroll",
		"details": "Decrease the cooldown of spells by an additional 10% of base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
		"scroll4": {
		"icon": ICON_PATH + "scroll.png",
		"displayname": "Scroll",
		"details": "Decrease the cooldown of spells by an additional 10% of base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
		"hat1": {
		"icon": ICON_PATH + "hat.png",
		"displayname": "Magic Hat",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
		"hat2": {
		"icon": ICON_PATH + "hat.png",
		"displayname": "Magic Hat",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 2",
		"prerequisite": ["hat1"],
		"type": "upgrade"
	},

	"food": {
		"icon": ICON_PATH + "ham.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
