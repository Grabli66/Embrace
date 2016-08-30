# Embrace
Project and dependency manager for vala

Project file format:
```javascript
{
    "Name" : "ProjectName",
    "Description" : "Some project description",
    "Tags" : ["console", "tool", "net"],
    "Version" : "0.1",
    "AppType" : "app",
    "Source" : ["./Src"],
    "Tests" : "./Tests",
    "OutPath" : "./Bin",
    "Dependency" : [
        "lib://gee-0.8",
        "http://github.com/User/EmbraceProject",
        "path://../EmbraceProject"
    ]
}
```

# Usage.

Create new project (WORK): 
#### embrace --init

Build project (WORK):
#### embrace --build

Run tests (WORK):
#### embrace --test

Update project dependency (NOT WORK):
#### embrace --update
