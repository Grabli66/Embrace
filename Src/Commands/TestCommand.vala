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
            var project = new Project (".");
            BuildCommand.BuildPath (project.Tests);
            var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, "tests");
            GLib.Process.spawn_command_line_sync (outPath);
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}