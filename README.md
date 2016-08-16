# Embrace
Project and dependency manager for vala

Project file format:
```json
{
    "Name" : "ProjectName",
    "Description" : "",
    "Version" : "0.1",
    "AppType" : "console",
    "Source" : ["./Src"],
    "OutPath" : "./Bin",
    "Libs" : [
        "gee-0.8"
    ],
    "Dependency" : [
        "http://github/User/SomeProject"
    ]
}
```
