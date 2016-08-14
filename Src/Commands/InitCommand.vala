[Compact]
internal class InitCommand {
    private const string PROJECT_CONTENT = 
    "
    {
        \"Name\" : \"%s\",
        \"Description\" : \"\",
        \"Version\" : \"0.1\",
        \"AppType\" : \"console\",
        \"Sources\" : [\"./Src/*\"],
        \"OutPath\" : \"./Bin\",
        \"Dependency\" : [
        ]
    }
    ";

    public static void Process (string projectName) {
        InfoLn ("Init new project %s".printf (projectName));
        try {
            var file = File.new_for_path ("project.vprj");
            var fstr = file.append_to (FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (fstr);
            data_stream.put_string (PROJECT_CONTENT.printf (projectName));
        } catch (Error e) {
            ErrorLn (e.message);
        }
        InfoLn ("Done");
    }
}