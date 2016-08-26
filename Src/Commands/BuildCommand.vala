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
            var depManager = DependencyFactory.GetManager (depName);
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
            FileUtils.PreparePath (project.OutPath);
            var name = project.Name.down ();

            argList.add ("valac");
            foreach (var src in sources) {
                argList.add (src);
            }

            foreach (var lib in libs) {
                argList.add (@"--pkg=$(lib)");
            }
            
            if (project.ProjectType == ProjectTypeEnum.APP) {
                argList.add ("-o");
                var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, name);
                argList.add (outPath);
            }  else if (project.ProjectType == ProjectTypeEnum.LIBRARY) {
                var outBin = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, @"$(name).so");
                var outVapi= Path.build_path (Global.DIR_SEPARATOR, project.OutPath, @"$(name).vapi");
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
            InfoLn ("Building project");
            var project = new Project (path);
            ProcessDependency (project);
            BuildProject (project);
            InfoLn ("Done");
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }

    /*
    *   Process command
    */
    public static void Process () {
        BuildPath ();
    }
}