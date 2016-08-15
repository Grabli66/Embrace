/*
*   Process init command
*/
[Compact]
internal class InitCommand {
    /*
    *   New project content
    */
    private const string PROJECT_CONTENT = 
    "
    {
        \"Name\" : \"%s\",
        \"Description\" : \"\",
        \"Version\" : \"0.1\",
        \"AppType\" : \"console\",
        \"Source\" : [\"./Src\"],
        \"OutPath\" : \"./Bin\",
        \"Dependency\" : [
        ]
    }
    ";

    /*
    *   Process command
    */
    public static void Process (string projectName) {
        InfoLn ("Init new project %s".printf (projectName));
        try {
            var file = File.new_for_path (Global.PROJECT_NAME);
            if (file.query_exists ()) throw new Errors.Common ("Project already exists");

            var fstr = file.append_to (FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (fstr);
            data_stream.put_string (PROJECT_CONTENT.printf (projectName));
            InfoLn ("Done");
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}