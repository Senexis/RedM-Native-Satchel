# Native Satchel
A work-in-progress implementation of the truly native satch UI.

## Events
TODO: Write better documentation

```lua
-- General events

AddEventHandler("native_satchel:open", function()
    print("[NativeSatchel] native_satchel:open")
end)

AddEventHandler("native_satchel:close", function()
    print("[NativeSatchel] native_satchel:close")
end)

-- Item events

AddEventHandler("native_satchel:use_item", function(itemId)
    print("[NativeSatchel] native_satchel:use_item with ID", itemId)
end)

AddEventHandler("native_satchel:break_item", function(itemId)
    print("[NativeSatchel] native_satchel:break_item with ID", itemId)
end)

AddEventHandler("native_satchel:drop_item", function(itemId)
    print("[NativeSatchel] native_satchel:drop_item with ID", itemId)
end)

AddEventHandler("native_satchel:discard_all", function(itemId)
    print("[NativeSatchel] native_satchel:discard_all with ID", itemId)
end)

AddEventHandler("native_satchel:send_all", function(itemId)
    print("[NativeSatchel] native_satchel:send_all with ID", itemId)
end)

AddEventHandler("native_satchel:focus_item", function(itemId)
    print("[NativeSatchel] native_satchel:focus_item with ID", itemId)
end)

-- Folder events

AddEventHandler("native_satchel:open_folder", function(folderId)
    print("[NativeSatchel] native_satchel:open_folder with ID", folderId)
end)

AddEventHandler("native_satchel:focus_folder", function(folderId)
    print("[NativeSatchel] native_satchel:focus_folder with ID", folderId)
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
