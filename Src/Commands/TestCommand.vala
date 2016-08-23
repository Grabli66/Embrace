/*
*   Process test command
*/
[Compact]
internal class TestCommand {
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
    private static void BuildTestProject () throws Errors.Common {
        var project = new Project (".");
        var sources = project.GetAllSources ();
        var testSources = project.GetTestSources ();
        var libs = project.GetAllLibs ();

        var argList = new Gee.ArrayList<string> ();

        try {
            FileUtils.PreparePath (project.OutPath);

            argList.add ("valac");
            foreach (var src in sources) {
                argList.add (src);
            }

            foreach (var src in testSources) {
                argList.add (src);
            }

            foreach (var lib in libs) {
                argList.add (@"--pkg=$(lib)");
            }
            
            argList.add ("-o");
            var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, Global.TESTS_OUT_NAME);
            argList.add (outPath);

            var argArr = argList.to_array ();
            var commandLine = string.joinv (" ", argArr);
            InfoLn (commandLine);
            GLib.Process.spawn_command_line_sync (commandLine);
        } catch (Error e) {
            ErrorLn (e.message);
            throw new Errors.Common ("Cant compile sources");
        }
    }

    private static void RunTests () throws Errors.Common {
        try {
            var project = new Project (".");
            var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, Global.TESTS_OUT_NAME);
            GLib.Process.spawn_command_line_sync (outPath);
        } catch {
            throw new Errors.Common ("Cant run tests");
        }
    }

    /*
    *   Process command
    */
    public static void Process () {
        try {
            InfoLn ("Building tests");
            Project.CheckExists (Global.PROJECT_NAME);
            ProcessDependency ();
            BuildTestProject ();
            InfoLn ("Run tests");
            RunTests ();
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}