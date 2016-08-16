# Embrace
Project and dependency manager for vala

Project file format:
```javascript
{
    "Name" : "ProjectName",
    "Description" : "Some project description",
    "Tags" : ["console", "tool", "net"],
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

# Usage.

Create new project (WORK): 
##### embrace --init

Build project (PARTIALY WORK):
##### embrace --build

Update project dependency (NOT WORK):
##### embrace --update

Clean project from unused files (NOT WORK):
#####embrace --clean
