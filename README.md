# Taylor's Helix (IX) Plugins
Several Garry's Mod Helix gamemode plugins, in hopefully functional states. Some may require additional changes to a schema in order to integrate and function successfully.

Content dependencies are not my work. They are, however, necessary for certain things to function, so if you're having audio/visual issues, try the content first.

## Upgrades
The Upgrades UI plugin is in itself relatively feature-complete. What is not complete, however, should you wish to use it, is the integrations and any changes you may need. Integrations refers to making the data sets on the items actually implemented. Some things are simple to implement, others are not. This Plugin will require a certain level of programming experience to make use of at all, and to make the most of it, a solid level of competency.

The upgrade trees themselves are entirely dynamic, defined rather easily in two tables. One in the plugin itself, one in the item being upgraded. Make sure to observe through the examples provided what details match between the two tables. Ordering in tables is important, so please observe that as well.

## Rankings
The rankings system works along with a reputation system. Presently, only chat commands from admins can edit reputation, though there's plenty of ways to automate/integrate such a system into other systems. Requires dependencies. Requires PDA Plugin for some functionality. Includes reputation system originally written by Verne, with some changes. Where this transition happens is explicitly commented.

## CWWeapons
For the default weapon items defined here, use my workshop addons here: 

https://steamcommunity.com/sharedfiles/filedetails/?id=2100883146 

Make sure to get all the addons and all the required content, and the required content's required content etc. if you intend to use it out of the box.

Also, included is a readme and many extra (commented) functions that, should you be skilled with programming or know someone who is, can be implemented to extend the features or resolve bugs with the original SWEP addons.

## Artifacts
Artifacts work via an integration with the Armor plugin, using artifact slots to define how many one may equip. Timers are then used to implement effects on a timed basis. Certain effects may not work out of the box without entirely external plugins found elsewhere, or adjustments made to make them work as-is.

Utilizes the following models for default items:

https://steamcommunity.com/sharedfiles/filedetails/?id=1320995437&searchtext=artifacts

Artifacts as a plugin can be a bit harsh on the server and at times the client. Please keep this in mind when diagnosing any issues you may have.

## Weight
Another take on the classic Weight plugin. Utilizes the item interaction system to avoid timers and other costly methods of calculating the weight of items in the inventory.

## PDAs
Originally written by Verne, moderately changed and fixed over the years. Needed for additional functionality with the Rankings plugin, allows for setting personal images and similar functionality.

## Notes
Additional notes and comments are included in each plugin in various files for various reasons. Please make sure to read these if you are confused or stuck on something.

A lot of the more difficult code here in the Rankings and Upgrades UIs were not meant for public release originally, essentially a "my eyes only" situation. As such they are not commented well and are not meant to be legible to others in that manner. Apologies for any difficulties this creates.

I do not have the time to assist in any implementations or installations. Bugs should be reported here, please provide as much context as possible.

## Unsupported Plugins
As the folder name describes. Currently I only have the heavily modified Attributes plugin there. It is an EXAMPLE of how to implement complicated rolling systems and automating certain turn-based RPG mechanics, like a tabletop style attack system. This one was originally written by Verne but massive changed over time to be something very, very different from what he originally wrote before I took over programming at that community.
