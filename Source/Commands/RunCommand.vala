/*
*  Build and run project
*/
[Compact]
internal class RunCommand {
    /*
    *   Process command
    */
    public static void Process () {
        BuildCommand.Process ();
        try {
            var project = new Project (".");
            var name = project.Name.down ();
            var outPath = Path.build_path (Global.DIR_SEPARATOR, project.OutPath, name);
            GLib.Process.spawn_command_line_sync (outPath);
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}