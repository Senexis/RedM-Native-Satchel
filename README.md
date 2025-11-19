# Native Satchel
A work-in-progress implementation of the truly native satch UI.

## Triggers
TODO: Write better documentation

```lua
TriggerEvent("native_satchel:add_item", TODO)

TriggerEvent("native_satchel:remove_item", TODO)

TriggerEvent("native_satchel:reload", TODO)

TriggerEvent("native_satchel:open_satchel", TODO)

TriggerEvent("native_satchel:close_satchel", TODO)
```
## Events
TODO: Write better documentation

### General events

```lua
AddEventHandler("native_satchel:satchel_opened", function()
    print("[NativeSatchel] native_satchel:satchel_opened")
end)

AddEventHandler("native_satchel:satchel_closed", function()
    print("[NativeSatchel] native_satchel:satchel_closed")
end)
```

### Item events

```lua
AddEventHandler("native_satchel:item_used", function(itemId)
    print("[NativeSatchel] native_satchel:item_used with ID", itemId)
end)

AddEventHandler("native_satchel:item_broken", function(itemId)
    print("[NativeSatchel] native_satchel:item_broken with ID", itemId)
end)

AddEventHandler("native_satchel:item_discarded", function(itemId)
    print("[NativeSatchel] native_satchel:item_discarded with ID", itemId)
end)

AddEventHandler("native_satchel:item_discarded_all", function(itemId)
    print("[NativeSatchel] native_satchel:item_discarded_all with ID", itemId)
end)

AddEventHandler("native_satchel:item_sent_all", function(itemId)
    print("[NativeSatchel] native_satchel:item_sent_all with ID", itemId)
end)

AddEventHandler("native_satchel:item_focused", function(itemId)
    print("[NativeSatchel] native_satchel:item_focused with ID", itemId)
end)
```

### Folder events

```lua
AddEventHandler("native_satchel:folder_opened", function(folderId)
    print("[NativeSatchel] native_satchel:folder_opened with ID", folderId)
end)

AddEventHandler("native_satchel:folder_focused", function(folderId)
    print("[NativeSatchel] native_satchel:folder_focused with ID", folderId)
end)
```

## Attribution
TODO: Write proper attribution

- [aaron1a12's Satchel Research](https://github.com/aaron1a12/wild/blob/main/wild-satchel/client/cl_satchel_native_research.lua)
- [alloc8or's Native DB](https://alloc8or.re/rdr3/nativedb/)
- [femga's RDR3 Discoveries](https://github.com/femga/rdr3_discoveries/)
- [gottfriedleibniz's Data View implementation](https://github.com/gottfriedleibniz)
- [MagnarRDC's Support](https://x.com/magnarrdc)

## Contributing
Thank you for considering contributing to Native Satchel! Please note that this project is released with a [Contributor Covenant Code of Conduct](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CODE_OF_CONDUCT.md). By participating in any way in this project, you agree to abide by its terms.

Before contributing, please take a moment to read the [Contribution Guide](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CONTRIBUTING.md) to understand the development process and how to contribute.

## License
Native Satchel is open-sourced software licensed under the [GNU GPL v3](https://github.com/Senexis/RedM-Native-Satchel/blob/main/LICENSE.md).
