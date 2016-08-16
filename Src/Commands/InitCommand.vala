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
        \"Name\" : \"ProjectName\",
        \"Description\" : \"\",
        \"Version\" : \"0.1\",
        \"AppType\" : \"console\",
        \"Source\" : [\"./Src\"],
        \"OutPath\" : \"./Bin\",
        \"Libs\" : [
        ],
        \"Dependency\" : [
        ]
    }
    ";

    /*
    *   Process command
    */
    public static void Process () {
        InfoLn ("Init new project");
        try {
            var file = File.new_for_path (Global.PROJECT_NAME);
            if (file.query_exists ()) throw new Errors.Common ("Project already exists");

            var fstr = file.append_to (FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (fstr);
            data_stream.put_string (PROJECT_CONTENT);
            InfoLn ("Done");
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}