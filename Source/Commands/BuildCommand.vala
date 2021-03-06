/*
*   Process build command
*/
[Compact]
internal class BuildCommand {
    /*
    *   Update project dependency
    */
    public static void ProcessDependency (Project project) throws Errors.Common {
        foreach (var depName in project.Dependency) {
            var depManager = DependencyFactory.GetManager (depName, project);
            depManager.CheckDependency ();
        }
    }

    /*
    *   Build project
    */
    public static void BuildProject (Project project) throws Errors.Common {        
        var sources = project.GetAllSources ();
        var libs = project.GetAllLibs ();

        var argList = new Gee.ArrayList<string> ();

        try {
            var buildPath = FileUtils.GetShortPath (FileUtils.JoinPath (project.ProjectPath, project.OutPath));
            FileUtils.PreparePath (buildPath);
            var name = project.Name.down ();

            argList.add ("valac");
            foreach (var src in sources) {
                argList.add (src);
            }

            foreach (var lib in libs) {
                argList.add (@"--pkg=$(lib)");
            }
            
            if (project.ProjectType == ProjectTypeEnum.APP || project.ProjectType == ProjectTypeEnum.TESTS) {
                argList.add ("-o");                
                var outPath = Path.build_path (Global.DIR_SEPARATOR, buildPath, name);
                argList.add (outPath);
            }  else if (project.ProjectType == ProjectTypeEnum.LIBRARY) {
                var outBin = Path.build_path (Global.DIR_SEPARATOR, buildPath, @"$(name).so");
                var outVapi= Path.build_path (Global.DIR_SEPARATOR, buildPath, @"$(name).vapi");
                argList.add ("--library");
                argList.add (name);
                argList.add ("--vapi");
                argList.add (outVapi);
                argList.add ("-X");
                argList.add ("-fPIC");
                argList.add ("-X");
                argList.add ("-shared");
                argList.add ("-o");
                argList.add (outBin);
            }

            var argArr = argList.to_array ();
            var commandLine = string.joinv (" ", argArr);
            InfoLn (commandLine);
            GLib.Process.spawn_command_line_sync (commandLine);            
        } catch {
            throw new Errors.Common ("Cant compile sources");
        }
    }

    /*
    *   Build project
    */
    public static void BuildPath (string path = ".") {
        try {            
            var project = new Project (path);
            ProcessDependency (project);
            BuildProject (project);            
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }

    /*
    *   Process command
    */
    public static void Process () {
        InfoLn ("Building project");
        BuildPath ();        
    }
}