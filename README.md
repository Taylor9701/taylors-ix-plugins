# Taylor's Helix (IX) Plugins

1. [Upgrades](#upgrades): Creates a framework ready to be implemented which allows for dynamically structured upgrade trees for any chosen items. Requires a good amount of setup.
2. [Rankings](#rankings): Adds a tab that shows information about various players currently on the server, their rank, and their character's info. Players must opt into this, and can decide what character info they wish to share with others.
3. [Artifacts](#artifacts): Enables the functionality of Artifacts, with varying positive and negative effects.
4. [Weight](#weight): Provides a simple and lightweight solution for calculating and limiting players' inventory weight.
5. [PDAs](#pdas): Straightforward plugin required for using global messaging, accessing the rankings system, as well as for setting a personal PDA and Rankings image to be used.

## Upgrades
![upgrades](https://user-images.githubusercontent.com/35386424/154877130-91daa92f-4d9c-4296-a239-b2e28b640ede.png)
The Upgrades UI plugin is in itself relatively feature-complete. What is not complete, however, should you wish to use it, is the integrations and any changes you may need. Integrations refers to making the data sets on the items actually implemented. Some things are simple to implement, others are not. This Plugin will require a certain level of programming experience to make use of at all, and to make the most of it, a solid level of competency.

The upgrade trees themselves are entirely dynamic, defined rather easily in two tables. One in the plugin itself, one in the item being upgraded. Make sure to observe through the examples provided what details match between the two tables. Ordering in tables is important, so please observe that as well.

For ease of table creation, the following Regex formulas can validate the table data for both types of tables present in this plugin.

### Plugin Table Entries RegEx
```
^\["([\w]|[_]|[\d])+\"\] = {name = "[\w|\s]+", desc = "[\w|\s]+\.*", price = \d+, enames = {[\"\w\"\,? ]+}, img = "[\w|\/|\d|\.|\_]+"},$
```

### Item Table Entries RegEx
```
^{name = "[\w|\s]+", dep = {"[\w|\s]+[ or ]?[\w|\s]+"}, adjacent = {"[\w|\s]+"}, blocks = {[\"\w|\s\"\,? ]+}, amounts = {\d+}, pos = \d, row = \d},$
```

Alternatively, feel free to make a copy of [this google sheet](https://docs.google.com/spreadsheets/d/11GMEUL8g-1mIsWqb17be_qhnoyLJvtjURkfaVQnSyhk/edit?usp=sharing) if you don't know exactly what to do with the above to make a useful table creation tool.

## Rankings
![rankings](https://user-images.githubusercontent.com/35386424/154877254-e7444d80-fb25-41f9-a276-56ebd186f698.png)
The rankings system works along with a reputation system. Presently, only chat commands from admins can edit reputation, though there's plenty of ways to automate/integrate such a system. Requires dependencies. Requires PDA Plugin for some functionality. Includes reputation system originally written by Verne, with some changes. Where this transition happens is explicitly commented.

## CWWeapons
For the default weapon items defined here, use my workshop addons here: 

https://steamcommunity.com/sharedfiles/filedetails/?id=2100883146 

Make sure to get all the addons and all the required content, and the required content's required content etc. if you intend to use it out of the box.

Included is a readme and many extra (commented) functions that, should you be skilled with programming or know someone who is, can be implemented to extend the features or resolve bugs with the original SWEP bases. This is likely the most extensively well-setup plugin here for ease-of-use.

## Artifacts
Artifacts work via an integration with the Armor plugin, using artifact slots to define how many one may equip. Timers are then used to implement effects on a timed basis. Certain effects may not work out of the box without entirely external plugins found elsewhere, or adjustments made to make them work as-is.

Utilizes the following models for default items:

https://steamcommunity.com/sharedfiles/filedetails/?id=1320995437&searchtext=artifacts

Artifacts as a plugin can be a bit harsh on the server and at times the client. Please keep this in mind when diagnosing any issues you may have.

## Weight
![weight](https://user-images.githubusercontent.com/35386424/154877489-91ba2790-fab4-41ee-a589-f408bc28001b.png)

Another take on the classic Weight plugin. Utilizes the item interaction system to avoid timers and other costly methods of calculating the weight of items in the inventory.

## PDAs

Originally written by Verne, moderately changed and fixed over the years. Needed for additional functionality with the Rankings plugin, allows for setting personal images and similar functionality.

## Notes
Additional notes and comments are included in each plugin in various files for various reasons. Please make sure to read these if you are confused or stuck on something.

A lot of the more difficult code here in the Rankings and Upgrades UIs were not meant for public release originally, essentially a "my eyes only" situation. As such they are not commented well and are not meant to be legible to others in that manner. Apologies for any difficulties this creates. I will attempt to resolve this with an upcoming revisitation soon.

I do not have the time to assist in any implementations or installations. Bugs should be reported here, please provide as much context as possible.

## Unsupported Plugins
As the folder name describes. Currently I only have the heavily modified Attributes plugin there. It is an EXAMPLE of how to implement complicated rolling systems and automating certain turn-based RPG mechanics, like a tabletop style attack system. The very initial version was written by Verne, but was massively changed over time into what it is now.
