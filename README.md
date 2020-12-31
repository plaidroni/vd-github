# Vector Dealer
![alt text](https://imgur.com/a/1O8agaF)

This is a Garry's Mod extention which implements a new shop npc named the Vector Dealer. The Vector Dealer can be fully modulated by the administrator of the server through a plethora of the commands. This mod also introduces a new notification system that plays into a cat and mouse game for currency exclusively used by the Vector Dealer.


A DarkRP Black Market Dealer who sells exclusive, and rare items.
The Vector Dealer is a new way to add depth to your server and give players a reason to leave their bases. 

The Dealer appears at random intervals at selected locations to sell players, exclusive, exotic, and powerful items. This is not meant to replace your normal Black Market Dealer jobs, but rather give the top tier items the rarity they deserve, and make them feel that much more special and powerful. It also helps to alleviate the self-supplying of the best weapons and tools that plagues DarkRP servers.

![alt text](https://imgur.com/a/iMaIQli)

FEATURES
The Vector Dealer has many features, including,

-A simple and clean UI

-Smooth animations

-Automatic spawning and despawning

-SQL database storage

-In-game changeable config

![alt text](https://imgur.com/a/ylrV1tS)

Changing the Vector Dealer is easy to do, and you can change just about everything about him, including

-The weapons and items he sells

-The player model used

-The locations he spawns at 

-The spawn time intervals

![alt text](https://imgur.com/a/i3JjWLw)

QUICK START GUIDE
All of this information can be accessed in-game by typing "VDHelp" into the console

Position

VDSetPos String Name -- Sets the position of the Vector Dealer with look angle and position

VDDeletePos String Name -- Deletes a specific position of the Vector Dealer

VDViewPos -- Displays a table of all positions according to map and name

VDClearPos -- Clears all of the positions in the table



Model

VDAddModel String Path, String Name -- (format as 'models/MODEL.mdl') allows the admin to add a model

VDViewModel String Name -- displays all of the models in the DB

VDSetModel String Name -- sets the current model in accordance to the name

VDClearModel -- Deletes all models from the database

VDDeleteMdel String Name -- Deletes model with specified name



Inventory

VDAddWep String name, String model, String entity, Integer cost -- (EX: VDAddWep Famas models/weapons/w_tct_famas.mdl m9k_famas 15000) allows admins to add a weapon to the VDShop

VDViewWep --  Displays all guns in the shop

VDClearWep -- Deletes all guns from the database

VDDeleteWep String gun -- (EX: VDDeleteWep 'm9k_famas') Deletes the gun with specified nam



Spawn and despawn intervals

VDChangeSpawnInterval Int num -- Allows admins to change the interval for how long the VD is dormant (can support any amount of numbers.. just separate by spaces ex. VDChangeSpawnInterval 1 2 3 4)

VDChangeDespawnInterval Int num -- Allows admins to change the interval for how long the VD is active

VDViewInterval -- Shows all Spawn and Despawn Intervals



Manual spawning and despawning

VDInitialize -- Starts the Vector Dealer

VDRemove -- Remove the Vector Dealer (when the periodic respawning of the vector dealer occurs undo will not work. This command is used to remove the vector dealer... ONLY WORKS IF VECTOR DEALER IS SPAWNED THROUGH VDInitialize)

