# factory
luacheck: [![luacheck status](https://travis-ci.org/theFox6/factory.svg?branch=master)](https://travis-ci.org/theFox6/factory)  
A new version of LemonLake's factory mod for minetest.
It adds machines for your factory.
For transportation there are vacuums, conveyor belts, fans and many more.
For production there are industrial furnaces, auto crafters and also many more.
There are also a few sorting devices.
And to stop the coal distribution madness there are electronic devices too.

## Submodules
Currently factory only has the modutil portable submodule.
It is needed to be able to run without the modutil mod.  
This means you can either download the modutil mod and enable it or get the submodule:

When cloning add "--recursive" option to clone including all submodules:
```
git clone --recursive https://github.com/theFox6/factory.git
```

If one of the submodule folders is empty use:
```
git submodule update --init
```
This will clone all missing submodules.

## Dependencies
factory needs modutil to load utilities it can also use modutil portable though  
you can add moreblocks to make the factory blocks cuttable  
you can add unified_inventory for crafting help  
you may want to have default because it is used for most crafting recipes  

## License
* original factory made by Lemmy is under the WTFPL
* zinc is taken of technic which is under LGPL, V2 or later
* silver is taken of moreores which is under zlib license
* parts of factory made by theFox6 are under the MIT License
