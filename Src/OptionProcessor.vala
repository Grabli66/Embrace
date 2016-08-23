/*
*   Process args
*/
[Compact]
internal class OptionProcessor { 
    private static bool isInit;

    private static bool isUpdate;

    private static bool isBuild;

    private static bool isTest;

    private static bool isClean;

    private const GLib.OptionEntry[] options = {
        { "init", 0, 0, OptionArg.NONE, ref isInit, "Initialize new project", null },
        { "update", 0, 0, OptionArg.NONE, ref isUpdate, "Update all dependencies", null },
        { "build", 0, 0, OptionArg.NONE, ref isBuild, "Build project", null },
        { "test", 0, 0, OptionArg.NONE, ref isTest, "Run tests", null },
        { "clean", 0, 0, OptionArg.NONE, ref isClean, "Clean project", null },
        { null }
    };

    public static void Process (string[] args) {
        if (args.length < 2) {
            InfoLn ("Run '%s --help' to see a full list of available command line options.\n".printf (args[0]));
            return;
        }

        try {
            var optionContext = new OptionContext ("- Vala project and dependency manager");
            optionContext.set_help_enabled (true);
            optionContext.add_main_entries (options, null);
            optionContext.parse (ref args);
        } catch (OptionError e) {
            ErrorLn (e.message);
        }

        if (isInit) {
            InitCommand.Process ();
            return;
        }

        if (isBuild) {
            BuildCommand.Process ();
            return;
        }

        if (isTest) {
            TestCommand.Process ();
            return;
        }
    }
}