/*
*   Build and run test project
*/
[Compact]
internal class TestCommand {
    /*
    *   Process command
    */
    public static void Process () {
        try {            
            InfoLn ("Running tests");
            var project = new Project (".");
            Posix.chdir (project.Tests);
            project = new Project (".");
            BuildCommand.BuildProject (project);
            var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, "tests");
            GLib.Process.spawn_command_line_sync (outPath);            
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}