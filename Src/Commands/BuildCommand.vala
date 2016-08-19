[Compact]
internal class BuildCommand {
    /*
    *   Check project file exists
    */
    private static void CheckExists () throws Errors.Common {
        var file = File.new_for_path (Global.PROJECT_NAME);
        if (!file.query_exists ()) throw new Errors.Common ("Project not exists");
    }

    /*
    *   Update project dependency
    */
    private static void ProcessDependency () throws Errors.Common {
        var project = new Project (".");
        foreach (var depName in project.Dependency) {
            var depManager = DependencyFactory.GetManager (depName);
            depManager.CheckDependency ();
        }
    }

    /*
    *   Build project
    */
    private static void BuildProject () throws Errors.Common {
        var project = new Project (".");
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
        } catch (Error e) {
            ErrorLn (e.message);
            throw new Errors.Common ("Cant compile sources");
        }
    }

    /*
    *   Process command
    */
    public static void Process () {
        try {
            InfoLn ("Building project");
            CheckExists ();
            ProcessDependency ();
            BuildProject ();
            InfoLn ("Done");
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}