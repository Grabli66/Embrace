[Compact]
internal class BuildCommand {
    /*
    *   Prepare DEPS path
    */
    private static void PreparePath () throws Error {
        var file = File.new_for_path ("./Bin");
        if (!file.query_exists ()) {
            file.make_directory ();
        }
    }

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
            DependencyManager.CheckDependency (depName);
        }
    }

    /*
    *   Build project
    */
    private static void BuildProject () throws Errors.Common {
        var project = new Project (".");
        var sources = project.GetAllSources ();

        var argList = new Gee.ArrayList<string> ();
        try {
            PreparePath ();
            argList.add ("valac");
            foreach (var src in sources) {
                argList.add (src);
            }
            GLib.Process.spawn_sync (".", argList.to_array (), Environ.get (), SpawnFlags.SEARCH_PATH, null);
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