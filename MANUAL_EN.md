# machines
* the "Pneumatic Mover" moves items from a conveyor belt into a Chest, a Furnace or others
* the "Queued Pneumatic Mover" is like a "Pneumatic Mover" but it has got an own inventory
* the "Overflowing Pneumatic Mover" is like a "Pneumatic Mover" but it won't let more than one stack of one type into the target
* the "Pneumatic Taker" takes items out of a Chest, a Furnace or others
* "Conveyor Belts" move dropped items
* "fans" can blow items away
* the "Vacuum" collects items in its radius
* the "Swapper" sorts items that are inserted to the upper slots, the items you put into the lower left and right slots tell where to sort incoming items (items can be taken at the coloured sides with a "Pneumatic Taker")
* the "Vacuum Sorter" takes dropped or moving items below if they are the same as the inserted item
* you can store water and lava in a "Storage Tank" by punching it with a bucket
* the "Miner" digs down and brings up the recources
* the "Autocrafter" will use the recipe put into the upper left slot to create something out of the recources in the lower slots and will put the products into the upper left slot
* the "Sappling Treatment Plant" takes saplings in the upper slot and sapling fertilizer in the lower slot to make wood
* the "Industrial Furnace" is like a default furnace but it needs less coal for more performance but also a smoke tube
* the "Industrial Squeezer" is a press that makes tree sap out of trunks and compressed clay out of clay; in the upper the recource in the lower slot fuel; it also needs a smoke tube
* the "Wire Drawer" makes strings of the inserted material
* the "Smoke Tubes" have to be at least 2 and may be up to 7 blocks high

# fuel driven machines
All fuel driven machines as well as the sapling treatment plant take their fuel inserted from the backside.  
All items moved into the front and the sides using movers are put into the upper slot.  
Items can be taken out of the output from any side but it is recommended to not block the back as you may want to insert fuel there.  

There are many fuel driven machines in factory like the wire drawer, the squeezer and the furnace.  
The furnace just uses the heat for heating the contents,  
the other machines mainly use the heat for generating rotational energy.  
The wire drawer does also heat its contents in order to cut the wires from the metal but it mainly cuts and winds the wire.  
The squeezer only needs the heat for pressing, not to heat the contents of the press.  

# decorative blocks

## Factory brick
It's a type of brick that will make your factory's walls look nice.  
It is crafted using 4 factory lumps. Those are crafted by cooking compressed clay. Which is made by squeezing clay.  
Using the moreblocks mod it can be cut into all sorts of froms.  

## Item sieves
I hate falling into a hole in the floor that is only there for letting items through.  
Item sieves are just decoration that stops players from falling through where items go.  
The stack sieves are a little bigger so even a large amounts of items on one stack can go through.

# the Swapper
The Swapper is a sorting machine.  
It takes items from the lower four slots and takes a look whether they are the same as the ones at the long sides.  
If an item matches, it is moved to the output on the side where an item of the same type could be found.  
If the item didn't match any then it is moved to the upper slots.  
The items in the output slots can be taken using takers on the sides with the according color.  
The other side is for inserting items using a mover.  

# electronics

## routing
Electicity flows through cables. Other than actual electricity it is not distributed equally.  
The distribution goes to all connected nodes of the group "factory_electronic".  
The first machine that receives power will take as much as it can store.  
The leftover energy will be distributed further through the network.  
When power is transmitted to the network it will "heat up" the cables which prevents infinity loops in cables.  
Heated cables will cooldown when the power has been transmitted to all adjacent nodes.  
Heated cables also cooldown when they enter loading zone to prevent unloaded cables to become clogged.

## generators
Generators provide energy to the network, they usually have a small storage for leftover energy to determine when to stop running.  
The combustion generator takes fuel and burns it to produce energy. It needs a smoke tube as any other fuel driven machine in factory.

## batteries
Batteries store energy and redistribute it to the network.  
Batteries store 100 power per distribution to prevent them from drawing all energy from the network.  
Batteries usually push their energy to each other and back again which causes the load to be unbalanced.

## consumers
Consumers like the electric furnace can only run with power.  
They usually have a little storage for buffering incoming energy.

## api
Further information for modders who want to use electricity can be found in the
[electricity api documentation](electronics/api.md).
